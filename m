Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128Ab3BMOv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 09:51:27 -0500
Received: from mga14.intel.com ([143.182.124.37]:38476 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957Ab3BMOvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 09:51:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,657,1355126400"; 
   d="scan'208";a="201923686"
Message-ID: <1360767081.4784.6.camel@ideak-mobl>
Subject: Re: [PATCH v2] lib/scatterlist: add simple page iterator
From: Imre Deak <imre.deak@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linaro-mm-sig@lists.linaro.org
Date: Wed, 13 Feb 2013 16:51:21 +0200
In-Reply-To: <20130212171305.GB7348@htj.dyndns.org>
References: <1353590706-1366-5-git-send-email-imre.deak@intel.com>
	 <1360608604-3520-1-git-send-email-imre.deak@intel.com>
	 <20130211125422.978c1e99.akpm@linux-foundation.org>
	 <1360688840.5578.75.camel@localhost> <20130212171305.GB7348@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 09:13 -0800, Tejun Heo wrote:
> Hello,
> 
> On Tue, Feb 12, 2013 at 07:07:20PM +0200, Imre Deak wrote:
> > It's the one implemented by sg_miter_{start,stop} in scatterlist.c. It
> > also iterates through a scatterlist a page at a time, but it also kmaps
> > these pages. Since in our use case we don't need to map the pages we
> > needed a solution without this overhead.
> 
> I'm not against having non-mapping iterator but please consider that
> kmaps are no-ops on many configurations.  It matters only for archs w/
> high memory.

Ok, I haven't thought about that. But in any case we care about those
archs too and would like to avoid the mapping there as well.

> > where each entry on the sglist contained 16 consecutive pages. This
> > takes ~10% more time for the uninlined version to run. This is a rather
> > artificial test and I couldn't come up with something more real-life
> > using only the i915 driver's ioctl interface that would show a
> > significant change in speed.
> > 
> > So at least for now I'm ok with just uninlining all the helpers.
> 
> Can we reimplement mapping iters using the new ones?

Yes I think it's a good idea, I will follow up with a new patchset
addressing this and Andrew's comments.

Thanks,
Imre


