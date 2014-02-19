Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbaBSTBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 14:01:46 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:40993 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbaBSTBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 14:01:44 -0500
Date: Wed, 19 Feb 2014 14:01:39 -0500
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Derek Basehore <dbasehore@chromium.org>,
        Alexander Viro <viro@zento.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Kees Cook <keescook@chromium.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, bleung@chromium.org,
        sonnyrao@chromium.org, semenzato@chromium.org
Subject: Re: [PATCH] backing_dev: Fix hung task on sync
Message-ID: <20140219190139.GQ10134@htj.dyndns.org>
References: <1392437537-27392-1-git-send-email-dbasehore@chromium.org>
 <20140218225548.GI31892@mtj.dyndns.org>
 <20140219092731.GA4849@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219092731.GA4849@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jan.

On Wed, Feb 19, 2014 at 10:27:31AM +0100, Jan Kara wrote:
>   You are the workqueue expert so you may know better ;) But the way I
> understand it is that queue_delayed_work() does nothing if the timer is
> already running. Since we queue flusher work to run either immediately or
> after dirty_writeback_interval we are safe to run queue_delayed_work()
> whenever we want it to run after dirty_writeback_interval and
> mod_delayed_work() whenever we want to run it immediately.

Ah, okay, so it's always mod on immediate and queue on delayed.  Yeah,
that should work.

> But it's subtle and some interface where we could say queue delayed work
> after no later than X would be easier to grasp.

Yeah, I think it'd be better if we had something like
mod_delayed_work_if_later().  Hmm...

Thanks.

-- 
tejun
