Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422704Ab3BOPts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:49:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422678Ab3BOPtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:49:46 -0500
Date: Fri, 15 Feb 2013 13:49:29 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH EDAC 07/13] edac: add support for raw error reports
Message-ID: <20130215134929.3909cfa2@redhat.com>
In-Reply-To: <20130215154123.GH14387@pd.tnic>
References: <cover.1360931635.git.mchehab@redhat.com>
	<e08f797b129a50b4e1b39e8c31bff82904aea65d.1360931635.git.mchehab@redhat.com>
	<20130215141330.GF14387@pd.tnic>
	<20130215132530.4f3b7dab@redhat.com>
	<20130215154123.GH14387@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 15 Feb 2013 16:41:23 +0100
Borislav Petkov <bp@alien8.de> escreveu:

> On Fri, Feb 15, 2013 at 01:25:30PM -0200, Mauro Carvalho Chehab wrote:
> > Well, for sure using an structure will help to avoid missing a
> > parameter or exchanging its order. The stack usage won't reduce,
> > though, because the structure will keep using the stack.
> 
> If you allocate it on the stack of the caller, yes. If you kmalloc it,
> no.

Sure, but calling kmalloc while handling a memory error doesn't seem
a very good idea, IMHO. So, better to either use an already allocated
space (or the stack).
> 
> In any case, passing a pointer to struct edac_raw_error_desc only will
> allow on x86_64 (and i386 AFAICT) to use only registers to pass callee
> function arguments. Which is always a win. You probably need to stare at
> compiler output to see what gcc actually does with -O2 optimizations.

Yes, I know, but, on the other hand, there's the additional cost of
copying almost all data into the structure.

> > As I can't foresee the usage of this function call outside the core
> > and by the GHES driver, I'm not sure what would be the better.
> 
> Having an error descriptor is always better, even if it were only for
> clarity's and simplicity's sake.

Yes, the code is now clearer.

Ok, I'll keep this patch on my git. I'll likely fold it with the previous 
one on the final patchset.

-- 

Cheers,
Mauro
