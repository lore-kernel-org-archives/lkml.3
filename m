Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3CSMAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 08:00:36 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38898 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799Ab3CSMAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 08:00:35 -0400
Message-ID: <1363694427.2377.57.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH V5 1/5] virtio-scsi: redo allocation of target data
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
        mst@redhat.com, asias@redhat.com
Date: Tue, 19 Mar 2013 12:00:27 +0000
In-Reply-To: <51484FC2.6030601@redhat.com>
References: <1363687057-13580-1-git-send-email-gaowanlong@cn.fujitsu.com>
	  <1363687057-13580-2-git-send-email-gaowanlong@cn.fujitsu.com>
	 <1363692727.2377.53.camel@dabdike.int.hansenpartnership.com>
	 <51484FC2.6030601@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.6.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 12:45 +0100, Paolo Bonzini wrote:
> Il 19/03/2013 12:32, James Bottomley ha scritto:
> > On Tue, 2013-03-19 at 17:57 +0800, Wanlong Gao wrote:
> >> From: Paolo Bonzini <pbonzini@redhat.com>
> >>
> >> virtio_scsi_target_state is now empty.  We will find new uses for it in
> >> the next few patches, so this patch does not drop it completely.
> >> However, having dropped the sglist flexible array member, we can turn
> >> the tgt array-of-pointers into a simple array.  This simplifies the
> >> allocation.
> >>
> >> Even simpler would be to place the virtio_scsi_target_state structs in a
> >> flexible array member at the end of struct virtio_scsi.  But we do not
> >> do that, because we will place the virtqueues there in the next patches.
> > 
> > I'm really sorry, but I must have been asleep at the wheel when I let
> > code like this go in.  No modern driver should have fixed arrays for
> > target information.  The way this is supposed to work is that you have
> > entries in the host template for target_alloc and target_destroy.  You
> > hook into these and attach your struct virtio_scsi_target_state to
> > scsi_target->hostdata,
> 
> So that would be sc->device->sdev_target->hostdata.

No, unfortunate name, but it's used for something else (actually, I
think it *was* used by something else and is unused now).  The construct
is

scsi_target(sc->device)->hostdata

James


