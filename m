Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab3LSPVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:21:20 -0500
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:34849 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754009Ab3LSPVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:21:19 -0500
Date: Thu, 19 Dec 2013 09:21:15 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Dave Hansen <dave@sr71.net>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Pravin B Shelar <pshelar@nicira.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [RFC][PATCH 0/7] re-shrink 'struct page' when SLUB is on.
In-Reply-To: <52B2424F.7050406@sr71.net>
Message-ID: <alpine.DEB.2.10.1312190920340.4238@nuc>
References: <20131213235903.8236C539@viggo.jf.intel.com> <20131216160128.aa1f1eb8039f5eee578cf560@linux-foundation.org> <52AF9EB9.7080606@sr71.net> <0000014301223b3e-a73f3d59-8234-48f1-9888-9af32709a879-000000@email.amazonses.com> <52B23CAF.809@sr71.net>
 <20131218164109.5e169e258378fac44ec5212d@linux-foundation.org> <52B2424F.7050406@sr71.net>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013, Dave Hansen wrote:

> On 12/18/2013 04:41 PM, Andrew Morton wrote:
> >> > Unless somebody can find some holes in this, I think we have no choice
> >> > but to unset the HAVE_ALIGNED_STRUCT_PAGE config option and revert using
> >> > the cmpxchg, at least for now.
> >
> > So your scary patch series which shrinks struct page while retaining
> > the cmpxchg_double() might reclaim most of this loss?
>
> That's what I'll test next, but I hope so.
>
> The config tweak is important because it shows a low-risk way to get a
> small 'struct page', plus get back some performance that we lost and
> evidently never noticed.  A distro that was nearing a release might want
> to go with this, for instance.

Ok then lets just drop the cmpxchg updates to the page struct. The
spinlock code is already in there so just removing the __CMPXCHG flag
related processing should do the trick.

