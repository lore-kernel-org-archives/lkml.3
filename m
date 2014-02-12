Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaBLXOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 18:14:41 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45290 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbaBLXOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 18:14:40 -0500
Date: Wed, 12 Feb 2014 15:14:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Gortmaker <paul.gortmaker@windriver.com>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: fix two sparse warnings in early boot string
 handling
In-Reply-To: <52FBF5DD.3030407@windriver.com>
Message-ID: <alpine.DEB.2.02.1402121508430.20539@chino.kir.corp.google.com>
References: <1392143619-11453-1-git-send-email-paul.gortmaker@windriver.com> <alpine.DEB.2.02.1402111425430.32020@chino.kir.corp.google.com> <20140212020010.GB21033@windriver.com> <alpine.DEB.2.02.1402111821510.13509@chino.kir.corp.google.com>
 <52FB8BEB.5020506@windriver.com> <52FB9807.40706@windriver.com> <alpine.DEB.2.02.1402121357450.27082@chino.kir.corp.google.com> <52FBF5DD.3030407@windriver.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Feb 2014, Paul Gortmaker wrote:

> > This means there is a strstr() prototype that is visible to 
> > drivers/firmware/efi/efi-stub-helper.c but fails at linkage because you've 
> > removed the definition. 
> 
> Yes, because you suggested removal when you said, in what is
> now deleted context text:
> 
>  "I don't see why you can't remove strstr() in 
>  arch/x86/boot/string.c entirely.  What breaks?"
> 
> The above answers your question. The eboot.c breaks.  So
> we can't remove strstr.
> 

Thanks.

> > So, again, why would you add a duplicate 
> > prototype with your patch?
> 
> I'm sure there is an implicit path to <linux/string.h>
> which allows eboot.c to see a prototype and hence compile.
> 

Nope, linux/string.h only declares the prototype when 
#ifndef __HAVE_ARCH_STRSTR and the 32-bit x86 declaration in 
include/asm/string_32.h properly does #define __HAVE_ARCH_STRSTR.

There's also no #include ordering issue here since linux/string.h does 
#include <asm/string.h> first.

If you had a real problem here, the build would break.  So I'll renew my 
original objection: I don't think it's acceptable to add unneeded 
prototypes because sparse doesn't understand this.
