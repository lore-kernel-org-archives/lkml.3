Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaCMHIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 03:08:52 -0400
Received: from ns.horizon.com ([71.41.210.147]:20532 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751394AbaCMHIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 03:08:51 -0400
Date: 13 Mar 2014 03:08:46 -0400
Message-ID: <20140313070846.27888.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: torvalds@linux-foundation.org
Subject: Re: [PATCH v2] x86: Remove compat vdso support
Cc: hpa@linux.intel.com, linux@horizon.com, linux-kernel@vger.kernel.org,
        luto@amacapital.net
In-Reply-To: <CA+55aFz+OfvtXLxg4CA4C6GPGh8F_aDuG6nnFFCCBpjTPLP1zA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Leader spake:
> So 32-bit x86 is dead, dead, dead. There's absolutely no future to it.
> We're not adding new stuff to "future-proof" it.

I think you have a small error of perspective here.  I agree the future
for 32-bit kernels is very limited.  But this is about 32-bit binary
support, and lots of people run 32-bit binaries, even on 64-bit kernels.

The great majority of applications have no need for more than 4G of
address space and frequently people would rather avoid the pointer
bloat that going to 64 bits would cause.

The whole reason that the x32 ABI has been added to the kernel is to
better support this kind of application.  But non-long-mode binaries
are still a lowest common denominator.

E.g Firefox full releases come in 32- and 64-bit versions, but the
precompiled betas are 32-bit only.

It still may not be worth it, but 32-bit binaries will be with us
for a long time.
