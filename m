Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422998Ab3CVUh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 16:37:27 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:60934 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422911Ab3CVUhX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 16:37:23 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sekhar Nori <nsekhar@ti.com>, Sekhar Nori <nsekhar@ti.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <514C3E7C.3000705@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>, <arnd@arndb.de>,
        <linus.walleij@linaro.org>, <linux-kernel@vger.kernel.org>,
        <rob.herring@calxeda.com>, <linux-keystone@list.ti.com>,
        <viresh.linux@gmail.com>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <linux-arm-kernel@lists.infradead.org>
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
 <1351181518-11882-3-git-send-email-m-karicheri2@ti.com>
 <50950908.1060302@ti.com> <5097D6FC.7040202@ti.com>
 <20121110022254.18014.31873@nucleus> <50B4D6B1.3000903@ti.com>
 <20121127172900.21126.89528@nucleus> <50B6101C.30502@ti.com>
 <514C3E7C.3000705@ti.com>
Message-ID: <20130322203715.834.30085@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH v3 02/11] clk: davinci - add PSC clock driver
Date: Fri, 22 Mar 2013 13:37:15 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sekhar Nori (2013-03-22 04:20:28)
> Mike,
> 
> On 11/28/2012 6:52 PM, Sekhar Nori wrote:
> > On 11/27/2012 10:59 PM, Mike Turquette wrote:
> 
> >> Also have you looked into regmap?  Since you are defining your own clock
> >> type that might be something nice for you.
> > 
> > No, haven't looked at regmap yet. Will look at that.
> 
> I could get to this only now. regmap needs a valid struct device. We
> aren't modelling psc clocks as device so regmap cannot be used here.
> 

According to Murali's reply back in November it was still not known if
the PTCMD register was going to be concurrently accessed by sources
outside the clock framework.  If this is so then neither the existing
framework-level lock (e.g. enable_lock) nor the shared clock driver lock
(e.g. spinlock in struct clk_psc) are adequate.  You may need a device
driver which represents the PSC and use accessor functions to write to
those register which provide coordination.

Regards,
Mike

> Thanks,
> Sekhar
