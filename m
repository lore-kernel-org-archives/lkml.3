Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbaALMDL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 07:03:11 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:39867 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaALMDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 07:03:08 -0500
Date: Sun, 12 Jan 2014 13:03:05 +0100
From: Ingo Molnar <mingo@kernel.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        paul.gortmaker@windriver.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cleanups] x86: Delete non-required instances of include
 <linux/init.h>
Message-ID: <20140112120305.GA13076@gmail.com>
References: <1389054026-12947-1-git-send-email-paul.gortmaker@windriver.com>
 <tip-663b55b9b39fa9c848cca273ca4e12bf29b32c71@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-663b55b9b39fa9c848cca273ca4e12bf29b32c71@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Paul Gortmaker <tipbot@zytor.com> wrote:

> Commit-ID:  663b55b9b39fa9c848cca273ca4e12bf29b32c71
> Gitweb:     http://git.kernel.org/tip/663b55b9b39fa9c848cca273ca4e12bf29b32c71
> Author:     Paul Gortmaker <paul.gortmaker@windriver.com>
> AuthorDate: Mon, 6 Jan 2014 19:20:26 -0500
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Mon, 6 Jan 2014 21:25:18 -0800
> 
> x86: Delete non-required instances of include <linux/init.h>
> 
> None of these files are actually using any __init type directives
> and hence don't need to include <linux/init.h>.  Most are just a
> left over from __devinit and __cpuinit removal, or simply due to
> code getting copied from one driver to the next.
> 
> [ hpa: undid incorrect removal from arch/x86/kernel/head_32.S ]
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> Link: http://lkml.kernel.org/r/1389054026-12947-1-git-send-email-paul.gortmaker@windriver.com
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>

FYI, this patch breaks the UML build:

/home/mingo/tip/arch/x86/um/vdso/vdso.S: Assembler messages:
/home/mingo/tip/arch/x86/um/vdso/vdso.S:2: Error: no such instruction: `__initdata'
/home/mingo/tip/arch/x86/um/vdso/vdso.S:9: Error: no such instruction: `__finit'

Thanks,

	Ingo
