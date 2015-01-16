Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbbAPKvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:51:25 -0500
Received: from www.linutronix.de ([62.245.132.108]:33180 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbbAPKvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:51:21 -0500
Message-ID: <54B8ED20.60308@linutronix.de>
Date: Fri, 16 Jan 2015 11:51:12 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        monstr@monstr.eu
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Cox <alan@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] tty: serial: 8250_core: Check that port->line is
 >=0
References: <3293c93689f5d8c684133a9d9952411a201609dc.1421333585.git.michal.simek@xilinx.com> <d3a26f5ecd44e1415f213e6ee7f33005c1b23f4a.1421333585.git.michal.simek@xilinx.com> <54B8D32E.5000805@linutronix.de> <df5d7450de9f4382b1cb43791f69e25c@BL2FFO11FD013.protection.gbl>
In-Reply-To: <df5d7450de9f4382b1cb43791f69e25c@BL2FFO11FD013.protection.gbl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Yoshihiro YUNOMAE
(reason: 550 5.1.1 <yoshihiro.yunomae.ez@hitachi.com>: Recipient
address rejected: User Unknown)

On 01/16/2015 11:37 AM, Michal Simek wrote:
> Hi,

Hi,

> Origin patch looks good to me but this checking will be good to add.
> Are you using of_serial.c because I didn't find any of_alias_get_id call
> for 8250?

I'm using of_alias_get_id() in 8250_omap.c which made it into
v3.19-rc1. I think the change you mention made it one release earlier.

> Your logic here is a little bit different than I have in my tree.
> (Some sort of pl011 solution). You don't need to failed if you port.line is
> below 0 but if you are not able to read aliases port enumeration
> may be unpredictable.

For omap we should have valid aliases because we have multiple UARTs.
So the platform id should always be >=0 and the DT includes it already.
And Tony wanted to have predicted numbers so I don't mind to fail here.
Also it is nice if you have ttyS2 which maps UART2 in the manual even
without having ttyS[01].

> Thanks,
> Michal

Sebastian

