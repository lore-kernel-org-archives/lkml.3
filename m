Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaAPQoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 11:44:34 -0500
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:56783 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752673AbaAPQo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:44:28 -0500
Date: Thu, 16 Jan 2014 10:44:24 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Dave Hansen <dave@sr71.net>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] re-shrink 'struct page' when SLUB is on.
In-Reply-To: <52D5B48D.30006@sr71.net>
Message-ID: <alpine.DEB.2.10.1401161041160.29778@nuc>
References: <20140103180147.6566F7C1@viggo.jf.intel.com> <20140103141816.20ef2a24c8adffae040e53dc@linux-foundation.org> <20140106043237.GE696@lge.com> <52D05D90.3060809@sr71.net> <20140110153913.844e84755256afd271371493@linux-foundation.org> <52D0854F.5060102@sr71.net>
 <CAOJsxLE-oMpV2G-gxrhyv0Au1tPd87Ow57VD5CWFo41wF8F4Yw@mail.gmail.com> <alpine.DEB.2.10.1401111854580.6036@nuc> <20140113014408.GA25900@lge.com> <52D41F52.5020805@sr71.net> <alpine.DEB.2.10.1401141404190.19618@nuc> <52D5B48D.30006@sr71.net>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014, Dave Hansen wrote:

> On 01/14/2014 12:07 PM, Christoph Lameter wrote:
> > One easy way to shrink struct page is to simply remove the feature. The
> > patchset looked a bit complicated and does many other things.
>
> Sure.  There's a clear path if you only care about 'struct page' size,
> or if you only care about making the slub fast path as fast as possible.
>  We've got three variables, though:
>
> 1. slub fast path speed

The fast path does use this_cpu_cmpxchg_double which is something
different from a cmpxchg_double and its not used on struct page.

> Arranged in three basic choices:
>
> 1. Big 'struct page', fast, medium complexity code
> 2. Small 'struct page', slow, lowest complexity

The numbers that I see seem to indicate that a big struct page means slow.

> The question is what we should do by _default_, and what we should be
> recommending for our customers via the distros.  Are you saying that you
> think we should completely rule out even having option 1 in mainline?

If option 1 is slower than option 2 then we do not need it.

