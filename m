Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab3GHTom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 15:44:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:54582 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab3GHToh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 15:44:37 -0400
Message-ID: <51DB16A1.6010006@linutronix.de>
Date: Mon, 08 Jul 2013 21:44:33 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: linux-usb@vger.kernel.org, balbi@ti.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-omap@vger.kernel.org, kishon@ti.com
Subject: Re: [PATCH 0/5] Add phy support for AM335X platform using Generic
 PHy framework
References: <1373280201-31785-1-git-send-email-george.cherian@ti.com>
In-Reply-To: <1373280201-31785-1-git-send-email-george.cherian@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 12:43 PM, George Cherian wrote:
> This patch series adds phy support for AM335X platform.
> This patch series is based on Generic PHY framework [1]. 
> 
> 
> This series has
> 	- adds dual musb instances support for am335x platform (just for testing)
> 	- adds phy-amxxxx-usb driver used in AMxxxx platforms
> 	- adds dt  bindings for the phys
> 	- removes usb-phy and replaced with generic phy apis in glue layer

No, I don't like this all. You did the one thing I tried to avoid while
posting my quick-and-dirty phy driver recently: You duplicated a lot of
code which can be served by the nop driver and added only power
on/power off callbacks.
In numbers:
>  7 files changed, 316 insertions(+), 70 deletions(-)
vs
   2 files changed, 117 insertions, 12 deletions

I assumed you had also the OTG callbacks (set host/device mode) and
wake up but I don't see it there.
Adding a power regulator would do the same job, wouldn't it? If the phy
driver remains just doing power on/off I suggest simply adding a power
regulator. If it will do more I would move the am35xx specific bits
into a separate file and glue it to the nop driver.

What else? The abstraction in device tree is wrong. It remains wrong if
add stuff on top to it.
We need two nodes each one with a glue layer and a musb child node. The
instances crap in kernel has to vanish. Also that means your phy nodes
are wrong. This is not musb with two ports but two musb instances each
with one port.

Sebastian
