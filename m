Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbaGDK5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:57:23 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:45208 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755421AbaGDK5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:57:22 -0400
Date: Fri, 4 Jul 2014 11:57:00 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 1/3] arm64: Add __NR_* definitions for compat syscalls
Message-ID: <20140704105700.GD16404@arm.com>
References: <1404458911-8214-1-git-send-email-takahiro.akashi@linaro.org>
 <1404458911-8214-2-git-send-email-takahiro.akashi@linaro.org>
 <5418828.mxvNk2rT0e@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5418828.mxvNk2rT0e@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 11:06:07AM +0100, Arnd Bergmann wrote:
> On Friday 04 July 2014 16:28:29 AKASHI Takahiro wrote:
> > From: Catalin Marinas <catalin.marinas@arm.com>
> > 
> > This patch adds __NR_* definitions to asm/unistd32.h, moves the
> > __NR_compat_* definitions to asm/unistd.h and removes all the explicit
> > unistd32.h includes apart from the one building the compat syscall
> > table. The aim is to have the compat __NR_* definitions available but
> > without colliding with the native syscall definitions.
> > 
> > And adds more syscall definitions for 3.16.
> 
> Can you explain in more detail why you want to add those macros? I've
> looked at all three patches in the series but can't find any code using
> them.
> 
> I would expect that we don't need to define those macros at all for
> compat mode, since they are meant primarily for user space (glibc)
> compilation, which gets them from arch/arm/include/asm/unistd.h.

That's coming from commit 4b58841149dc (audit: Add generic compat
syscall support). The compat_audit.c code reuses some of the existing
asm-generic/audit_*.h headers which depend on __NR_* definitions (rather
than __NR_COMPAT_*). Akashi's suggestion was to include a unistd32.h,
hence this patch.

-- 
Catalin
