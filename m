Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab3HVGhC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 02:37:02 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:64136 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab3HVGhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 02:37:00 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-ea-5215b18b2b9c
Date: Thu, 22 Aug 2013 15:37:33 +0900
From: Minchan Kim <minchan@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Xen-devel@lists.xen.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with
 existing use
Message-ID: <20130822063733.GG4665@bbox>
References: <5214C524.1050900@citrix.com>
 <dc8456d1-a89a-44c0-bebb-83cb0526230e@email.android.com>
 <20130821141926.GT18673@moon>
 <CA+55aFyk6s1t92HJ5rxKZQk6dTfszmhdXz+S=MqUmM-CbMo+DQ@mail.gmail.com>
 <20130821230557.GD18673@moon>
 <87wqnehapu.fsf@tassilo.jf.intel.com>
 <20130822054919.GF18673@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822054919.GF18673@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Cyrill,

On Thu, Aug 22, 2013 at 09:49:19AM +0400, Cyrill Gorcunov wrote:
> On Wed, Aug 21, 2013 at 04:42:53PM -0700, Andi Kleen wrote:
> > Cyrill Gorcunov <gorcunov@gmail.com> writes:
> > >
> > > Hi all, I worked on patch which would not touch PSE bit for dirty page
> > > tracking and the result is not that good:
> > >
> > >  - 2level pages now always page dirty if page is swapped in and out, because
> > >    there is no space left in PTE (other than PSE bit)
> > 
> > Maybe just don't support soft dirty for 2 level page tables?
> > 
> > 2 level page tables should be really on the way out anyways, as they
> > have severe limits and do not support NX. With 3 levels there is enough
> > space.
> 
> Look, good thing is that 7th bit also available on the 4level pages
> (ie x86-64) without additional code modification, that's why I picked
> it in first place. I prepared the patch locally which doesn't use
> pse bit for tracking but it only makes code more complex.

I'm not sure you read this thread.
http://comments.gmane.org/gmane.linux.kernel.mm/101756
In summary, I'd like to use it to track sub-ranges of some processes.

I already had a time to investigate and it enhanced our workload x2 on ARM
so I'd like to expand the concept for more general purpose.

For it, arch-specific stuff would be hurdle for port.
So, I support your non-arch-specific solutions.
Just FYI. Such future plan shouldn't force you.

Thanks.

-- 
Kind regards,
Minchan Kim
