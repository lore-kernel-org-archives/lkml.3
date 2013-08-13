Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657Ab3HMXvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 19:51:31 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:58682 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758297Ab3HMXv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 19:51:29 -0400
Date: Tue, 13 Aug 2013 16:51:33 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] idr: Document ida tree sections
Message-ID: <20130813235133.GA3807@kmo-pixel>
References: <1375896905-6074-4-git-send-email-kmo@daterainc.com>
 <20130807202201.GA28039@mtj.dyndns.org>
 <20130807205117.GC11612@kmo-pixel>
 <20130809145756.GL20515@mtj.dyndns.org>
 <20130813221308.GA11980@kmo-pixel>
 <20130813221928.GE28996@mtj.dyndns.org>
 <20130813222759.GA12069@kmo-pixel>
 <20130813224428.GG28996@mtj.dyndns.org>
 <20130813225927.GA2000@kmo-pixel>
 <20130813232211.GI28996@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813232211.GI28996@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 07:22:11PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Tue, Aug 13, 2013 at 03:59:27PM -0700, Kent Overstreet wrote:
> > > Well, it's not necessarily about requiring it but more about surviving
> > > it with some grace when things don't go as expected, which is an
> > > important characteristic for common library stuff.
> > 
> > The patch I posted should solve the high order allocations stuff, and
> > sparseness from cyclic allocations was already solved.
> 
> I don't know.  Yeah, using vmalloc would be able to work around the
> issue for most cases, I suppose.  It's iffy to consume vmalloc space
> from ida, which functionally is such a basic algorithmic construct.
> It probably won't worsen things noticeably but vmalloc area can be a
> very precious resource on 32bit configs.

This is only using it for the array of pointers to sections though, not
the bitmap itself - and only when that allocations is > 16k. For INT_MAX
allocated ids (absolute worst case) we'd be using 256k of vmalloc memory
on 64 bit, half that on 32 bit.

> 
> > Whatever caching optimizations you do with a radix tree version I could
> > apply to this bitmap tree version, and my bitmap tree code is simpler
> > and _considerably_ faster than the existing code.
> 
> But the difference won't really matter.  Cached performance would be
> the same and that's likely to cover most cases, right?  It's not like
> radix tree is orders of magnitude slower.

Should probably be almost as good, yeah... in theory, but the space
efficiency still isn't going to be as good, and it'll probably be more
code... and at this point I really just don't want to futz with it more.
At this point unless there's something really wrong with this code I
just want to move onto something else :P
