Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119AbaLELfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 06:35:38 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45148 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaLELfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 06:35:36 -0500
Date: Fri, 5 Dec 2014 11:35:42 +0000
From: Will Deacon <will.deacon@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Olof Johansson <olof@lixom.net>, "agraf@suse.de" <agraf@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: Enable CONFIG_COMPAT also for 64k page size
Message-ID: <20141205113541.GB1630@arm.com>
References: <1417707993-82290-1-git-send-email-agraf@suse.de>
 <CAOesGMhv+0_SZb2eSiwCGaD77hd=a6EhMp6tVvcrZoBnrHKQjA@mail.gmail.com>
 <20141205111455.GC28339@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141205111455.GC28339@e104818-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 11:14:55AM +0000, Catalin Marinas wrote:
> On Thu, Dec 04, 2014 at 09:15:12PM +0000, Olof Johansson wrote:
> > On Thu, Dec 4, 2014 at 7:46 AM, Alexander Graf <agraf@suse.de> wrote:
> > > With binutils 2.25 the default alignment for 32bit arm sections changed to
> > > have everything 64k aligned. Armv7 binaries built with this binutils version
> > > run successfully on an arm64 system.
> > >
> > > Since effectively there is now the chance to run armv7 code on arm64 even
> > > with 64k page size, it doesn't make sense to block people from enabling
> > > CONFIG_COMPAT on those configurations.
> > >
> > > Signed-off-by: Alexander Graf <agraf@suse.de>
> > > ---
> > >  arch/arm64/Kconfig | 1 -
> > >  1 file changed, 1 deletion(-)
> > >
> > > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > > index 9532f8d..3cf4f238 100644
> > > --- a/arch/arm64/Kconfig
> > > +++ b/arch/arm64/Kconfig
> > > @@ -409,7 +409,6 @@ source "fs/Kconfig.binfmt"
> > >
> > >  config COMPAT
> > >         bool "Kernel support for 32-bit EL0"
> > > -       depends on !ARM64_64K_PAGES
> > >         select COMPAT_BINFMT_ELF
> > >         select HAVE_UID16
> > >         select OLD_SIGSUSPEND3
> > 
> > This is hardly "compat". Sure, it's great to have a new binutils that
> > has larger alignment, but practically not a single existing binary
> > will work today if someone tries to do this.
> > 
> > So, it seems very premature to take this off. At the very least
> > document it like Will requested, and make it depend on !ARM_64K_PAGES
> > || EXPERT.
> 
> That would work for me. We need to be clear that most existing 32-bit
> binaries will fail.

I'd still like to run some regression tests to make sure we don't back
ourselves into corners with things like SHMLBA, which would now be less
than a page size.

Will
