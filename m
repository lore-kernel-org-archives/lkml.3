Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab3EFUlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:41:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756312Ab3EFUlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:41:51 -0400
Date: Mon, 6 May 2013 16:41:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 21/31] blk-throttle: implement sq_to_tg(), sq_to_td() and
 throtl_log()
Message-ID: <20130506204141.GF11731@redhat.com>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <1367455189-6957-22-git-send-email-tj@kernel.org>
 <20130506173644.GD11731@redhat.com>
 <20130506203827.GE800@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130506203827.GE800@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 01:38:27PM -0700, Tejun Heo wrote:
> On Mon, May 06, 2013 at 01:36:44PM -0400, Vivek Goyal wrote:
> > On Wed, May 01, 2013 at 05:39:39PM -0700, Tejun Heo wrote:
> > 
> > [..]
> > > +#define throtl_log(sq, fmt, args...)	do {				\
> > > +	struct throtl_grp *__tg = sq_to_tg((sq));			\
> > > +	struct throtl_data *__td = sq_to_td((sq));			\
> > >  	char __pbuf[128];						\
> > >  									\
> > > -	blkg_path(tg_to_blkg(tg), __pbuf, sizeof(__pbuf));		\
> > > -	blk_add_trace_msg((tg)->td->queue, "throtl %s " fmt, __pbuf, ##args); \
> > > +	__pbuf[0] = ' ';						\
> > > +	__pbuf[1] = '\0';						\
> > > +	if ((__tg))							\
> > > +		blkg_path(tg_to_blkg(__tg), __pbuf + 1, sizeof(__pbuf) - 1); \
> > > +	blk_add_trace_msg(__td->queue, "throtl%s" fmt, __pbuf, ##args); \
> > 
> > We need one extra space ("throtl%s "), otherwise all the messages
> > start right after cgroup path. We need a space between cgroup path
> > and actual message.
> 
> Okay, we don't - __pbuf[0] = ' '.  The reason it's doing the above
> instead of "throtl %s " is because when the path is nil, we don't
> wanna print out two consecutive spaces, so AFAICS the code is correct.

What about space after the cgroup path info (when path is not nil).

Vivek
