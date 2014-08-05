Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbaHEOiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:38:55 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:48712 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaHEOix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:38:53 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/3] implement readpages() for block device to optimize sequential read
Date: Tue,  5 Aug 2014 23:38:31 +0900
Message-Id: <1407249514-20465-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements readpages() operation for block device by
using mpage_readpages() which can create multipage BIOs instead of
BIOs for each page and reduce system CPU time consumption.

Akinobu Mita (3):
  vfs: make guard_bh_eod() more generic
  vfs: guard end of device for mpage interface
  block_dev: implement readpages() to optimize sequential read

 fs/block_dev.c |  7 +++++++
 fs/buffer.c    | 26 ++++++++++++--------------
 fs/internal.h  |  5 +++++
 fs/mpage.c     |  2 ++
 4 files changed, 26 insertions(+), 14 deletions(-)

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
-- 
1.9.1

