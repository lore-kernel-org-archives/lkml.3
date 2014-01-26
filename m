Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaAZIjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 03:39:47 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:36840 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaAZIjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 03:39:46 -0500
Date: Sun, 26 Jan 2014 09:39:42 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Ren Qiaowei <qiaowei.ren@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH v3 3/4] x86, mpx: add prctl commands PR_MPX_INIT,
 PR_MPX_RELEASE
Message-ID: <20140126083942.GB29339@gmail.com>
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com>
 <1390727338-20487-4-git-send-email-qiaowei.ren@intel.com>
 <20140126082201.GB28831@gmail.com>
 <52E4C5F2.8070707@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E4C5F2.8070707@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ren Qiaowei <qiaowei.ren@intel.com> wrote:

> On 01/26/2014 04:22 PM, Ingo Molnar wrote:
> >
> >* Qiaowei Ren <qiaowei.ren@intel.com> wrote:
> >
> >>This patch adds the PR_MPX_INIT and PR_MPX_RELEASE prctl()
> >>commands on the x86 platform. These commands can be used to
> >>init and release MPX related resource.
> >>
> >>A MMU notifier will be registered during PR_MPX_INIT
> >>command execution. So the bound tables can be automatically
> >>deallocated when one memory area is unmapped.
> >>
> >>Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> >>---
> >>  arch/x86/Kconfig                 |    4 ++
> >>  arch/x86/include/asm/mpx.h       |    9 ++++
> >>  arch/x86/include/asm/processor.h |   16 +++++++
> >>  arch/x86/kernel/mpx.c            |   84 ++++++++++++++++++++++++++++++++++++++
> >>  include/uapi/linux/prctl.h       |    6 +++
> >>  kernel/sys.c                     |   12 +++++
> >>  6 files changed, 131 insertions(+), 0 deletions(-)
> >
> > Hm. What is the expected typical frequency of these syscalls for a 
> > larger application like a web browser? Only once per startup 
> > typically, or will they be called more frequently?
> 
> It will be only once per startup.

In that case it would be more efficient to make this part of the 
binary execution environment so that exec() sets it up automatically, 
not a separate prctl() syscall.

Thanks,

	Ingo
