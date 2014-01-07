Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaAGFWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 00:22:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49746 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbaAGFWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 00:22:39 -0500
Message-ID: <52CB8F16.8000009@zytor.com>
Date: Mon, 06 Jan 2014 21:22:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>, x86@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: delete non-required instances of include <linux/init.h>
References: <1389054026-12947-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1389054026-12947-1-git-send-email-paul.gortmaker@windriver.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 04:20 PM, Paul Gortmaker wrote:
> None of these files are actually using any __init type directives
> and hence don't need to include <linux/init.h>.  Most are just a
> left over from __devinit and __cpuinit removal, or simply due to
> code getting copied from one driver to the next.
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
> 
> [build tested allyes/modconfig on x86/build from today's tip tree]
> 

Did you remember to test both 32 and 64 bits?  I'm assuming not, since
head_32.S no longer builds:

/home/hpa/kernel/tip.x86-cleanups/arch/x86/kernel/head_32.S: Assembler
messages:
/home/hpa/kernel/tip.x86-cleanups/arch/x86/kernel/head_32.S:86: Error:
no such instruction: `__head'
/home/hpa/kernel/tip.x86-cleanups/arch/x86/kernel/head_32.S:476: Error:
no such instruction: `__init'
/home/hpa/kernel/tip.x86-cleanups/arch/x86/kernel/head_32.S:635: Error:
no such instruction: `__initdata'
/home/hpa/kernel/tip.x86-cleanups/arch/x86/kernel/head_32.S:640: Error:
no such instruction: `__refdata'
/home/hpa/kernel/tip.x86-cleanups/arch/x86/kernel/head_32.S:698: Error:
no such instruction: `__initrodata'
make[4]: *** [arch/x86/kernel/head_32.o] Error 1

	-hpa

