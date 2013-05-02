Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761518Ab3EBR3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:29:01 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:62653 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761071Ab3EBR2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:28:04 -0400
Date: Thu, 2 May 2013 10:27:58 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 07/31] blk-throttle: removed deferred config application
 mechanism
Message-ID: <20130502172758.GI19814@mtj.dyndns.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <1367455189-6957-8-git-send-email-tj@kernel.org>
 <20130502144912.GE30020@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502144912.GE30020@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 10:49:12AM -0400, Vivek Goyal wrote:
> > +	/* kick dispatch in case disptime got shortened */
> >  	throtl_schedule_delayed_work(td, 0);
> 
> Hi Tejun,
> 
> Do we need above throtl_schedule_delayed_work() now?
> throtl_schedule_next_dispatch() should take care of it. And if group
> is not on service tree at the time of limit change, then anyway, we don't
> have to schedule any work.

Right, that one can go away.

Thanks.

-- 
tejun
