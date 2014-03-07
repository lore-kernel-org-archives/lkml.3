Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaCGF7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 00:59:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbaCGF7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 00:59:08 -0500
Date: Fri, 7 Mar 2014 13:59:20 +0800
From: Fam Zheng <famz@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-scsi: Change sense buffer size to 252
Message-ID: <20140307055920.GB2514@T430.nay.redhat.com>
References: <1394095660-15075-1-git-send-email-famz@redhat.com>
 <53184962.3080100@redhat.com>
 <53185A79.9010206@suse.de>
 <53186241.5060106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53186241.5060106@redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03/06 12:55, Paolo Bonzini wrote:
> Il 06/03/2014 12:22, Hannes Reinecke ha scritto:
> >On 03/06/2014 11:09 AM, Paolo Bonzini wrote:
> >>Il 06/03/2014 09:47, Fam Zheng ha scritto:
> >>>According to SPC-4, section 4.5.2.1, 252 is the limit of sense
> >>>data. So
> >>>increase the value.
> >>>
> >>>Signed-off-by: Fam Zheng <famz@redhat.com>
> >>>---
> >>> include/linux/virtio_scsi.h | 2 +-
> >>> 1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>>diff --git a/include/linux/virtio_scsi.h
> >>>b/include/linux/virtio_scsi.h
> >>>index 4195b97..a437f7f 100644
> >>>--- a/include/linux/virtio_scsi.h
> >>>+++ b/include/linux/virtio_scsi.h
> >>>@@ -28,7 +28,7 @@
> >>> #define _LINUX_VIRTIO_SCSI_H
> >>>
> >>> #define VIRTIO_SCSI_CDB_SIZE   32
> >>>-#define VIRTIO_SCSI_SENSE_SIZE 96
> >>>+#define VIRTIO_SCSI_SENSE_SIZE 252
> >>>
> >>> /* SCSI command request, followed by data-out */
> >>> struct virtio_scsi_cmd_req {
> >>>
> >>
> >>Hi Fam, how did you test this?
> >
> >Is there a specific reason _not_ to use the linux default?
> >The SCSI stack typically limits the sense code to
> >SCSI_SENSE_BUFFERSIZE, so using other values have a
> >limited sense.
> >Literally :-)

OK. So, do we need to lift the limit on other parts of SCSI stack as well?

> 
> Indeed I don't think this patch makes a difference.  Though I asked not from
> the SCSI stack perspective, but because right now both virtio-scsi targets
> (QEMU and vhost-scsi) are also truncating at 96.
> 

Oh, I missed that, I'll do a more thorough review and testing. Thank you for
pointing out.

Thanks,
Fam
