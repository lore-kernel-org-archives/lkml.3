Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbaFXWvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 18:51:20 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:56440 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbaFXWvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 18:51:16 -0400
Date: Tue, 24 Jun 2014 15:51:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Guenter Roeck <linux@roeck-us.net>
cc: Chen Gang <gang.chen.5i5j@gmail.com>, Liqin Chen <liqin.linux@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] rch/score/include/uapi/asm/ptrace.h: Add prefix
 'SCORE_' for related macros
In-Reply-To: <53A98F6F.4080503@roeck-us.net>
Message-ID: <alpine.DEB.2.02.1406241549430.29176@chino.kir.corp.google.com>
References: <53A9783C.7050206@gmail.com> <53A98F6F.4080503@roeck-us.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Guenter Roeck wrote:

> > diff --git a/arch/score/include/uapi/asm/ptrace.h
> > b/arch/score/include/uapi/asm/ptrace.h
> > index f59771a..56e2de0 100644
> > --- a/arch/score/include/uapi/asm/ptrace.h
> > +++ b/arch/score/include/uapi/asm/ptrace.h
> > @@ -4,16 +4,29 @@
> >   #define PTRACE_GETREGS		12
> >   #define PTRACE_SETREGS		13
> > 
> > -#define PC		32
> > -#define CONDITION	33
> > -#define ECR		34
> > -#define EMA		35
> > -#define CEH		36
> > -#define CEL		37
> > -#define COUNTER		38
> > -#define LDCR		39
> > -#define STCR		40
> > -#define PSR		41
> > +#if !defined(__KERNEL__) || !defined(__linux__)
> > +#define PC			32
> > +#define CONDITION		33
> > +#define ECR			34
> > +#define EMA			35
> > +#define CEH			36
> > +#define CEL			37
> > +#define COUNTER			38
> > +#define LDCR			39
> > +#define STCR			40
> > +#define PSR			41
> > +#else
> > +#define SCORE_PC		32
> > +#define SCORE_CONDITION		33
> > +#define SCORE_ECR		34
> > +#define SCORE_EMA		35
> > +#define SCORE_CEH		36
> > +#define SCORE_CEL		37
> > +#define SCORE_COUNTER		38
> > +#define SCORE_LDCR		39
> > +#define SCORE_STCR		40
> > +#define SCORE_PSR		41
> > +#endif
> > 
> >   #define SINGLESTEP16_INSN	0x7006
> >   #define SINGLESTEP32_INSN	0x840C8000
> > 
> That looks weird ... not sure if that is a good solution either.
> 
> Are those defines actually used anywhere ? They don't seem to be used in the
> kernel.
> 
> Side note - an 'a' got missing in your headline.
> And I'd suggest to abbreviate it to something like
> 	score/uapi: ptrace.h:
> 

Besides checking whether they are used in the kernel or not, I presume we 
would need to be fairly confident there are actual userspace usecases for 
these that require the change.  It begs the question of why these 
constants are too generic to be in the kernel but are acceptable in the 
set of userspace applications in the world.
