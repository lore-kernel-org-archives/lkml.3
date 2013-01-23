Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab3AWBIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 20:08:07 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:33133 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab3AWBID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 20:08:03 -0500
Date: Tue, 22 Jan 2013 17:07:58 -0800
From: Tejun Heo <tj@kernel.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCHSET] workqueue: remove gcwq and make worker_pool the only
 backend abstraction
Message-ID: <20130123010758.GH5359@htj.dyndns.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
 <20130122053702.GA10675@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130122053702.GA10675@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey.

On Tue, Jan 22, 2013 at 02:37:02PM +0900, Joonsoo Kim wrote:
> > It seems like we'll need to support worker pools with custom
> > attributes, which is planned to be implemented as extra worker_pools
> > for the unbound CPU.  Removing gcwq and having worker_pool as the top
> > level abstraction makes things much simpler for such designs.  Also,
> > there's scalability benefit to not sharing locking and busy hash among
> > different worker pools as worker pools w/ custom attributes are likely
> > to have widely different memory / cpu locality characteristics.
> 
> Could you tell me why extra worker_pools with custom attributes are needed?
> Or could you give a reference link for this?

Currently, there are two expected users - writeback and crypto.  The
former currently implements its own worker pool and the latter is
using per-cpu workqueue but not particularly happy with it.  Being
bound to the issuing CPU seems a bit too limiting.

Thanks.

-- 
tejun
