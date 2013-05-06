Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab3EFSiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 14:38:21 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:57221 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab3EFSiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 14:38:19 -0400
Date: Mon, 6 May 2013 11:38:14 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 21/31] blk-throttle: implement sq_to_tg(), sq_to_td() and
 throtl_log()
Message-ID: <20130506183814.GB32173@mtj.dyndns.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <1367455189-6957-22-git-send-email-tj@kernel.org>
 <20130506173644.GD11731@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130506173644.GD11731@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 01:36:44PM -0400, Vivek Goyal wrote:
> On Wed, May 01, 2013 at 05:39:39PM -0700, Tejun Heo wrote:
> 
> [..]
> > +#define throtl_log(sq, fmt, args...)	do {				\
> > +	struct throtl_grp *__tg = sq_to_tg((sq));			\
> > +	struct throtl_data *__td = sq_to_td((sq));			\
> >  	char __pbuf[128];						\
> >  									\
> > -	blkg_path(tg_to_blkg(tg), __pbuf, sizeof(__pbuf));		\
> > -	blk_add_trace_msg((tg)->td->queue, "throtl %s " fmt, __pbuf, ##args); \
> > +	__pbuf[0] = ' ';						\
> > +	__pbuf[1] = '\0';						\
> > +	if ((__tg))							\
> > +		blkg_path(tg_to_blkg(__tg), __pbuf + 1, sizeof(__pbuf) - 1); \
> > +	blk_add_trace_msg(__td->queue, "throtl%s" fmt, __pbuf, ##args); \
> 						^^
> 
> We need one extra space ("throtl%s "), otherwise all the messages
> start right after cgroup path. We need a space between cgroup path
> and actual message.

Will update.

Thanks.

-- 
tejun
