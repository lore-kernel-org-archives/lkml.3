Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161038AbaKNNTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 08:19:21 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:44593 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964865AbaKNNTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 08:19:19 -0500
Date: Fri, 14 Nov 2014 08:19:15 -0500
From: Tejun Heo <tj@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Petr Mladek <pmladek@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
        Jiri Kosina <jkosina@suse.cz>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] virtio_balloon: Convert "vballon" kthread into a
 workqueue
Message-ID: <20141114131915.GD21209@htj.dyndns.org>
References: <1415797368-22660-1-git-send-email-pmladek@suse.cz>
 <20141112133204.GA23334@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112133204.GA23334@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michael, Petr.

On Wed, Nov 12, 2014 at 03:32:04PM +0200, Michael S. Tsirkin wrote:
> > +	/* The workqueue servicing the balloon. */
> > +	struct workqueue_struct *wq;
> > +	struct work_struct wq_work;
> 
> We could use system_freezable_wq instead.
> I do agree a dedicated wq is better since this can get blocked
> for a long time while allocating memory.
> However, please add a comment to this effect.

system_freezable_wq should be fine.  Workqueues by default have a
pretty high maximum concurrency level (256).  There's no reason to
create separate workqueues solely for that purpose.

Thanks.

-- 
tejun
