Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbaBQHlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 02:41:21 -0500
Received: from www84.your-server.de ([213.133.104.84]:57242 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaBQHlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 02:41:20 -0500
Message-ID: <1392622944.1036.13.camel@wall-e.seibold.net>
Subject: Re: [tip:x86/vdso] x86, vdso: Instead of dummy functions, include <
 linux/spinlock_up.h>
From: Stefani Seibold <stefani@seibold.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, linux-tip-commits@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Date: Mon, 17 Feb 2014 08:42:24 +0100
In-Reply-To: <53018ABA.20005@zytor.com>
References: <1392587568-7325-10-git-send-email-stefani@seibold.net>
	 <tip-bd9ee7fd99f127ee1306289415141d45792c97f3@git.kernel.org>
	 <53018ABA.20005@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Am Sonntag, den 16.02.2014, 20:06 -0800 schrieb H. Peter Anvin:
> On 02/16/2014 07:51 PM, tip-bot for H. Peter Anvin wrote:
> > Commit-ID:  bd9ee7fd99f127ee1306289415141d45792c97f3
> > Gitweb:     http://git.kernel.org/tip/bd9ee7fd99f127ee1306289415141d45792c97f3
> > Author:     H. Peter Anvin <hpa@linux.intel.com>
> > AuthorDate: Sun, 16 Feb 2014 19:47:01 -0800
> > Committer:  H. Peter Anvin <hpa@linux.intel.com>
> > CommitDate: Sun, 16 Feb 2014 19:47:01 -0800
> > 
> > x86, vdso: Instead of dummy functions, include <linux/spinlock_up.h>
> > 
> > The list of dummy functions is insufficient.  However, instead of
> > having a full list of dummy functions we can include
> > <linux/spinlock_up.h> which contains the (trivial) implementations
> > that we use on uniprocessor.
> > 
> > There aren't supposed to be any spinlocks at all in the VDSO, of
> > course.
> > 
> 
> That didn't work either.  I thought I was clever, but it didn't work at
> all.  Multiple build failures across numerous configurations.  This is
> turning into a total headache.
> 
> The "right" way to fix this is presumably to refactor a bunch of header
> files so that the vdso code doesn't have to include a bunch of kernel
> internal headers, but that is a lot of work.
> 

I think for the first time it will be okay to kick out the
_ASM_X86_SPINLOCK_H hack and accept the C=1 warnings.

At next step it is necessary to make the whole BUILD_VDSO32 path in
vclock_gettime.c independent from the kernel headers, only uapi/ should
be included.

The use of cycle_t must be replaced with u64.

We need a own copy of __native_read_tsc(), __iter_div_u64_rem, smp_rmb()
and cpu_relax().

For the non BUILD_VDSO32 path we must only move the #includes inside
this #ifndef BUILD_VDSO32

- Stefani


