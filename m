Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3CRWcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 18:32:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab3CRWcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 18:32:46 -0400
Date: Mon, 18 Mar 2013 23:32:44 +0100
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, laijs@cn.fujitsu.com, fengguang.wu@intel.com,
        linux-kernel@vger.kernel.org, jmoyer@redhat.com
Subject: Re: [PATCH 3/4] writeback: replace custom worker pool
 implementation with unbound workqueue
Message-ID: <20130318223244.GA11188@quack.suse.cz>
References: <1362692649-25570-1-git-send-email-tj@kernel.org>
 <1362692649-25570-4-git-send-email-tj@kernel.org>
 <20130312150510.GF13152@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312150510.GF13152@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 12-03-13 16:05:10, Jan Kara wrote:
> On Thu 07-03-13 13:44:08, Tejun Heo wrote:
> > Writeback implements its own worker pool - each bdi can be associated
> > with a worker thread which is created and destroyed dynamically.  The
> > worker thread for the default bdi is always present and serves as the
> > "forker" thread which forks off worker threads for other bdis.
> > 
> > there's no reason for writeback to implement its own worker pool when
> > using unbound workqueue instead is much simpler and more efficient.
> > This patch replaces custom worker pool implementation in writeback
> > with an unbound workqueue.
  I realized there may be one issue - so far we have a clear identification
which thread works for which bdi in the thread name (flush-x:y naming).
That was useful when debugging things. Now with your worker pool this is
lost, am I right? Would it be possible to restore that?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
