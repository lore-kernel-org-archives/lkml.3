Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbaIWKYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:24:13 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58319 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbaIWKYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:24:09 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Andreas Rohner <andreas.rohner@gmx.net>
Subject: [PATCH 0/1] nilfs2: improve the performance of fdatasync()
Date: Tue, 23 Sep 2014 19:18:49 +0900
Message-Id: <1411467530-5949-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.9.4
X-Dispatcher: imput version 20110525(IM151)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Please add the following patch to the queue for the next merge window.

It fixes a longstanding issue of fdatasync() implementation of NILFS2
where fdatasync() will fall back to a full sync most of the time.  The
fallback is only necessary for a change of the file size and not for a
change of the various timestamps.  Andreas Rohner fixed this issue by
discerning these situations properly.

Thanks,
Ryusuke Konishi
--
Andreas Rohner (1):
      nilfs2: improve the performance of fdatasync()

 fs/nilfs2/inode.c   |   13 +++++++------
 fs/nilfs2/nilfs.h   |   14 +++++++++++---
 fs/nilfs2/segment.c |    4 ++--
 3 files changed, 20 insertions(+), 11 deletions(-)

