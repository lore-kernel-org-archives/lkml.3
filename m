Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbaA0Qlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 11:41:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47035 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbaA0Qll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 11:41:41 -0500
Message-ID: <52E68C25.1070804@zytor.com>
Date: Mon, 27 Jan 2014 08:41:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Jiri Kosina <jkosina@suse.cz>, Michael Matz <matz@suse.de>,
        Michal Hocko <mhocko@suse.cz>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] x86: Disable traditional FPU instructions too
References: <20140127163758.GC6839@pd.tnic>
In-Reply-To: <20140127163758.GC6839@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 08:37 AM, Borislav Petkov wrote:
> Hey guys,
> 
> should we do the below? It looks like we don't disable the generation of
> *all* FPU instructions on x86_64 (commit message below has the rationale
> why).
> 
> We do -msoft-float on 32-bit only and Micha says that -msoft-float and
> -mno-80387 are the same and the gcc manpage says:
> 
>            On machines where a function returns floating-point results in the 80387
>            register stack, some floating-point opcodes may be emitted even if
>            -msoft-float is used.
> 
> and right after, it has also
> 
>        -mno-fp-ret-in-387
>            Do not use the FPU registers for return values of functions.
> 
>            The usual calling convention has functions return values of types "float"
>            and "double" in an FPU register, even if there is no FPU.  The idea is that
>            the operating system should emulate an FPU.
> 
>            The option -mno-fp-ret-in-387 causes such values to be returned in ordinary
>            CPU registers instead.
> 
> Btw, there's this -mno-fp-regs switch too which forces passing of FP
> results of functions in integer registers...
> 

I don't think it'd hurt... although I think the above pretty much
requires that the code contain actual floating-point types to ever be
generated.  The issue with MMX/SSE is that an autovectorizing compiler
could decide to use them for *integer* code.

-mno-fp-ret-in-387 in particular will only ever apply if a function
return type is a floating-point type.

	-hpa


