Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab3KNIGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 03:06:16 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:58732 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3KNIGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 03:06:14 -0500
Message-ID: <1384416960.18704.47.camel@haakon3.risingtidesystems.com>
Subject: Re: [GIT PULL] block IO core bits for 3.13
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date: Thu, 14 Nov 2013 00:16:00 -0800
In-Reply-To: <20131108174856.GA3195@kernel.dk>
References: <20131108174856.GA3195@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-08 at 10:48 -0700, Jens Axboe wrote:
> Hi Linus,
> 
> This is the pull request for the core changes in the block layer for
> 3.13. It contains:
> 
> - The new blk-mq request interface. This is a new and more scalable
>   queueing model that marries the best part of the request based
>   interface we currently have (which is fully featured, but scales
>   poorly) and the bio based "interface" which the new drivers for high
>   IOPS devices end up using because it's much faster than the request
>   based one. The bio interface has no block layer support, since it taps
>   into the stack much earlier. This means that drivers end up having to
>   implement a lot of functionality on their own, like tagging, timeout
>   handling, requeue, etc. The blk-mq interface provides all these. Some
>   drivers even provide a switch to select bio or rq and has code to
>   handle both, since things like merging only works in the rq model and
>   hence is faster for some workloads. This is a huge mess. Conversion of
>   these drivers nets us a substantial code reduction. Initial results on
>   converting SCSI to this model even shows an 8x improvement on single
>   queue devices. So while the model was intended to work on the newer
>   multiqueue devices, it has substantial improvements for "classic"
>   hardware as well. This code has gone through extensive testing and
>   development, it's now ready to go. A pull request is coming to convert
>   virtio-blk to this model will be will be coming as well, with more
>   drivers scheduled for 3.14 conversion.
> 

Hey Jens,

Just wanted to say, congratulations on this evenings merge of blk-mq!

I'm really excited to see this code upstream in v3.13, and the merge
being a catalyst for the next generation of flash device design that
takes advantage of all blk-mq has to offer.

Not to mention, progressing scsi-mq forward from alpha prototype -> beta
status over the next months, to move beyond our current SCSI initiator
performance constraints.

So, perhaps fitting NAME for v3.13 would be along the lines of
"I/O, the next generation".

;-)

--nab

