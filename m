Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365Ab3FCWjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:39:45 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:48198 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab3FCWji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:39:38 -0400
Date: Mon, 3 Jun 2013 15:39:31 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Generic percpu refcounting
Message-ID: <20130603223931.GD29989@mtj.dyndns.org>
References: <1370039205-14071-1-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370039205-14071-1-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 03:26:45PM -0700, Kent Overstreet wrote:
> This implements a refcount with similar semantics to
> atomic_get()/atomic_dec_and_test() - but percpu.
> 
> It also implements two stage shutdown, as we need it to tear down the
> percpu counts.  Before dropping the initial refcount, you must call
> percpu_ref_kill(); this puts the refcount in "shutting down mode" and
> switches back to a single atomic refcount with the appropriate barriers
> (synchronize_rcu()).
> 
> It's also legal to call percpu_ref_kill() multiple times - it only returns
> true once, so callers don't have to reimplement shutdown synchronization.
> 
> [akpm@linux-foundation.org: fix build]
> [akpm@linux-foundation.org: coding-style tweak]
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> Cc: Zach Brown <zab@redhat.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Asai Thambi S P <asamymuthupa@micron.com>
> Cc: Selvan Mani <smani@micron.com>
> Cc: Sam Bradshaw <sbradshaw@micron.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Benjamin LaHaise <bcrl@kvack.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Applied to percpu/for-3.11.  Andrew, I removed your SOB as the patch
is routed outside -mm.  Please let me know if you want
reviewed/ackd-by added.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.11

Thanks a lot!

-- 
tejun
