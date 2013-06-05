Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab3FEOyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:54:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54196 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab3FEOyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:54:03 -0400
Date: Wed, 5 Jun 2013 16:53:13 +0200
From: Jens Axboe <axboe@kernel.dk>
To: hari krishnan <p.harikrishnan22@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bug found in block/scsi_ioctl.c
Message-ID: <20130605145313.GC32665@kernel.dk>
References: <CANk961ZtHzC0cyzGc9WxC9mvqmHpixRKsavuMGMzeuLe+QA5TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANk961ZtHzC0cyzGc9WxC9mvqmHpixRKsavuMGMzeuLe+QA5TQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05 2013, hari krishnan wrote:
> I got a kernel crash, and dump is pointing to "IP: [<ffffffff81260e86>]
> sg_scsi_ioctl+0x166/0x3b0".
> 
> Test case:  *I was just deleting few NPIV port to which some of LUN's where
> exported, after sometime I was running parted on some devices"*
> 
> The crash is in sg_scsi_ioctl of block/scsi_ioctl.c.
> From code and dump it seems sg_scsi_ioctl is allocating request by calling
> blk_get_request and assuming it will never fail, but it will fail if device
> is dead, here in this case some of SCSI devices are dead.

It's a known bug, Joe Lawrence has posted a patch to fix it up that will
be muscled into 3.10.

Can you give it a go?

http://www.spinics.net/lists/linux-scsi/msg66294.html

-- 
Jens Axboe

