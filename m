Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaLEKkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:40:11 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:59255 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaLEKkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:40:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Olof Johansson <olof@lixom.net>, Alexander Graf <agraf@suse.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: Enable CONFIG_COMPAT also for 64k page size
Date: Fri, 05 Dec 2014 11:39:40 +0100
Message-ID: <3551792.oHatG1W6W1@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAOesGMi-sVTxdo8f7vNnYMgd+meBF+Gsf3Pk5VbHEPxv5Q6iDA@mail.gmail.com>
References: <1417707993-82290-1-git-send-email-agraf@suse.de> <5480F12D.90007@suse.de> <CAOesGMi-sVTxdo8f7vNnYMgd+meBF+Gsf3Pk5VbHEPxv5Q6iDA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:Bxw1mBxYNO+UXpNDEt8DNf8plZQb3Vidcy+vlCuta4SDI3WbtQQ
 MH3ACAFje057Ec9CG0lYRGyxlwPXQB9+VN5FnEQUzYu/o9xzkuvaIEXOqqq3EdfxLyKZ7ly
 u/tZ1B+upllIj652ekukWg/hp+sA4P7JU+VnWvDaXAS3oF491KXIeyEsTlXSQt2P4p9pGtX
 I6dKbtZO55WUUJEGHw/IQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2014 15:48:50 Olof Johansson wrote:
> On Thu, Dec 4, 2014 at 3:41 PM, Alexander Graf <agraf@suse.de> wrote:
> > On 04.12.14 22:15, Olof Johansson wrote:
> >> On Thu, Dec 4, 2014 at 7:46 AM, Alexander Graf <agraf@suse.de> wrote:
> >>> With binutils 2.25 the default alignment for 32bit arm sections changed to
> >>> have everything 64k aligned. Armv7 binaries built with this binutils version
> >>> run successfully on an arm64 system.
> >>>
> >>> Since effectively there is now the chance to run armv7 code on arm64 even
> >>> with 64k page size, it doesn't make sense to block people from enabling
> >>> CONFIG_COMPAT on those configurations.
> >>>
> >>> Signed-off-by: Alexander Graf <agraf@suse.de>
> >>> ---
> >>>  arch/arm64/Kconfig | 1 -
> >>>  1 file changed, 1 deletion(-)
> >>>
> >>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> >>> index 9532f8d..3cf4f238 100644
> >>> --- a/arch/arm64/Kconfig
> >>> +++ b/arch/arm64/Kconfig
> >>> @@ -409,7 +409,6 @@ source "fs/Kconfig.binfmt"
> >>>
> >>>  config COMPAT
> >>>         bool "Kernel support for 32-bit EL0"
> >>> -       depends on !ARM64_64K_PAGES
> >>>         select COMPAT_BINFMT_ELF
> >>>         select HAVE_UID16
> >>>         select OLD_SIGSUSPEND3
> >>
> >> This is hardly "compat". Sure, it's great to have a new binutils that
> >> has larger alignment, but practically not a single existing binary
> >> will work today if someone tries to do this.
> >
> > Yes, but IMHO that's an implementation detail. The same applies for
> > 32bit PPC binaries if you use 4k aligned segments. If your applications
> > are not aligned for your page size, you can't run them. The only
> > platform that managed nevertheless FWIW was IA64 ;).
> 
> Yes, but there the binutils change happened early enough that by the
> time the kernel change went in, all major distros had binaries that
> were compatible.

What is the exact symptom you see when running an unaligned user
space binary on 64k-pages? Do we at least print a helpful error
message somewhere or does it just crash?

Should we add support for 64k-pages in the arm32 kernel as well now?

	Arnd
