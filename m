Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbaDHSxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:53:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40181 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756235AbaDHSvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:51:54 -0400
Date: Tue, 8 Apr 2014 19:51:46 +0100
From: Mel Gorman <mgorman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Linux-X86 <x86@kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Noonan <steven@uplinklabs.net>, Rik van Riel <riel@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] Use an alternative to _PAGE_PROTNONE for
 _PAGE_NUMA v2
Message-ID: <20140408185146.GP7292@suse.de>
References: <1396962570-18762-1-git-send-email-mgorman@suse.de>
 <53440A5D.6050301@zytor.com>
 <CA+55aFwc6Jdf+As9RJ3wJWuOGEGmiaYWNa-jp2aCb9=ZiiqV+A@mail.gmail.com>
 <20140408164652.GL7292@suse.de>
 <CA+55aFwrwYmWFXWpPeg-keKukW0=dwvmUBuN4NKA=JcseiUX3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CA+55aFwrwYmWFXWpPeg-keKukW0=dwvmUBuN4NKA=JcseiUX3g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 10:01:39AM -0700, Linus Torvalds wrote:
> On Tue, Apr 8, 2014 at 9:46 AM, Mel Gorman <mgorman@suse.de> wrote:
> >
> > If you are ok with leaving _PAGE_NUMA as _PAGE_PROTNONE
> 
> NO I AM NOT!
> 
> Dammit, this feature is f*cking brain-damaged.
> 
> My complaint has been (and continues to be):
> 
>  - either it is 100% the same as PROTNONE, in which case thjat
> _PAGE_NUMA bit had better go away, and you just use the protnone
> helpers!
> 

In which case we'd still use VMAs to distinguish between PROTNONE faults
and NUMA hinting faults. We may still need some special casing. It's plan
b but not my preferred solution at this time.

>  - if it's not the same as PROTNONE, then it damn well needs a different bit.
> 

With this series applied _PAGE_NUMA != _PAGE_PROTNONE.

> You can't have it both ways. You guys tried. The Xen case shows that
> trying to distinguish the two DOES NOT WORK. But even apart from the
> Xen case, it was just a confusing hell.
> 

Which is why I responded with a series that used a different bit instead
of more discussions that would reach the same conclusion. 

> Like Yoda said: "Either they are the same or they are not. There is no 'try'".
> 
> So pick one solution. Don't try to pick the mixed-up half-way case
> that is a disaster and makes no sense.
> 

I picked a solution. The posted series uses a different bit.

-- 
Mel Gorman
SUSE Labs
