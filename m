Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaFFLqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 07:46:38 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50778 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaFFLqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 07:46:35 -0400
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: axboe@fb.com
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH] Small correction to blk_rq_set_block_pc
Date: Fri,  6 Jun 2014 13:46:00 +0200
Message-Id: <1402055161-25533-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

The blk_rq_set_block_pc() overwrites rq->__data_len after its being set in
blk_rq_map_kern().

It leads to some interesting error messages when booted with SCSI device.

Matias Bjørling (1):
  block: blk_rq_set_block_pc overwrites __data_len

 drivers/block/pktcdvd.c                    | 2 +-
 drivers/cdrom/cdrom.c                      | 2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c | 2 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c | 2 +-
 drivers/scsi/scsi_lib.c                    | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

-- 
1.9.1

