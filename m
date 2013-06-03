Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab3FCKAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:00:23 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:62788 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab3FCKAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:00:20 -0400
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Misc ext4 fixes
Date: Mon,  3 Jun 2013 13:00:14 +0300
Message-Id: <1370253616-8173-1-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys,

Here are few patches that add sanity checks
before dereferencing some pointers inside of
ext4/jbd2 functions and help to avoid some crashes
on systems under high load and limited resources.
I met them in next usecase: writing a high-bitrate
video to ext4 partition from HD webcam. The issues
appear very rare.
I do not know if these issues are already fixed in some
maintainers repo, but they are still applicable
to 3.10-rc4 tag on which they are based on.
I understand that just sanity checking may not be
enough and the root cause may be in some other
place, so I hope the patches will be reviewed
by ext4 guru as well.

Regards,
Ruslan

Ruslan Bilovol (2):
  jbd2: check bh->b_data for NULL in jbd2_journal_get_descriptor_buffer
    before memset()
  ext4: add sanity checks in __ext4_check_dir_entry

 fs/ext4/dir.c     |    8 ++++++--
 fs/jbd2/journal.c |    2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

-- 
1.7.9.5

