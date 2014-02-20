Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaBTNtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 08:49:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbaBTNtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 08:49:15 -0500
From: Hannes Reinecke <hare@suse.de>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Graf <agraf@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/2] loop: support different blocksizes
Date: Thu, 20 Feb 2014 14:48:49 +0100
Message-Id: <1392904131-71320-1-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

the loop device already contains rudimentary support for blocksizes
other than 512 bytes, so this patchset enables the loop device
to use a different blocksize.
The new module parameter 'lbs' specify the blocksize to use,
or '0' to use the blocksize of the underlying device (which defaults
to PAGE_SIZE for files).
Eventually it might be useful to select the blocksize per device, but
the interface for that will need to be discussed.

Hannes Reinecke (2):
  loop: Display correct physical blocksize
  loop: Add module parameter 'lbs' to set logical blocksize

 drivers/block/loop.c | 65 ++++++++++++++++++++++++++++++++++++++--------------
 drivers/block/loop.h |  1 +
 2 files changed, 49 insertions(+), 17 deletions(-)

-- 
1.7.12.4

