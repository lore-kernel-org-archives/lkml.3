Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab3I0PCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:02:19 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51287 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752318Ab3I0PCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:02:17 -0400
Date: Fri, 27 Sep 2013 16:01:57 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUERY] Building and testing Aarch64
Message-ID: <20130927150156.GE26069@arm.com>
References: <CALkWK0mwRbBkM=qvQPoyR+kEs8HwLx9P7bWWQnst_Z1=DRFkRA@mail.gmail.com>
 <CAHkRjk5_ep4poYY9gzcDgqaPuDtz2sgeZ0KPO6TqHttj-cS3xw@mail.gmail.com>
 <CALkWK0=YdxF43RQ-Fddp4Rzmx3aU3QdOPrjR=X+s6Wt9_RAYUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0=YdxF43RQ-Fddp4Rzmx3aU3QdOPrjR=X+s6Wt9_RAYUg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 03:43:21PM +0100, Ramkumar Ramachandra wrote:
> Catalin Marinas wrote:
> > ARM provides an emulator, ARMv8 Foundation Model (free as in free beer
> > but you need to register to be able to download, just like the
> > architecture documentation):
> >
> > http://www.arm.com/products/tools/models/fast-models/foundation-model.php
> 
> I downloaded the foundation model and ran:
> 
>   $ ./Foundation_v8 --image linux-system-foundation.axf --block-device
> debian-arm-rootfs
> 
> as described in the Debian page [1]. However, I didn't understand how
> to boot it up with the kernel I just built with my toolchain
> (arch/arm64/boot/Image.gz). What is this linux-system-foundation.axf?

The .axf file is something traditionally called ARM eXecutable Format,
which these days it's just an ELF format that the model can load
directly. The above code contains the pre-Linux boot initialisation, the
kernel Image (uncompressed, doesn't have a decompressor) and possibly a
filesystem, unless you use the --block-device model option. To get the
boot wrapper, just clone this:

git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/boot-wrapper-aarch64.git

The README and Makefile should be enough to get you started.

> Also, what is libarmctmodel.so?

I think that's the library that contains the actual software model.

-- 
Catalin
