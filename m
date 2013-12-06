Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161010Ab3LFLF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 06:05:58 -0500
Received: from zimbra.real-time.com ([63.170.91.9]:44825 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab3LFLF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 06:05:56 -0500
Date: Fri, 6 Dec 2013 22:05:43 +1100
From: James Cameron <quozl@laptop.org>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Crispin <blogic@openwrt.org>, Jiri Slaby <jslaby@suse.cz>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        Zhou Zhu <zzhu3@marvell.com>
Subject: Re: [PATCH] serial: rewrite pxa2xx-uart to use 8250_core
Message-ID: <20131206110542.GA14652@us.netrek.org>
References: <20131205043544.GA28580@kroah.com>
 <1386286149-2855-1-git-send-email-ynvich@gmail.com>
 <20131206000253.GC21358@kroah.com>
 <20131206001728.GJ4360@n2100.arm.linux.org.uk>
 <1386322131.7152.36.camel@host5.omatika.ru>
 <20131206095345.GQ16425@us.netrek.org>
 <1386326057.7152.44.camel@host5.omatika.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386326057.7152.44.camel@host5.omatika.ru>
Organization: Netrek Vanilla Server Dictator
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 02:34:17PM +0400, Sergei Ianovich wrote:
> On Fri, 2013-12-06 at 20:53 +1100, James Cameron wrote:
> > I don't understand why /dev/ttyS2 (4,66) changed to /dev/ttyS0 (4,64)
> > after the patch was applied to olpc-kernel/arm-3.5 but, as you say it
> > doesn't change, perhaps there is something between 3.5 and now for me
> > to watch out for.  My problem.
> 
> The old pxa.c set device ids explicitly:
> -static int serial_pxa_probe_dt(struct platform_device *pdev,
> -                              struct uart_pxa_port *sport)
> -{
> -       struct device_node *np = pdev->dev.of_node;
> -       int ret;
> -
> -       if (!np)
> -               return 1;
> -
> -       ret = of_alias_get_id(np, "serial");
> -       if (ret < 0) {
> -               dev_err(&pdev->dev, "failed to get alias id, errno %d
> \n", ret);
> -               return ret;
> -       }
> -       sport->port.line = ret;
> -       return 0;
> -}
> 
> and
> 
> -       ret = serial_pxa_probe_dt(dev, sport);
> -       if (ret > 0)
> -               sport->port.line = dev->id;
> 
> 
> However, this is not possible with 8250_core. The latter assigns device
> ids strictly in the call order of serial8250_register_8250_port().
> 
> Hope it helps.

Yes, thanks, that explains it.

Your patch deprecates the use of property "linux,unit#" in the device
tree for serial ports, or the numbering according to the ordering of
the device tree.

(On OLPC XO-4, we set the numbering according to the ordering, we don't
use "linux,unit#".)

It is sad to see device tree sawdust.  ;-)

-- 
James Cameron
http://quozl.linux.org.au/
