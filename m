Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbaH0Jen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 05:34:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42436 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbaH0Jel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 05:34:41 -0400
Date: Wed, 27 Aug 2014 10:34:37 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: [PATCH v3 part1 0/4] Fix SG_IO ambiguity between READ SUBCHANNEL
 and UNMAP (and other similar cases)
Message-ID: <20140827093437.GA10937@hercules>
References: <1369317503-4095-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1369317503-4095-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 03:58:19PM +0200, Paolo Bonzini wrote:
> The SG_IO ioctl's command whitelist is designed for MMC devices (roughly,
> "play/burn CDs without requiring root") but some opcodes overlap across SCSI
> device classes and have different meanings for different classes.
> 
> To fix this, use different bitmaps for the various device classes.
> This is CVE-2012-4542.
>

Sorry for bringing this old issue again, but I was wondering what
happen to this fix.

Cheers,
--
Luís

> v2->v3: patches are now split differently, according to Tejun's indications;
> 	added conflict on operation code A4h.
> 
> Paolo Bonzini (4):
>   sg_io: pass request_queue to blk_verify_command
>   sg_io: prepare to introduce per-class command filters
>   sg_io: use different default filters for each device class
>   sg_io: resolve conflicts between commands assigned to multiple classes
>     (CVE-2012-4542)
> 
>  block/bsg.c              |   2 +-
>  block/scsi_ioctl.c       | 193 +++++++++++++++++++++++++++--------------------
>  drivers/scsi/scsi_scan.c |   2 +
>  drivers/scsi/sg.c        |   3 +-
>  include/linux/blkdev.h   |   5 +-
>  5 files changed, 118 insertions(+), 87 deletions(-)
> 
> -- 
> 1.8.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
