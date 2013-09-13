Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab3IMJrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 05:47:45 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51466 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754212Ab3IMJro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 05:47:44 -0400
Date: Fri, 13 Sep 2013 10:47:12 +0100
From: Will Deacon <will.deacon@arm.com>
To: Andrew Pinski <pinskia@gmail.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Pinski <apinski@cavium.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 5/5] ARM64: Add support for ILP32 ABI.
Message-ID: <20130913094712.GA21859@mudshark.cambridge.arm.com>
References: <1378762380-13152-1-git-send-email-apinski@cavium.com>
 <1378762380-13152-5-git-send-email-apinski@cavium.com>
 <20130911143102.GA8825@darko.cambridge.arm.com>
 <CA+=Sn1nd3Ym8so_=SP4NC1fjKWn4dNPYvz4OZMo0tLZptF8KVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+=Sn1nd3Ym8so_=SP4NC1fjKWn4dNPYvz4OZMo0tLZptF8KVw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 07:18:48AM +0100, Andrew Pinski wrote:
> On Wed, Sep 11, 2013 at 7:32 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > On Mon, Sep 09, 2013 at 10:32:59PM +0100, Andrew Pinski wrote:
> >> This patch adds full support of the ABI to the ARM64 target.
> >
> > This description is too short. Please describe what the ABI is, what are
> > the commonalities with AArch64 and AArch32, what other non-obvious
> > things had to be done (like __kernel_long_t being long long). Split this
> > patch into multiple patches like base syscall handling, signal handling,
> > pselect6/ppoll, vdso etc. It's too much to review at once.
> 
> Ok. I will do so after my vacation next week.
> 
> >
> > On top of these, I would really like to see
> > Documentation/arm64/ilp32.txt describing the ABI.
> 
> No other target does not, not even x86_64 for x32.

Well, I'm sure they wouldn't mind if you submitted documentation for them
too.

> > I would also like to know (you can state this in the cover letter) the
> > level of testing for all 3 types of ABI. I'm worried that at least this
> > patch breaks the current compat ABI (has LTP reported anything?).
> 
> We did test LTP on an earlier version of this patch for all three
> ABIs, I will make sure that the next version I send out is tested on
> all three ABIs also.  We also tested ILP32/LP64 on big-endian at the
> same time which we will continue to do (I should push for our team
> here to push out the big-endian patches).

We also have some BE patches internally, but obviously they just target LP64
and AArch32 compat. I'd hope to get these out shortly (the current issue is
extensive testing, since we don't have much of a BE userspace).

> >> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> >> index cc64df5..7fdc994 100644
> >> --- a/arch/arm64/Kconfig
> >> +++ b/arch/arm64/Kconfig
> >> @@ -248,7 +248,7 @@ source "fs/Kconfig.binfmt"
> >>
> >>  config COMPAT
> >>         def_bool y
> >> -       depends on ARM64_AARCH32
> >> +       depends on ARM64_AARCH32 || ARM64_ILP32
> >>         select COMPAT_BINFMT_ELF
> >>
> >>  config ARM64_AARCH32

(nitpick) We used to have an option like this, called
CONFIG_AARCH32_EMULATION, which I think is clearer than CONFIG_ARM64_AARCH32.

> >> diff --git a/arch/arm64/kernel/vdsoilp32/Makefile b/arch/arm64/kernel/vdsoilp32/Makefile
> >> new file mode 100644
> >> index 0000000..ec93f3f
> >> --- /dev/null
> >> +++ b/arch/arm64/kernel/vdsoilp32/Makefile
> >
> > Could we not keep vdso in the same directory?
> 
> I started out that way but "make clean ARCH=arm64" did not clean the
> vdso files all the time.

Can you elaborate please? I'd much rather we fix broken make rules instead
of botching around the issue by creating new directories.

Will
