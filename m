Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab3BEQuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:50:23 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:60994 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab3BEQuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:50:21 -0500
Date: Tue, 5 Feb 2013 08:50:16 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] workqueue: enhance locking and record global
 worker id for work data
Message-ID: <20130205165016.GB4276@mtj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <20130204210429.GB27963@mtj.dyndns.org>
 <CACvQF52Lqi2TuXc9oCdGkAzxcpE12YfuX=9-jp5tePsOqPBe6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF52Lqi2TuXc9oCdGkAzxcpE12YfuX=9-jp5tePsOqPBe6w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Wed, Feb 06, 2013 at 12:19:26AM +0800, Lai Jiangshan wrote:
> > Can't we just make get_work_pool_id() do a fast path if OFFQ than
> > requiring the user to distinguish off and on queue cases?
> 
> old code, get_work_pool_id() is only called when offq.
> after series applied, offq_work_worker_id() *must* be called only when offq,
> and we can't offer get_work_worker_id().

Can you please elaborate why we can't offer get_work_worker_id()?

> > While I'm a bit worried about capping total number of workers by the
> > amount bits left in work->data, if that doesn't cause any practical
> > issue (how many do we have available on 32bit?), I think this is the
> > better approach.  We couldn't do this before because work -> worker
> > relationship could be 1:N but it should now be doable.  Note that we
> > need RCU no matter what we index (pool or worker) to avoid locking on
> > each lookup.
> 
> BUILD_BUG_ON((BITS_PER_LONG != 64) && (WORK_OFFQ_WORKER_SHIFT > 12));
> 
> Every worker needs at least 4k memory for its stack, the bits are enough if
> WORK_OFFQ_WORKER_SHIFT <= 12.

Ah, so that was what that comment was about, so we always have enough
bits.  I have to say the comment is a bit cryptic.

> > From past experience, I *think* it's gonna be a bit of struggle for
> > both of us to get the series in a shape that I would find acceptable
> > by reviewing and iterating, so I might just swallow it and regurgitate
> > into a form that I like.  Hmm.... dunno.  Will think about it.
> 
> It is not nightmare for me! the work and discusses will consume most
> time of my night, no night time for nightmare.

Heh, yeah, I didn't say it was a nightmare.  I do like your work.  I
think most problems are from communication (including description and
comments).  I guess I can help along for a while.

> > Anyways, nice work.
> >
> I'm glad you like it. My daughter was born about 3month ago and I left
> workqueue work then. I think it is time to pick up old pending
> patches.

Big congratulations.  :)

Thanks!

-- 
tejun
