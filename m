Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422953AbaGRTRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:17:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43008 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbaGRTRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:17:17 -0400
Message-ID: <53C97287.5020509@zytor.com>
Date: Fri, 18 Jul 2014 12:16:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: build warning after merge of the tip tree
References: <20140718150005.73db8eb9@canb.auug.org.au>
In-Reply-To: <20140718150005.73db8eb9@canb.auug.org.au>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 10:00 PM, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the tip tree, today's linux-next build (x86_64
> allmodconfig) produced these warnings:
> 
> In file included from arch/x86/vdso/vdso2c.c:161:0: 
> arch/x86/vdso/vdso2c.c: In function 'main': 
> arch/x86/vdso/vdso2c.h:118:6: warning: assuming signed overflow
> does not occur when assuming that (X + c) < X is always false
> [-Wstrict-overflow] In file included from
> arch/x86/vdso/vdso2c.c:165:0: arch/x86/vdso/vdso2c.h:118:6:
> warning: assuming signed overflow does not occur when assuming that
> (X + c) < X is always false [-Wstrict-overflow]
> 
> Probably introduced by commit e6577a7ce99a ("x86, vdso: Move the
> vvar area before the vdso text").
> 

This seems toxic.

I always wonder if we shouldn't use -fwrapv for the kernel...

	-hpa

