Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722Ab3BLS3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:29:40 -0500
Received: from smtprelay0019.b.hostedemail.com ([64.98.42.19]:60839 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933532Ab3BLS3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:29:38 -0500
X-Panda: scanned!
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 4098
Date: Tue, 12 Feb 2013 18:29:35 +0000 (UTC)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: torvalds@linux-foundation.org
Cc: bhelgaas@google.com, linux-kernel@vger.kernel.org
Message-ID: <1362466310.40337.1360693775935.JavaMail.mail@webmail03>
References: <587312497.6453.1360650312498.JavaMail.mail@webmail01><CA+55aFyscOeZUPaYj_-QYgjADPD59+=c5aMvtpPEnd1tmpUGiA@mail.gmail.com>
Subject: Re: Abysmal HDD/USB write speed after sleep on a UEFI system
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.146.68.3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feb 12, 2013 11:30:20 PM, Linus Torvalds wrote:
>On Mon, Feb 11, 2013 at 10:25 PM, Artem S. Tashkinov wrote:
>> Hello Linus,
>>
>> I  've already posted a bug report (https://bugzilla.kernel.org/show_bug.cgi?id=53551),
>> a message to LKML (http://lkml.indiana.edu/hypermail/linux/kernel/1302.1/00837.html)
>> and so far I  've received zero response even though the bug is quite critical as it prevents
>> me from using suspend altogether.
>>
>> I wonder if you could tell me who is responsible for this problem and who I need to CC in
>> bugzilla.
>
>According to your bugzilla it doesn  't really seem to be strictly
>UEFI-specific, and it  's hard to tell what subsystem is to blame.
>
>A few things to try to pinpoint:
>
> (a) Is it *only* write performance that suffers, or is it other
>performance too? Networking (DMA? Perhaps only writing *to* the
>network?)? CPU?

I've tested hdpard -tT --direct and the output on boot and after suspend
is quite similar.

I've also checked my network read/write speed, and it's the same
~ 100MBit/sec (I have no 1Gbit computers on my network
unfortunately).

>
> (b) the fact that it apparently happens with both SATA and USB
>implies that it  's neither, and is more likely something core like
>memory speed (mtrr, caching) or PCI (DMA, burst sizes, whatever).

I've no idea, please, check my bug report where I've just added lots of
information including a diff between on boot and after suspend.

lspci outputs differ quite substantially, but the things that have change
say nothing to me - you'll want to see it for yourself. I see changes like:

-                       Changed: MRL- PresDet- LinkState-
+                       Changed: MRL- PresDet+ LinkState-

i.e. PresDet minus to PresDet plus.

-               Address: 00000000fee0f00c  Data: 41e1
+               Address: 0000000000000000  Data: 0000

-       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- TAbort- 
> (c) can you find anything that changes over the suspend/resume? IOW,
>look at things like "lspci -vvxxx" before-and-after, and see what
>changed on the bridges leading to both things etc.
>
>The performance drop sounds extreme enough that it sounds like caches
>got disabled or something, but that should show up as CPU performance
>in general being slow, not just writes to disk. But basically, I think
>we need more clues about which sub-area is actually the culprit. My
>*guess* would be some core PCI thing not being initialized, but I
>don  't see how you could even make PCI go that slow. Interrupt
>problems? DMA failures? I have no idea.
>
>Has it ever worked? Suspend on desktop motherboards used to be quite
>spotty (nobody ever used it, manufacturers didn  't care), but it
>generally has gotten better since people use it more these days..

I remember it used to work before, but I've never suspended more than once
during one boot session before (this time I did it out of pure curiosity) and
I've never run Linux from UEFI.

>
>Added lkml and Bjorn to the participants, in case anybody has any ideas..
>

I'll gladly provide any information you need.

Thanks a lot,

Artem
