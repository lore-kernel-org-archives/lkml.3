Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab3H2RX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:23:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60455 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab3H2RX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:23:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [PATCH RFC v2 11/16] ARM: socfpga: remove call to of_clk_init
Date: Thu, 29 Aug 2013 19:23:12 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1377638890-371-12-git-send-email-sebastian.hesselbarth@gmail.com> <1377790696.26261.3.camel@linux-builds1>
In-Reply-To: <1377790696.26261.3.camel@linux-builds1>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308291923.13151.arnd@arndb.de>
X-Provags-ID: V02:K0:CkObaUUXvjxz1JDmyIibk+WAM15i577R1hApgZSlanZ
 36C1qQbwiUBSDYupb8e0rCkr47iJ9KUyB9Hdr/lczeTDUK06WP
 yZklQ9bKR0phgk2esmBX2nxTsHIfsqpA9m6doQ6zY6eCB8EVA3
 C1tssg+a0NgIqcck7N8FCxLewc3Y9MVtBtzRnLqKrxlO/iWnmF
 s06jalM2pWG18z1mBF3rYK7ziJk2QJsAu6USSa1w44PxPHSSfK
 GD42VCgPl6nKxt3qNfJoBHWM46aBI/jkX6A6TuWrLXFKBkZoHx
 Lt3dL9F6hXTGRQlnm3rm1ZERUQmAWIkrYZdkuT7K4zruT2fA+Q
 anKpycmI5sNeZOzTWTAw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 August 2013, Dinh Nguyen wrote:
> On Tue, 2013-08-27 at 23:28 +0200, Sebastian Hesselbarth wrote:

> > @@ -107,7 +106,6 @@ static void __init socfpga_cyclone5_init(void)
> >  {
> >  	l2x0_of_init(0, ~0UL);
> >  	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> > -	of_clk_init(NULL);
> >  	socfpga_init_clocks();
> >  }
> >  
> 
> Acked-by: Dinh Nguyen <dinguyen@altera.com>

I saw that your socfpga_init_clocks() function only has these contents:

void __init socfpga_init_clocks(void)
{
        struct clk *clk;
        int ret;

        clk = clk_register_fixed_factor(NULL, "smp_twd", "mpuclk", 0, 1, 4);
        ret = clk_register_clkdev(clk, NULL, "smp_twd");
        if (ret)
                pr_err("smp_twd alias not registered\n");
}


I think that can easily be expressed with DT syntax now (correct me if I'm wrong), so
you should be able to kill this off as well. Once somebody gets around to automate
the l2x0 setup, the entire socfpga_cyclone5_init() function can go away too.

	Arnd
