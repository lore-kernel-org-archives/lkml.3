Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab3HVFtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:49:23 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:63225 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab3HVFtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:49:21 -0400
Date: Thu, 22 Aug 2013 09:49:19 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20130822054919.GF18673@moon>
References: <5214C524.1050900@citrix.com>
 <dc8456d1-a89a-44c0-bebb-83cb0526230e@email.android.com>
 <20130821141926.GT18673@moon>
 <CA+55aFyk6s1t92HJ5rxKZQk6dTfszmhdXz+S=MqUmM-CbMo+DQ@mail.gmail.com>
 <20130821230557.GD18673@moon>
 <87wqnehapu.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqnehapu.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 04:42:53PM -0700, Andi Kleen wrote:
> Cyrill Gorcunov <gorcunov@gmail.com> writes:
> >
> > Hi all, I worked on patch which would not touch PSE bit for dirty page
> > tracking and the result is not that good:
> >
> >  - 2level pages now always page dirty if page is swapped in and out, because
> >    there is no space left in PTE (other than PSE bit)
> 
> Maybe just don't support soft dirty for 2 level page tables?
> 
> 2 level page tables should be really on the way out anyways, as they
> have severe limits and do not support NX. With 3 levels there is enough
> space.

Look, good thing is that 7th bit also available on the 4level pages
(ie x86-64) without additional code modification, that's why I picked
it in first place. I prepared the patch locally which doesn't use
pse bit for tracking but it only makes code more complex.
