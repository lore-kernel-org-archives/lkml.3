Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaF3URq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 16:17:46 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:51803 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaF3URp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 16:17:45 -0400
Date: Mon, 30 Jun 2014 16:17:41 -0400
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Brian Lane <bcl@redhat.com>, John McCutchan <john@johnmccutchan.com>,
        Robert Love <rlove@rlove.org>, Eric Paris <eparis@parisplace.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: virt_blk BUG: sleeping function called from invalid context
Message-ID: <20140630201741.GA20853@htj.dyndns.org>
References: <CA+5PVA4h2hQJLrAm4eEZ8oUgGiAjq2y5eAyBcJWxK_FiQXnuQg@mail.gmail.com>
 <20140629082637.GA23942@redhat.com>
 <20140629193222.GA7030@lst.de>
 <20140629204710.GB11100@redhat.com>
 <53B07D48.60003@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B07D48.60003@kernel.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 02:55:36PM -0600, Jens Axboe wrote:
> > commit d911d98748018f7c8facc035ba39c30f5cce6f9c
> > Author: Tejun Heo <tj@kernel.org>
> > Date:   Wed Apr 9 11:07:31 2014 -0400
> > 
> >     kernfs: make kernfs_notify() trigger inotify events too
> > 
> > Tejun, what do you think?
> > 
> > Josh, Brian, could you try reverting that commit to see if it helps?
> 
> That definitely be a bug. If you need to block off ->bi_end_io(), just
> must punt to a worker thread.

Ugh... didn't realize we had users triggering sysfs notifications from
an atomic context.  fsnotify support requires sleepable context.
Guess I'll have to punt it to a work item. :(

Thanks.

-- 
tejun
