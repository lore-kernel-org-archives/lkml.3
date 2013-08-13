Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab3HMW7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 18:59:25 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:48887 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab3HMW7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 18:59:24 -0400
Date: Tue, 13 Aug 2013 15:59:27 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] idr: Document ida tree sections
Message-ID: <20130813225927.GA2000@kmo-pixel>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com>
 <1375896905-6074-4-git-send-email-kmo@daterainc.com>
 <20130807202201.GA28039@mtj.dyndns.org>
 <20130807205117.GC11612@kmo-pixel>
 <20130809145756.GL20515@mtj.dyndns.org>
 <20130813221308.GA11980@kmo-pixel>
 <20130813221928.GE28996@mtj.dyndns.org>
 <20130813222759.GA12069@kmo-pixel>
 <20130813224428.GG28996@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813224428.GG28996@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 06:44:28PM -0400, Tejun Heo wrote:
> Hello, Kent.
> 
> On Tue, Aug 13, 2013 at 03:27:59PM -0700, Kent Overstreet wrote:
> > It's only naturally a radix tree problem _if_ you require sparseness.
> 
> Well, it's not necessarily about requiring it but more about surviving
> it with some grace when things don't go as expected, which is an
> important characteristic for common library stuff.

The patch I posted should solve the high order allocations stuff, and
sparseness from cyclic allocations was already solved.

> > Otherwise, radix trees require pointer chasing, which we can avoid -
> > which saves us both the cost of chasing pointers (which is significant)
> > and the overhead of storing them.
> 
> Vast majority of which can be avoided with simple caching, right?

Whatever caching optimizations you do with a radix tree version I could
apply to this bitmap tree version, and my bitmap tree code is simpler
and _considerably_ faster than the existing code.
