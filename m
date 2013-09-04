Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910Ab3IDUfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:35:37 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51039 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758229Ab3IDUff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:35:35 -0400
Date: Wed, 4 Sep 2013 16:35:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] tracing/events: Add bounce tracing to swiotbl-xen
Message-ID: <20130904203502.GA8726@phenom.dumpdata.com>
References: <1377208048-8963-1-git-send-email-zoltan.kiss@citrix.com>
 <20130823125533.GC14306@konrad-lan.dumpdata.com>
 <5224D0D6.40908@citrix.com>
 <20130903124237.GB9870@konrad-lan.dumpdata.com>
 <522793CA.3060002@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522793CA.3060002@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 09:10:50PM +0100, Zoltan Kiss wrote:
> On 03/09/13 13:42, Konrad Rzeszutek Wilk wrote:
> >Correct. The double buffering code is being run in lib/swiotlb.c not the
> >xen-swiotlb.c. Hence the question of why not move the tracing in there.
> I've put the trace to both locations before swiotlb_tbl_map_single
> is called, so the same tracer will be hit both with classic and Xen
> SWIOTLB. I used 2 different place instead of calling from
> swiotlb_tbl_map_single because I want to print out dev_addr, and
> it's calculated differently.
> 
> >Yes. And please (if it adds a benefit) also for unmap/sync which can trigger
> >the bounce buffer.
> >
> >Or if it makes sense just for the bounce buffer copying - then just
> >leave it at that. Thanks.
> For me the relevant event was to see when we start to do bounce
> buffering. When does it end, or when syncing happens is a different
> thing. If someone is interested, they can easily extend this patch
> with that.
> 
> However one question bothers me: why ftrace doesn't trace these
> functions? They are not inlined, static, or marked as notrace.

They are usually part of the dma_ops structure. That might be the reason.
> 
> Regards,
> 
> Zoli
