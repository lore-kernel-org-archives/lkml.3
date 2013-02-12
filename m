Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346Ab3BLTc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 14:32:56 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:49400 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933170Ab3BLTcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 14:32:54 -0500
MIME-Version: 1.0
In-Reply-To: <1362466310.40337.1360693775935.JavaMail.mail@webmail03>
References: <587312497.6453.1360650312498.JavaMail.mail@webmail01>
 <CA+55aFyscOeZUPaYj_-QYgjADPD59+=c5aMvtpPEnd1tmpUGiA@mail.gmail.com> <1362466310.40337.1360693775935.JavaMail.mail@webmail03>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Feb 2013 11:32:31 -0800
X-Google-Sender-Auth: eAlIggPVaufU5g5h2K0XIefvKTU
Message-ID: <CA+55aFyK1zhNerWHkd=FMMeTH_sfiL4sBFq00y4n5eAJ88Z_cA@mail.gmail.com>
Subject: Re: Abysmal HDD/USB write speed after sleep on a UEFI system
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 10:29 AM, Artem S. Tashkinov <t.artem@lycos.com> wrote:
> Feb 12, 2013 11:30:20 PM, Linus Torvalds wrote:
>>
>>A few things to try to pinpoint:
>>
>> (a) Is it *only* write performance that suffers, or is it other
>>performance too? Networking (DMA? Perhaps only writing *to* the
>>network?)? CPU?
>
> I've tested hdpard -tT --direct and the output on boot and after suspend
> is quite similar.
>
> I've also checked my network read/write speed, and it's the same
> ~ 100MBit/sec (I have no 1Gbit computers on my network
> unfortunately).

Ok. So it really sounds like just USB and HD writes. Which is quite
odd, since they have basically nothing in common I can think of
(except the obvious block layer issues).

>> (b) the fact that it apparently happens with both SATA and USB
>>implies that it  's neither, and is more likely something core like
>>memory speed (mtrr, caching) or PCI (DMA, burst sizes, whatever).
>
> I've no idea, please, check my bug report where I've just added lots of
> information including a diff between on boot and after suspend.

I'm not seeing anything particularly interesting there.

Except why/how did the MSI address/data change for the SATA
controller? The irq itself hasn't changed.. There's probably some sane
reason for that too (it's an odd encoding, maybe they code for the
same thing), and there's nothing like that for USB, so...

And if it was irq problems, I'd expect you to see it more for reads
than for writes anyway. Along with a few messages about missed irqs
and whatever.

I'm stumped, and have no ideas. I can't even begin to guess how this
would happen. One thing to try is if it happens for all USB ports (you
have multiple controllers) and I assume performance doesn't come back
if you unplug and replug the USB disk..

                 Linus
