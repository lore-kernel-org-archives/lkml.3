Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495Ab3BLRNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:13:13 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:43751 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372Ab3BLRNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:13:12 -0500
Date: Tue, 12 Feb 2013 09:13:05 -0800
From: Tejun Heo <tj@kernel.org>
To: Imre Deak <imre.deak@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH v2] lib/scatterlist: add simple page iterator
Message-ID: <20130212171305.GB7348@htj.dyndns.org>
References: <1353590706-1366-5-git-send-email-imre.deak@intel.com>
 <1360608604-3520-1-git-send-email-imre.deak@intel.com>
 <20130211125422.978c1e99.akpm@linux-foundation.org>
 <1360688840.5578.75.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360688840.5578.75.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 12, 2013 at 07:07:20PM +0200, Imre Deak wrote:
> It's the one implemented by sg_miter_{start,stop} in scatterlist.c. It
> also iterates through a scatterlist a page at a time, but it also kmaps
> these pages. Since in our use case we don't need to map the pages we
> needed a solution without this overhead.

I'm not against having non-mapping iterator but please consider that
kmaps are no-ops on many configurations.  It matters only for archs w/
high memory.

> where each entry on the sglist contained 16 consecutive pages. This
> takes ~10% more time for the uninlined version to run. This is a rather
> artificial test and I couldn't come up with something more real-life
> using only the i915 driver's ioctl interface that would show a
> significant change in speed.
> 
> So at least for now I'm ok with just uninlining all the helpers.

Can we reimplement mapping iters using the new ones?

Thanks.

-- 
tejun
