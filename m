Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab3JIUEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 16:04:44 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:52980 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab3JIUEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 16:04:43 -0400
Message-ID: <1381349594.19256.486.camel@haakon3.risingtidesystems.com>
Subject: Re: scsi-mq updated to latest linux-block/new-queue
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Tejun Heo <tj@kernel.org>
Date: Wed, 09 Oct 2013 13:13:14 -0700
In-Reply-To: <20131009194658.GA3066@dhcp-26-207.brq.redhat.com>
References: <1381345971.19256.461.camel@haakon3.risingtidesystems.com>
	 <20131009194658.GA3066@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-09 at 21:46 +0200, Alexander Gordeev wrote:
> On Wed, Oct 09, 2013 at 12:12:51PM -0700, Nicholas A. Bellinger wrote:
> > Just a heads up that the scsi-mq alpha branch has been updated to Jen's
> > latest linux-block/new-queue containing hch's recent blk-mq
> > improvements, along with Alexander's patch for the is_flush_fua +
> > queue_depth=1 bug.
> 
> 
> Oh, I have not expected it could be picked up. In fact I agree it needs
> to be updated with what you spotted:
> 
> "Also, these extra increments should probably happen only when the passed
> queue_depth == 1 && reserved_tags == 0."

Yes, of course.  Fixing that up now in blk_mq_init_queue().

> 
> What is the criteria for patches to include in your tree? I would suggest
> to consider this one https://lkml.org/lkml/2013/8/9/90 if it fits.
> 

Since it's libata related, I'd like Tejun (CC'ed) to be comfortable with
the approach first..

As I'm still using IDE for my rootfs with scsi-mq, I'd be fine with
applying it for AHCI testing purposes if there are no objections.

Care to send out an updated version..?

--nab

