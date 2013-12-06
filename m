Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab3LFC4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 21:56:07 -0500
Received: from zimbra.real-time.com ([63.170.91.9]:54624 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab3LFC4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 21:56:05 -0500
Date: Fri, 6 Dec 2013 13:55:41 +1100
From: James Cameron <quozl@laptop.org>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Crispin <blogic@openwrt.org>, Jiri Slaby <jslaby@suse.cz>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        Zhou Zhu <zzhu3@marvell.com>
Subject: Re: [PATCH] serial: rewrite pxa2xx-uart to use 8250_core
Message-ID: <20131206025541.GL16425@us.netrek.org>
References: <20131205043544.GA28580@kroah.com>
 <1386286149-2855-1-git-send-email-ynvich@gmail.com>
 <20131206003851.GI16425@us.netrek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131206003851.GI16425@us.netrek.org>
Organization: Netrek Vanilla Server Dictator
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 11:38:51AM +1100, James Cameron wrote:
> On Fri, Dec 06, 2013 at 03:28:37AM +0400, Sergei Ianovich wrote:
> > pxa2xx-uart was a separate uart platform driver. It was declaring
> > the same device names and numbers as 8250 driver. As a result,
> > it was impossible to use 8250 driver on PXA SoCs.
> > 
> > Upon closer examination pxa2xx-uart turned out to be a clone of
> > 8250_core driver.
> 
> I'm testing this backported to 3.5 on the OLPC XO-4 [1] [2].
> 
> As Russell says, the getty had to change, but after that the shell
> worked fine; no more or no less responsive.
> 
> What hasn't worked yet is the console; no kernel messages appear.  I
> have tried changing command line to console=ttyS0,115200.

My error.  Our kernel had CONFIG_CMDLINE set, changing that fixed it.
Console is working fine.

-- 
James Cameron
http://quozl.linux.org.au/
