Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947184Ab3BHVOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:14:10 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:52070 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947170Ab3BHVOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:14:08 -0500
MIME-Version: 1.0
In-Reply-To: <1360357636.18083.19.camel@x230.lan>
References: <20130208191213.GA25081@www.outflux.net>
	<00780235-deac-4f80-b936-867834e05661@email.android.com>
	<CAGXu5jJnLY6Qp3J6HBpVg-AdUGdKYm-e4wErZO3=NuRo04ajvg@mail.gmail.com>
	<5115553A.5000708@zytor.com>
	<CAGXu5j+_mGzR+72YqORhErMUY1aF1H2urczZ8SwuJHZK-oZL6g@mail.gmail.com>
	<dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
	<CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>
	<1360355671.18083.18.camel@x230.lan>
	<CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>
	<1360357636.18083.19.camel@x230.lan>
Date: Fri, 8 Feb 2013 16:14:07 -0500
Message-ID: <CA+5PVA4EbgBRgg+ZDa4+vG0Ngw8wJ3kH6NcmDvZ=+CP=kH82_A@mail.gmail.com>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
From: Josh Boyer <jwboyer@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Kees Cook <keescook@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 8, 2013 at 4:07 PM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> On Fri, 2013-02-08 at 13:02 -0800, Kees Cook wrote:
>
>> I don't find it unreasonable to drop all caps and lose access to
>> sensitive things. :) That's sort of the point, really. I think a cap
>> is the best match. It seems like it should either be a cap or a
>> namespace flag, but the latter seems messy.
>
> Yeah, I think it's an expected outcome, but it means that if (say) qemu
> drops privileges, qemu can no longer access PCI resources - even on
> non-secure boot systems. That breaks existing userspace.

Right.  We've had a few reports in Fedora of things breaking on non-SB
systems because of this.  The qemu one is the latest, but the general
problem is people think dropping all caps blindly is making their apps
safer.  Then they find they can't do things they could do before the new
cap was added.  It's messy.

I've thought of treating CAP_COMPROMISE_KERNEL as a hidden cap, where
only the kernel can grant or drop it.  Peter Jones suggested it might
work to allow it to be dropped iff it is the only cap being changed.
Either way, it's a "special" cap and I have no idea how acceptable
something like that would be.

Really though, the main issue is that you cannot introduce new caps to
enforce finer grained access without breaking something.

josh
