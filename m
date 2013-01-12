Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab3ALNQG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 08:16:06 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:50027 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab3ALNQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 08:16:05 -0500
Date: Sat, 12 Jan 2013 14:16:02 +0100
From: Andreas Mohr <andi@lisas.de>
To: Woody Suwalski <terraluna977@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.8-rc1 - another regression on USB :-(
Message-ID: <20130112131602.GA32186@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50E438F7.7040403@gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Greg, Linus,
> It sounds insane, but after banging on the issue I have found out that 
> USB problem is caused (also in vanilla kernel) with a config change:
> USB-all built as modules - bad USB
> USB core built in, UHCI/EHCI modules -  semi functional - but 1Mb/s
> transfer
> USB core and UHCI EHCI built-in - bingo - no issues.
> 
> Could anybody duplicate that, or is it somehow my setup???

Since there was no additional reply here (needed) so far,
some of my (questionably relevant?) thoughts on this:

There's of course the EHCI vs. UHCI(/OHCI) duality
(EHCI host controller responsible for high speed transfers,
the other for 1.1 full speed, both serving the same port connectors).
So if the coordination between the two is a problem,
you might end up with merely full speed on a 2.0 port.

And with drivers builtin vs. module, the init sequence/timing
might possibly be affected - right?
Perhaps this got worsened by semi-recent driver init kernel changes?
(AFAIR the kernel was changed to init more things in parallel,
for faster bootup). So maybe that affected EHCI vs. UHCI coordination timing.

(taking many stabs in the dark here...)



I seem to have USB issues as well; for some storage devices
I cannot gain high speed currently, while e.g. for USB sticks that works -
and of course prior to disabling the BIOS's limit-to-1.1 setting
(doh! oh my...) that was very understandable, but AFAIK it's still not
reliable (maybe it's some of my local host controller troubleshooting commits...
need to git revert them).
Due to my woes originally being BIOS-originated I cannot provide any
hard evidence about any 3.7.x vs. 3.8.x breakage timeframe.


I noticed that I had PSU issues - the 5V rail was dangerously low;
resoldering/cleaning the PSU helped.
In your case the USB disconnects might hint at that as well - I'd
recommend installing an lm-sensors configuration (or check at BIOS
health page) like I did.
I'm in the process of compiling a small but hopefully helpful
USB troubleshooting document (voltage, EMI, ...).


I'm usually more or less current (currently on -rc2 plus local commits).

Andreas Mohr
