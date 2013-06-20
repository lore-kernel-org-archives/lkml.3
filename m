Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964981Ab3FTAOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 20:14:43 -0400
Received: from mailgw02.dd24.net ([193.46.215.43]:38851 "EHLO
	mailgw02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934375Ab3FTAOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 20:14:42 -0400
Message-ID: <1371687272.30351.13.camel@heisenberg.scientia.net>
Subject: Re: support for Intel Atom based QNAP LEDs/buttons/buzzer in Linux?
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-kernel@vger.kernel.org
Date: Thu, 20 Jun 2013 02:14:32 +0200
In-Reply-To: <1371259861.12984.6.camel@heisenberg.scientia.net>
References: <1371259861.12984.6.camel@heisenberg.scientia.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-15 at 03:31 +0200, Christoph Anton Mitterer wrote: 
> I wondered whether anyone knows, whether the kernel supports the
> LEDs/buttons/buzzer of Intel Atom based QNAP NAS like the TS-569 Pro?

I tried to find out some more information (and got some help there as
well)... seems I'm stuck now, though. So perhaps for the records (and if
there should ever be someone with more experience in hardware
programming) what I found:



According[0] do Ian Campbell, who maintains qcontrol[1], the ARM based
QNAP devices have UART interface to their PIC controller (which
apparently controls the LEDs, buzzers, etc.)... it seems though that the
Intel based ones (or at least the one I have), doesn't have this - well
there is a serial device, but I guess it's just a "normal" one as
nothing happens when I send the (supposed) commands to it.

Actually I personally would have preferred being able to control the
stuff without the need for a kernel driver... a pity that I couldn't get
it running.


QNAP itself seems to have a kernel driver for all this...
On their website, they provide a GPL bundle[2], which, amongst others,
contains the sources to their kernel with many modifications (no single
patches provided, unfortunately o.O ).
This includes a drivers/qnap which seems to export a device /dev/pic
which their user space tools use to set the LEDs/etc. and that driver in
turn seems to use their modifications (GPIO stuff and so on) to the
kernel's it87 driver (according to Guenter - see below - they use a
IT8721).


I asked Guenter Roeck, who kindly had a look[3], but according to him,
the QNAP code cannot be easily taken over.


Well perhaps someone else with enough knowledge has time to look into
this,... or perhaps someone has some good contacts over at QNAP and is
able to lobby them to submit their code to the mainline kernel; I tried
to contact their support but got no answer.

Cheers,
Chris.


[0] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=712283
[1] https://gitorious.org/qcontrol/
[2] http://sourceforge.net/projects/qosgpl/files/latest/download
[3] https://github.com/groeck/it87/issues/1

