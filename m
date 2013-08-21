Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab3HUQnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:43:09 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:33586 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3HUQnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:43:07 -0400
Date: Wed, 21 Aug 2013 20:42:59 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Vrabel <david.vrabel@citrix.com>,
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
Message-ID: <20130821164259.GX18673@moon>
References: <5214C524.1050900@citrix.com>
 <dc8456d1-a89a-44c0-bebb-83cb0526230e@email.android.com>
 <20130821141926.GT18673@moon>
 <CA+55aFyk6s1t92HJ5rxKZQk6dTfszmhdXz+S=MqUmM-CbMo+DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyk6s1t92HJ5rxKZQk6dTfszmhdXz+S=MqUmM-CbMo+DQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 09:30:03AM -0700, Linus Torvalds wrote:
> On Wed, Aug 21, 2013 at 7:19 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > On Wed, Aug 21, 2013 at 04:11:25PM +0200, H. Peter Anvin wrote:
> >>
> >> Eep.  This should be reverted, indeed.  This isn't a manifest bug on !Xen but we
> >> have gotten requests for WT support which would mean adding in the PAT but again.
> >
> > Please no, letme fix it. That's what I'm having in mind: don't use pse bit in swap
> > entry but always mark page read from swap as dirty one (it's better than having
> > no tracker at all and  will be the case on old machines with 32bit ptes only).
> 
> Quite frankly, unless I see a patch later today that is

I'll do my best to fix it, but I've not yet been shown where the problem
happens. Neither I'm convinced if it is here at all. I'm asking David for details.

> 
>  (a) obvious
>  (b) explains what is going on
>  (c) tested
> 
> I will be reverting the whole soft-dirty mess. I thought the
> bit-mapping games it played were already too complicated (the patch to
> pgtable-2level.h in commit 41bb3476b361 just makes me want to barf and
> came in very late, so I'm not positive about the whole soft-dirty mess

This was not my invention on such encoding, I simply had no choise but
follow existing scheme. Still there are cleanup patches in -mm tree which
make code a way more readable (even former one, without soft-dirty bit).

> in the first place). I really am not at all inclined to want to play
> games in this area any more. It's too damn late in the release window.
