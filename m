Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab3H0WFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 18:05:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:53275 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab3H0WFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 18:05:52 -0400
Message-ID: <1377641065.3819.137.camel@pasglop>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with
 existing use
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Xen-devel@lists.xen.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Jan Beulich <jbeulich@suse.com>
Date: Wed, 28 Aug 2013 08:04:25 +1000
In-Reply-To: <CA+55aFyk6s1t92HJ5rxKZQk6dTfszmhdXz+S=MqUmM-CbMo+DQ@mail.gmail.com>
References: <5214C524.1050900@citrix.com>
	 <dc8456d1-a89a-44c0-bebb-83cb0526230e@email.android.com>
	 <20130821141926.GT18673@moon>
	 <CA+55aFyk6s1t92HJ5rxKZQk6dTfszmhdXz+S=MqUmM-CbMo+DQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-21 at 09:30 -0700, Linus Torvalds wrote:
> I will be reverting the whole soft-dirty mess. I thought the
> bit-mapping games it played were already too complicated (the patch to
> pgtable-2level.h in commit 41bb3476b361 just makes me want to barf and
> came in very late, so I'm not positive about the whole soft-dirty mess
> in the first place). I really am not at all inclined to want to play
> games in this area any more. It's too damn late in the release window.

Anything that makes me try to scavenge a new PTE bits makes me
scream :-) Dunno if I'll manage to support this on power.

Also, it sort-of duplicates what KVM does for dirty tracking (for
migration, framebuffer updates, etc...). I wonder if KVM could consider
switching to this scheme, but then we end up with a user "break KVM"
file in /proc since the user can clear the refs.

I'd have been happier if the whole thing had essentially used a parallel
set of dirty tracking bitmaps (hooked up with the VMAs maybe). Add the
overhead there for as many "clients" as you want who will use the
facility and leave the PTE mostly alone basically. (I suppose we still
need to play PTE tricks to differenciate soft dirty RO vs. COW RO on
anonymous memory ?)

Cheers,
Ben.


