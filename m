Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaFMLfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 07:35:38 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:59068 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaFMLfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 07:35:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAFEAcA-qJtr+n3c5QMp0KxgxrvKzjms2hu-HjscrETgZO9vpMg@mail.gmail.com>
References: <CALAqxLWAXU0hS8si-CmkOObBOHGv_skMVfPnUsdmLcZzkdUsWA@mail.gmail.com>
	<CAPDyKFocVLryEyP-mBrHU8ZNJaX22uaA__s8iGYcmH9t9RiZQw@mail.gmail.com>
	<CAFEAcA-qJtr+n3c5QMp0KxgxrvKzjms2hu-HjscrETgZO9vpMg@mail.gmail.com>
Date: Fri, 13 Jun 2014 13:35:36 +0200
Message-ID: <CAPDyKFqS=O72zW6mMvjCd42EPdZnsiQSNbvZxQ2DW8rDDPOLSA@mail.gmail.com>
Subject: Re: [Regression] 3.15 mmc related ext4 corruption with qemu-system-arm
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>, Chris Ball <chris@printf.net>,
        Johan Rudholm <jrudholm@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 June 2014 14:15, Peter Maydell <peter.maydell@linaro.org> wrote:
> On 12 June 2014 13:09, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> A simple fix; for the arm_variant, go back to use the old behaviour.
>>
>> A quite simple fix; Invent a new primecell-periphid and a new
>> corresponding variant and use the old behaviour for this variant. The
>> new primecell-periphid then needs to be provided through DT for the
>> QEMU dtb.
>>
>> Is there any of the above solution you see as the preferred one?
>
> Those both sound like workarounds, not fixes, to me. Somebody
> needs to identify whether the bug here is in:
>  * the kernel (unlikely, but possibly the kernel has a race
>    condition that only gets triggered by QEMU's "operations
>    that take time in h/w happen instantaneously in emulation"
>    behaviour)
>  * the QEMU model of the PL181
>  * the QEMU model of the SD card
> and then fix whichever of these is not conforming to the
> specs/docs/etc.

You are right. But...

Since we (or actually me) have made the ARM model to break (it worked
nicely before), I just wanted to restore the behaviour as a quick fix.
I believe going into this in detail can take some more time,
especially if it's related to the ARM model, right!?

Kind regards
Uffe

>
> Also, there's no such thing as a "QEMU dtb", at least for
> most of our board models. QEMU models the actual hardware
> (sometimes buggily or incompletely) and so should use the
> exact same dtb you would use with the hardware.
>
> thanks
> -- PMM
