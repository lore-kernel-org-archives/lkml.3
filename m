Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab3FIXU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 19:20:26 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:50186 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab3FIXUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 19:20:25 -0400
MIME-Version: 1.0
Date: Sun, 9 Jun 2013 18:20:24 -0500
Message-ID: <CAD=GYpbFF_F+5xdf3PirbNkfjym+iZtHBVPuney=7fvi_yYDSA@mail.gmail.com>
Subject: Block layer / MMC: Order of segments in SG-list
From: Joel A Fernandes <agnel.joel@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>
Cc: "Fernandes, Joel A" <joelagnel@ti.com>, axboe@kernel.dk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
So I tried dumping addresses of an SG list in omap_hsmmc driver before
it is passed to DMA.

I found some interesting traces occasionally such as the below SG list
of length 4.

[    6.758716] (0) length=4096, sg virt addr=c1318000, sg phy addr=81318000
[    6.765863] (1) length=4096, sg virt addr=c1317000, sg phy addr=81317000
[    6.773011] (2) length=4096, sg virt addr=c1316000, sg phy addr=81316000
[    6.780087] (3) length=4096, sg virt addr=c1315000, sg phy addr=81315000

What is interesting is these chunks are really physically contiguous
but in reverse order in the list. I think a smarter ordering can
actually improve through put considerably and save precious DMA
resources by not having to allocate slots for parts of contiguous
chunk of physical memory.

Is there any particular reason why this might be the case? I traced to
find that the SG list is actually prepared by mmc_queue_map_sg ->
blk_rq_map_sg

Thanks in advance on any insight on the above.

Regards,
Joel
