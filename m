Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab3GTQ4G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 12:56:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35746 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442Ab3GTQ4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 12:56:05 -0400
Date: Sat, 20 Jul 2013 18:55:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] x86 fixes for 3.11-rc2
Message-ID: <20130720165555.GB13759@pd.tnic>
References: <20130720132548.GA13759@pd.tnic>
 <20130720144758.13924.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130720144758.13924.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 10:47:58AM -0400, George Spelvin wrote:
> Borislav Petkov <bp@alien8.de> wrote:
> > I don't think that matters because this is called only once on suspend.
> > Unless the cleaner assembly translates into a palpable speedup, which I
> > doubt.
> 
> I was thinking about code *size*, actually; I agree that speed is
> too small to measure.
> 
> Clean code (21 bytes):
>   4e:   b9 80 00 00 c0          mov    $0xc0000080,%ecx
>   53:   0f 32                   rdmsr  
>   55:   0f 30                   wrmsr  
>   57:   31 f6                   xor    %esi,%esi
>   59:   85 f6                   test   %esi,%esi
>   5b:   89 43 14                mov    %eax,0x14(%ebx)
>   5e:   89 53 18                mov    %edx,0x18(%ebx)
>   61:   75 04                   jne    67 <acpi_suspend_lowlevel+0x67>
> 
> Ugly code (50 bytes):

Right, that would matter maybe partially if the code was executed very
often. In that case, the probability of it fitting in one cacheline is
higher depending on alignment, and, you'd possibly save yourself loading
a second cacheline.

If it is 29 bytes bigger, than we have a higher probability for using a
second cacheline.

But again, I highly doubt even that would be noticeable. Especially on
modern uarches with very aggressive and smart branch prediction.

And since this is being called only once, you won't notice the
difference even with perf and specific instruction cache counters
enabled.

But what do I know - I'm always open to surprising workloads! :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
