Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab3H0QYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 12:24:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab3H0QYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 12:24:47 -0400
Date: Tue, 27 Aug 2013 12:24:27 -0400
From: Dave Jones <davej@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: unused swap offset / bad page map.
Message-ID: <20130827162427.GA26717@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Hugh Dickins <hughd@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Hillf Danton <dhillf@gmail.com>, Linux-MM <linux-mm@kvack.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pavel Emelyanov <xemul@parallels.com>
References: <20130823032127.GA5098@redhat.com>
 <CAJd=RBArkh3sKVoOJUZBLngXtJubjx4-a3G6s7Tn0N=Pr1gU4g@mail.gmail.com>
 <20130823035344.GB5098@redhat.com>
 <CAJd=RBBtY-nJfo9nzG5gtgcvB2bz+sxpK5kX33o1sLeLhvEU1Q@mail.gmail.com>
 <20130826190757.GB27768@redhat.com>
 <CA+55aFw_bhMOP73owFHRFHZDAYEdWgF9j-502Aq9tZe3tEfmwg@mail.gmail.com>
 <CA+55aFwQbJbR3xij1+iGbvj3EQggF9NLGAfDbmA54FkKz9xfew@mail.gmail.com>
 <alpine.LNX.2.00.1308261448490.4982@eggly.anvils>
 <20130826222833.GA24320@redhat.com>
 <20130827083718.GC7416@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130827083718.GC7416@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 12:37:18PM +0400, Cyrill Gorcunov wrote:
 > On Mon, Aug 26, 2013 at 06:28:33PM -0400, Dave Jones wrote:
 > >  > 
 > >  > I've not tried matching up bits with Dave's reports, and just going
 > >  > into a meeting now, but this patch looks worth a try: probably Cyrill
 > >  > can improve it meanwhile to what he actually wants there (I'm
 > >  > surprised anything special is needed for just moving a pte).
 > >  > 
 > >  > Hugh
 > >  > 
 > >  > --- 3.11-rc7/mm/mremap.c	2013-07-14 17:10:16.640003652 -0700
 > >  > +++ linux/mm/mremap.c	2013-08-26 14:46:14.460027627 -0700
 > >  > @@ -126,7 +126,7 @@ static void move_ptes(struct vm_area_str
 > >  >  			continue;
 > >  >  		pte = ptep_get_and_clear(mm, old_addr, old_pte);
 > >  >  		pte = move_pte(pte, new_vma->vm_page_prot, old_addr, new_addr);
 > >  > -		set_pte_at(mm, new_addr, new_pte, pte_mksoft_dirty(pte));
 > >  > +		set_pte_at(mm, new_addr, new_pte, pte);
 > >  >  	}
 > > 
 > > I'll give this a shot once I'm done with the bisect.
 > 
 > I managed to trigger the issue as well. The patch below fixes it.
 > Dave, could you please give it a shot once time permit?

Seems to do the trick.

Tested-by: Dave Jones <davej@fedoraproject.org>

	Dave

