Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaFDWRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:17:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36349 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbaFDWRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:17:50 -0400
Message-ID: <538F9AFA.5050806@zytor.com>
Date: Wed, 04 Jun 2014 15:17:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@kernel.org,
        ricardo.neri-calderon@linux.intel.com, tglx@linutronix.de, bp@suse.de,
        matt.fleming@intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/efi] x86/efi: Check for unsafe dealing with FPU state
 in irq ctxt
References: <tip-baa916f39b50ad91661534652110df40396acda0@git.kernel.org>
In-Reply-To: <tip-baa916f39b50ad91661534652110df40396acda0@git.kernel.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 03:15 PM, tip-bot for Borislav Petkov wrote:
> Commit-ID:  baa916f39b50ad91661534652110df40396acda0
> Gitweb:     http://git.kernel.org/tip/baa916f39b50ad91661534652110df40396acda0
> Author:     Borislav Petkov <bp@suse.de>
> AuthorDate: Fri, 25 Apr 2014 13:40:10 +0200
> Committer:  Matt Fleming <matt.fleming@intel.com>
> CommitDate: Sat, 3 May 2014 06:39:25 +0100
> 
> x86/efi: Check for unsafe dealing with FPU state in irq ctxt
> 
> efi_call can happen in an irq context (pstore) and there we really need
> to make sure we're not scribbling over FPU state while we've interrupted
> a thread or kernel mode with a live FPU state. Therefore, use the
> kernel_fpu_begin/end() variants which do that check.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/x86/include/asm/efi.h | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 

I seem to have lost track of this... does this actually solve anything,
or does it just mean we'll explode hard?

	-hpa


