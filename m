Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaAGWAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 17:00:06 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61847 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbaAGV75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 16:59:57 -0500
Date: Tue, 7 Jan 2014 13:59:54 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-bcache@vger.kernel.org, Neil Brown <neilb@suse.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] bcache/md: Use raid stripe size
Message-ID: <20140107215954.GL9037@kmo>
References: <1387415531-10713-1-git-send-email-kmo@daterainc.com>
 <CAMM=eLcGTYcSdYW9vWYWk64dRuwgyY_O90NySb_jR9zQTCBTJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMM=eLcGTYcSdYW9vWYWk64dRuwgyY_O90NySb_jR9zQTCBTJg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 09:04:25PM -0500, Mike Snitzer wrote:
> On Wed, Dec 18, 2013 at 8:12 PM, Kent Overstreet <kmo@daterainc.com> wrote:
> > Now that we've got code for raid5/6 stripe awareness, bcache just needs
> > to know about the stripes and when writing partial stripes is expensive
> > - we probably don't want to enable this optimization for raid1 or 10,
> > even though they have stripes. So add a flag to queue_limits.
> >
> > Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> > ---
> > This is in my pile of bcache stuff queued up for 3.14 - if no one objects it'll
> > be in my bcache pull request:
> >
> >  drivers/md/bcache/super.c | 6 ++++++
> >  drivers/md/raid5.c        | 1 +
> >  include/linux/blkdev.h    | 1 +
> >  3 files changed, 8 insertions(+)
> 
> Hi Kent,
> 
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index 02cb6f0ea7..0375654adb 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -291,6 +291,7 @@ struct queue_limits {
> >         unsigned char           discard_misaligned;
> >         unsigned char           cluster;
> >         unsigned char           discard_zeroes_data;
> > +       unsigned char           raid_partial_stripes_expensive;
> >  };
> >
> >  struct request_queue {
> 
> If you add a new member to queue_limits you need to update
> blk_stack_limits() so that it propagates as you stack devices.

Thanks, going to send Jens a new pull after he does some merging so I'll include
that in the updated version.
