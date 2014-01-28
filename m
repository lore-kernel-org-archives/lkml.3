Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbaA1TsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:48:04 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:51253 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755466AbaA1TsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:48:02 -0500
Date: Tue, 28 Jan 2014 19:47:40 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 1/3] memblock, nobootmem: Add memblock_virt_alloc_low()
Message-ID: <20140128194739.GP15937@n2100.arm.linux.org.uk>
References: <1390590670-25901-1-git-send-email-yinghai@kernel.org> <1390590670-25901-4-git-send-email-yinghai@kernel.org> <CAOesGMh7+SzLTfyPomnB_Q_wft+RC+F3tx-Ow1TdSmHiSwrKcw@mail.gmail.com> <CAGa+x87jJep_TSG70wAr5M-Ce7soPyr4SBdPqyo2ENZ2DYcqkA@mail.gmail.com> <CAE9FiQU_vZo40cje_XJXSxuKW-JL6H-8rAazwOw1O-ewcV+C5g@mail.gmail.com> <20140128171823.GN15937@n2100.arm.linux.org.uk> <CAE9FiQUa3uKZNc=5fiuvcR4bjEeQ3=RuhFVxUyKyMsJwe2YurA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUa3uKZNc=5fiuvcR4bjEeQ3=RuhFVxUyKyMsJwe2YurA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 11:43:02AM -0800, Yinghai Lu wrote:
> On Tue, Jan 28, 2014 at 9:18 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Tue, Jan 28, 2014 at 09:12:27AM -0800, Yinghai Lu wrote:
> >> On Tue, Jan 28, 2014 at 7:30 AM, Kevin Hilman <khilman@linaro.org> wrote:
> >> > Like Olof, I noticed multiple boot failures on various ARM boards.
> >> > I've confirmed that reverting the arch/arm part of this patch makes
> >> > them all happily booting again.
> >>
> >> please try attached patch.
> >
> > Maybe I'm missing something, but there is no ARCH_LOW_ADDRESS_LIMIT
> > defined in the ARM header files, so I don't see how adding that
> > additional include changes anything.
> 
> there is one for arm64 and s390.
> 
> arch/arm64/include/asm/processor.h:#define ARCH_LOW_ADDRESS_LIMIT       PHYS_MAS
> arch/s390/include/asm/processor.h:#define ARCH_LOW_ADDRESS_LIMIT        0x7fffff

Forgive me being difficult, but how exactly does your patch come anywhere
close to sortting out the reported regression by Kevin and Olof, and now
myself which is on ARM?

Your patch adds asm/processor.h to a header file, to allow architectures
to override ARCH_LOW_ADDRESS_LIMIT, but there is /no/ override for ARM,
so your patch has _zero_ effect there - we still end up with this being
0xffffffff, and we still end up with the thing being unable to boot.

Maybe you could describe what this ARCH_LOW_ADDRESS_LIMIT is, and what
it should be set to - I'm less than clear on how to set this given that
we have a multitude of different physical memory layouts - where memory
can start at almost any physical address.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
