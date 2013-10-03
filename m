Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab3JCS2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:28:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49705 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929Ab3JCS2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:28:49 -0400
Date: Thu, 3 Oct 2013 20:28:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Kernel mailing list <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@redhat.com>
Subject: Re: [PATCH 1/1] x86_64: add config options to optimize for newer AMD
 processors
Message-ID: <20131003182845.GB17417@pd.tnic>
References: <52486938.4090009@gmail.com>
 <20130929180101.GB5490@pd.tnic>
 <5248905E.8000801@gmail.com>
 <20130929205051.GD5426@pd.tnic>
 <52489A59.7040108@gmail.com>
 <20130929213026.GF5426@pd.tnic>
 <524D5DAC.3000004@gmail.com>
 <CA+55aFwuV4u3ky-XT_P_sCOYjqUW1EvA3Q2NuZ=+LZ5O06jS3g@mail.gmail.com>
 <20131003165740.GA17417@pd.tnic>
 <524DB377.2070909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <524DB377.2070909@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 02:12:07PM -0400, Austin S Hemmelgarn wrote:
> Part of the difference between our results may be that I have my
> entire userspace built with -mtune=bdver2, so less of the time is
> spent in userspace.

That still cannot explain the huge difference between building on a
mk8 vs bdver2 kernel. Provided your userspace is the same and only the
kernels are different, I don't see how that happens.

Btw, you could run my workload on your machine, once on an mk8 kernel
and once on a bdver2 one.

The contents of the pre-build-kernel.sh script are:

--
#!/bin/bash

make -s clean
echo 3 > /proc/sys/vm/drop_caches
--

Of course, you need to run this as root.

> Also, the part about using many more threads than cpu cores was with
> regards to sysbench, not the kernel build, for that I just used 8 jobs
> in make.

Overcommitting gcc threads does not bring a really a big difference with
a kernel build.

> With regards to the differences shown above relative to CONFIG_MK8,
> that does actually make sense; with CONFIG_MK8, gcc makes very minimal
> use of extension instructions (afaik, only MMX, SSE, and 3Dnow!), this
> improves performance slightly on bulldozer derivatives because there
> are only half as many SSE and FP units as CPU cores (and the

yes, the FPU is shared between the cores of a compute unit on BD.

> scheduler isn't as smart as it could be with regards to that, but that
> is something for another patch as far as I am concerned).

Again, with unchanging userspace and only differing kernels, you
shouldn't be seeing such a big difference. Besides, the kernel itself
makes very little, if at all, use of FPU instructions.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
