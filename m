Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbaEWRit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 13:38:49 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:51703 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaEWRis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 13:38:48 -0400
Message-ID: <1400866717.30565.3.camel@haakon3.risingtidesystems.com>
Subject: Re: linux-next: build failure after merge of the target-updates tree
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        target-devel <target-devel@vger.kernel.org>
Date: Fri, 23 May 2014 10:38:37 -0700
In-Reply-To: <20140523191159.6a064678@canb.auug.org.au>
References: <20140523191159.6a064678@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

(Adding CC's for Paolo + MKP)

On Fri, 2014-05-23 at 19:11 +1000, Stephen Rothwell wrote:
> Hi Nicholas,
> 
> After merging the target-updates tree, today's linux-next build
> (powerpc ppc64_defconfig) failed like this:
> 
> 
> drivers/scsi/virtio_scsi.c: In function 'virtio_scsi_init_hdr_pi':
> drivers/scsi/virtio_scsi.c:491:48: error: dereferencing pointer to incomplete type
>    cmd_pi->pi_bytesout = blk_rq_sectors(rq) * bi->tuple_size;
>                                                 ^
> drivers/scsi/virtio_scsi.c:493:47: error: dereferencing pointer to incomplete type
>    cmd_pi->pi_bytesin = blk_rq_sectors(rq) * bi->tuple_size;
>                                                ^
> 
> Caused by commit 4baaa7d589e2 ("virtio-scsi: Enable DIF/DIX modes in
> SCSI host LLD").  A missing include of linux/blkdev.h.  See Rule 1 in
> Documentation/SubmitChecklist.
> 
> I have used the target-updates tree from next-20140522 for today.

Whoops, adding the missing #include <linux/blkdev.h> now..

Thanks!

--nab

