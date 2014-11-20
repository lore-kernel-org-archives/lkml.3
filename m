Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbaKTQue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:50:34 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:35009 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757084AbaKTQuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:50:32 -0500
Date: Thu, 20 Nov 2014 11:50:28 -0500
From: Tejun Heo <tj@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Petr Mladek <pmladek@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
        Jeff Epler <jepler@unpythonic.net>, Jiri Kosina <jkosina@suse.cz>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] virtio_balloon: Convert "vballoon" kthread into a
 workqueue
Message-ID: <20141120165028.GM14877@htj.dyndns.org>
References: <1416499397-16669-1-git-send-email-pmladek@suse.cz>
 <20141120160746.GI14877@htj.dyndns.org>
 <20141120162543.GA7466@redhat.com>
 <20141120162624.GA7479@redhat.com>
 <20141120162935.GK14877@htj.dyndns.org>
 <20141120164711.GA7495@redhat.com>
 <20141120164933.GL14877@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120164933.GL14877@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 11:49:33AM -0500, Tejun Heo wrote:
> On Thu, Nov 20, 2014 at 06:47:11PM +0200, Michael S. Tsirkin wrote:
> > > There's cancel_work_sync() to stop the self-requeueing ones.
> > 
> > What happens if queue_work runs while cancel_work_sync is in progress?
> > Does it fail to queue?
> 
> cancel_work_sync() is guaranteed to take self-requeueing work items no
                                      ^ stop

-- 
tejun
