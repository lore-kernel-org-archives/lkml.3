Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761942Ab3EBSuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:50:01 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:52527 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761824Ab3EBSt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:49:59 -0400
Date: Thu, 2 May 2013 11:49:53 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCHSET] blk-throttle: implement proper hierarchy support
Message-ID: <20130502184953.GP19814@mtj.dyndns.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <20130502173428.GA4771@redhat.com>
 <20130502175701.GL19814@mtj.dyndns.org>
 <20130502181747.GH30020@redhat.com>
 <20130502182933.GN19814@mtj.dyndns.org>
 <20130502184514.GI30020@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502184514.GI30020@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 02, 2013 at 02:45:14PM -0400, Vivek Goyal wrote:
> I did not understand this point. In flat model, application issuing
> at configured page will not get penalized.
> 
> This penalty is coming from the fact that we are moving bios after the
> wait and make them wait in another queue.
> 
> In flat model there is no such problem. So to me, it is the problem
> of how hierarchical scheduling is implemented. In flat model, I did
> not have to deal with it.

But seen from the parent, the child isn't different from any other
issuer in flat hierarchy.  It's just being repeated, so if you assume
a process which behaves in the exact same manner, that process would
get penalized too.  e.g. imagine an application which throttles itself
and issues exactly 1MB/s amount of data in direct IO.  It'd get
penalized the same way, right?

> Ok. Not having a perfect algorithm now is fine. We can always redo it
> later.

I think we can do source-based RR on bio_lists[] fetching which is
simple enough and should be able to avoid most of the problems, right?

Thanks.

-- 
tejun
