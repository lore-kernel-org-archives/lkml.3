Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab3KVBhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 20:37:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876Ab3KVBhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 20:37:13 -0500
Date: Thu, 21 Nov 2013 20:37:07 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] mm/bootmem.c: remove unused 'limit' variable
Message-ID: <20131121203707.4f59f86e@redhat.com>
In-Reply-To: <528E83B6.5040107@intel.com>
References: <20131121164335.066fd6aa@redhat.com>
	<528E83B6.5040107@intel.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013 14:05:42 -0800
Dave Hansen <dave.hansen@intel.com> wrote:

> On 11/21/2013 01:43 PM, Luiz Capitulino wrote:
> > @@ -655,9 +655,7 @@ restart:
> >  void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,
> >  					unsigned long goal)
> >  {
> > -	unsigned long limit = 0;
> > -
> > -	return ___alloc_bootmem_nopanic(size, align, goal, limit);
> > +	return ___alloc_bootmem_nopanic(size, align, goal, 0);
> >  }
> 
> FWIW, I like those.  The way you leave it:
> 
> 	return ___alloc_bootmem_nopanic(size, align, goal, 0);
> 
> the 0 is a magic number that you have to go look up the declaration of
> ___alloc_bootmem_nopanic() to decipher, or you have to add a comment to
> it in some way.
> 
> I find it much more readable to have an 'unused' variable like that.

Got it. I was reading that code and thought 'limit' was a leftover,
so I posted the patch...

Btw, I also have a patch consitfying some zone access functions
parameters that are read-only. Wondering if anyone will object
to such a change? Or maybe I should just stop doing trivial patches :)
