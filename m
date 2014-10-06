Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaJFMUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 08:20:50 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:59316 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaJFMUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 08:20:48 -0400
Date: Mon, 6 Oct 2014 14:20:38 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 06/16] virtio_blk: drop config_enable
Message-ID: <20141006142038.07ea01f0.cornelia.huck@de.ibm.com>
In-Reply-To: <20141006120953.GA26549@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
	<1412525038-15871-7-git-send-email-mst@redhat.com>
	<20141006134229.45465bf7.cornelia.huck@de.ibm.com>
	<20141006120953.GA26549@redhat.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100612-4966-0000-0000-0000018F4D8B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2014 15:09:53 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Mon, Oct 06, 2014 at 01:42:29PM +0200, Cornelia Huck wrote:
> > On Sun, 5 Oct 2014 19:07:07 +0300
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > 
> > > Now that virtio core ensures config changes don't
> > > arrive during probing, drop config_enable flag
> > > in virtio blk.
> > > On removal, flush is now sufficient to guarantee that
> > > no change work is queued.
> > > 
> > > This help simplify the driver, and will allow
> > > setting DRIVER_OK earlier without losing config
> > > change notifications.
> > > 
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > ---
> > >  drivers/block/virtio_blk.c | 19 ++-----------------
> > >  1 file changed, 2 insertions(+), 17 deletions(-)
> > > 
> > > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > > index 0a58140..c8cf6a1 100644
> > > --- a/drivers/block/virtio_blk.c
> > > +++ b/drivers/block/virtio_blk.c
> > 
> > > @@ -772,9 +766,7 @@ static void virtblk_remove(struct virtio_device *vdev)
> > >  	int refc;
> > > 
> > >  	/* Prevent config work handler from accessing the device. */
> > 
> > /* Common code ensures no further work will be queued. */
> > 
> > instead?
> 
> No, I think you missed the point:
> this comment now refers to the flush below: flush is required to
> ensure work handler is not running.
> 
> Agree?

I think we both mean the same thing.

Preventing the handler from access sounds to me more like "when the
handler starts running, it is prevented from accessing the
device" (like with setting config_enable, as the code did before). What
I meant was "common code has already ensured that our work-queueing
function will not be called, therefore flushing the workqueue is
enough."

(same for net)

