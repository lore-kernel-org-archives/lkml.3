Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250AbaALJaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 04:30:30 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34812 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbaALJaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 04:30:21 -0500
Date: Sun, 12 Jan 2014 10:30:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86, mpx: extend siginfo structure to include bound
 violation information
Message-ID: <20140112093013.GB3664@pd.tnic>
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com>
 <1389518403-7715-5-git-send-email-qiaowei.ren@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1389518403-7715-5-git-send-email-qiaowei.ren@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 12, 2014 at 05:20:03PM +0800, Qiaowei Ren wrote:
> This patch adds new fields about bound violation into siginfo
> structure. si_lower and si_upper are respectively lower bound
> and upper bound when bound violation is caused.
> 
> These fields will be set in #BR exception handler by decoding
> the user instruction and constructing the faulting pointer.
> A userspace application can get violation address, lower bound
> and upper bound for bound violation from this new siginfo structure.
> 
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> ---
>  arch/x86/include/asm/mpx.h         |   39 +++++
>  arch/x86/kernel/mpx.c              |  289 ++++++++++++++++++++++++++++++++++++

This thing looks like a partial duplication of functionality which we
already have - inat.*/insn.*, etc.

It would be cleaner to integrate the mpx pieces into the existing x86
insn analysis code and use it instead of growing your own, IMHO.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
