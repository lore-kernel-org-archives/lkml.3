Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaCPO74 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 10:59:56 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:38898 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaCPO7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 10:59:55 -0400
Date: Sun, 16 Mar 2014 10:59:51 -0400
From: Tejun Heo <tj@kernel.org>
To: "dbasehore ." <dbasehore@chromium.org>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zento.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Kees Cook <keescook@chromium.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        bleung@chromium.org, sonnyrao@chromium.org,
        Luigi Semenzato <semenzato@chromium.org>
Subject: Re: [PATCH] backing_dev: Fix hung task on sync
Message-ID: <20140316145951.GB26026@htj.dyndns.org>
References: <1392437537-27392-1-git-send-email-dbasehore@chromium.org>
 <20140218225548.GI31892@mtj.dyndns.org>
 <20140219092731.GA4849@quack.suse.cz>
 <20140219190139.GQ10134@htj.dyndns.org>
 <CAGAzgspTZnUh_qi=FeQ4hS4LRiexPccTyALMg3Gt1K0ZZq_MuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGAzgspTZnUh_qi=FeQ4hS4LRiexPccTyALMg3Gt1K0ZZq_MuQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 01:22:53PM -0700, dbasehore . wrote:
> mod_delayed_work currently removes a work item from a workqueue if it
> is on it. Correct me if I'm wrong, but I don't think that this is
> necessarily required for mod_delayed_work to have the current
> behavior. We should be able to set the timer while a delayed_work is
> currently on a workqueue. If the delayed_work is still on the
> workqueue when the timer goes off, everything is fine. If it has left
> the workqueue, we can queue it again.

What different would that make w.r.t. this issue?  Plus, please note
that a work item may wait non-insignificant amount of time pending if
the workqueue is saturated to max_active.  Doing the above would make
mod_delayed_work()'s behavior quite fuzzy - the work item is modified
or queued to the specified time but if the timer has already expired,
the work item may execute after unspecified amount of time which may
be shorter than the new timeout.  What kind of interface would that
be?

Thanks.

-- 
tejun
