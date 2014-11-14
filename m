Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161677AbaKNRnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:43:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161175AbaKNRm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:42:59 -0500
Date: Fri, 14 Nov 2014 18:42:52 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Jiri Kosina <jkosina@suse.cz>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] virtio_balloon: Convert "vballon" kthread into a
 workqueue
Message-ID: <20141114174252.GE7969@dhcp128.suse.cz>
References: <1415797368-22660-1-git-send-email-pmladek@suse.cz>
 <20141112133204.GA23334@redhat.com>
 <20141114131915.GD21209@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114131915.GD21209@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-11-14 08:19:15, Tejun Heo wrote:
> Hello, Michael, Petr.
> 
> On Wed, Nov 12, 2014 at 03:32:04PM +0200, Michael S. Tsirkin wrote:
> > > +	/* The workqueue servicing the balloon. */
> > > +	struct workqueue_struct *wq;
> > > +	struct work_struct wq_work;
> > 
> > We could use system_freezable_wq instead.
> > I do agree a dedicated wq is better since this can get blocked
> > for a long time while allocating memory.
> > However, please add a comment to this effect.
> 
> system_freezable_wq should be fine.  Workqueues by default have a
> pretty high maximum concurrency level (256).  There's no reason to
> create separate workqueues solely for that purpose.

Great. If nobody complains until next week, I will send an updated
patch with the system workqueue and also with the fixed typos.

Thanks all reviewers for nice hints.

Best Regards,
Petr
