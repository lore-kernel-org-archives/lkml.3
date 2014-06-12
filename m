Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbaFLMQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:16:12 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:39044 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbaFLMQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:16:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFocVLryEyP-mBrHU8ZNJaX22uaA__s8iGYcmH9t9RiZQw@mail.gmail.com>
References: <CALAqxLWAXU0hS8si-CmkOObBOHGv_skMVfPnUsdmLcZzkdUsWA@mail.gmail.com>
 <CAPDyKFocVLryEyP-mBrHU8ZNJaX22uaA__s8iGYcmH9t9RiZQw@mail.gmail.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 12 Jun 2014 13:15:46 +0100
Message-ID: <CAFEAcA-qJtr+n3c5QMp0KxgxrvKzjms2hu-HjscrETgZO9vpMg@mail.gmail.com>
Subject: Re: [Regression] 3.15 mmc related ext4 corruption with qemu-system-arm
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>, Chris Ball <chris@printf.net>,
        Johan Rudholm <jrudholm@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 June 2014 13:09, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> A simple fix; for the arm_variant, go back to use the old behaviour.
>
> A quite simple fix; Invent a new primecell-periphid and a new
> corresponding variant and use the old behaviour for this variant. The
> new primecell-periphid then needs to be provided through DT for the
> QEMU dtb.
>
> Is there any of the above solution you see as the preferred one?

Those both sound like workarounds, not fixes, to me. Somebody
needs to identify whether the bug here is in:
 * the kernel (unlikely, but possibly the kernel has a race
   condition that only gets triggered by QEMU's "operations
   that take time in h/w happen instantaneously in emulation"
   behaviour)
 * the QEMU model of the PL181
 * the QEMU model of the SD card
and then fix whichever of these is not conforming to the
specs/docs/etc.

Also, there's no such thing as a "QEMU dtb", at least for
most of our board models. QEMU models the actual hardware
(sometimes buggily or incompletely) and so should use the
exact same dtb you would use with the hardware.

thanks
-- PMM
