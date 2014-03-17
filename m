Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaCQU7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 16:59:51 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:42123 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaCQU7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 16:59:48 -0400
Date: Mon, 17 Mar 2014 16:59:43 -0400
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
Message-ID: <20140317205943.GF17373@mtj.dyndns.org>
References: <1392437537-27392-1-git-send-email-dbasehore@chromium.org>
 <20140218225548.GI31892@mtj.dyndns.org>
 <20140219092731.GA4849@quack.suse.cz>
 <20140219190139.GQ10134@htj.dyndns.org>
 <CAGAzgspTZnUh_qi=FeQ4hS4LRiexPccTyALMg3Gt1K0ZZq_MuQ@mail.gmail.com>
 <20140316145951.GB26026@htj.dyndns.org>
 <CAGAzgsqD0aRnDMMyDCUVii6Rv22f97G0irpzFBz4c_ukKsn2hg@mail.gmail.com>
 <20140317144020.GA13749@htj.dyndns.org>
 <CAGAzgsrQvJL8BFF1ADVvi9oWjyPaaKdFh20OGUg-BCvtNmMc1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGAzgsrQvJL8BFF1ADVvi9oWjyPaaKdFh20OGUg-BCvtNmMc1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 01:53:57PM -0700, dbasehore . wrote:
> It will still be at least be pending after the specified time has
> passed. I'm proposing that we still set the timer. The difference is
> that there is a possibility the work will already be pending when the
> timer goes off. There will still at least be an execution after the
> given time has past. We could still remove the work in the workqueue
> from the timer function, but this would make the mod_delayed_work not
> race with any work that was scheduled for immediate execution
> previously.

I really don't see what you're suggesting happening.  Managing work
item pending status is already extremely delicate and I'd like to keep
all the paths which can share pending state management to do so.
You're suggesting introducing a new pending state where a work item
may be pending in two different places which will also affect cancel
and flushing for rather dubious benefit.  If you can write up a patch
which isn't too complicated, let's talk about it, but I'm likely to
resist any significant amount of extra complexity coming from it.

Thanks.

-- 
tejun
