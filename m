Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760529AbbA2J5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:57:19 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45770 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758758AbbA2J5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:57:13 -0500
Date: Thu, 29 Jan 2015 09:57:03 +0000
From: Will Deacon <will.deacon@arm.com>
To: Timur Tabi <timur@codeaurora.org>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 1/3] arm64: Add __NR_* definitions for compat syscalls
Message-ID: <20150129095702.GA1626@arm.com>
References: <1404458911-8214-1-git-send-email-takahiro.akashi@linaro.org>
 <1404458911-8214-2-git-send-email-takahiro.akashi@linaro.org>
 <CAOZdJXUhpmi0SM5izDYQnx8SHjWjqOFVduV0+boPw6+YCKP5+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOZdJXUhpmi0SM5izDYQnx8SHjWjqOFVduV0+boPw6+YCKP5+g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 09:31:49PM +0000, Timur Tabi wrote:
> On Fri, Jul 4, 2014 at 2:28 AM, AKASHI Takahiro
> <takahiro.akashi@linaro.org> wrote:
> > +#define __ARM_NR_COMPAT_BASE           0x0f0000
> > +#define __ARM_NR_compat_cacheflush     (__ARM_NR_COMPAT_BASE+2)
> > +#define __ARM_NR_compat_set_tls                (__ARM_NR_COMPAT_BASE+5)
> 
> I know this patch is six months old, but I was wondering if anyone
> knows of any plans to make these syscalls available to 64-bit apps?
> We have a 32-bit app that uses __ARM_NR_compat_cacheflush, and we'd
> like to port that app to 64-bit.  I'm just not sure how to start doing
> that, since there don't appear to be any 64-bit ARM-specific syscalls.

You can issue cache maintenance instructions directly from EL0 in AArch64.
Take a look at DC CVAU, DC CVAC, DC CIVAC, IC IVAU and DC ZVA.

As for the TLS register, that's also writable from EL0 but I wouldn't
recommend messing with it outside of libc.

Will
