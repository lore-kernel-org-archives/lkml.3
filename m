Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab3JYOmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 10:42:49 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:57033 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab3JYOms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 10:42:48 -0400
From: Matias Bjorling <m@bjorling.me>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Matias Bjorling <m@bjorling.me>
Subject: [PATCH 0/2] Allow drivers to tap into tags initialization
Date: Fri, 25 Oct 2013 16:42:35 +0200
Message-Id: <1382712157-28564-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches enable a driver to control if tags should be initialized or
use an existing tags structure.

This is for example needed for the NVMe driver, that have a shared number of
queues for each block device it expose.

Matias Bjorling (2):
  blk-mq: allow request queues to share tags map
  blk-mq: add maps_tags fn and add usage

 block/blk-mq-tag.c     | 22 +++++++++++++++++++++-
 block/blk-mq.c         | 11 +++++++----
 include/linux/blk-mq.h | 12 ++++++++++++
 3 files changed, 40 insertions(+), 5 deletions(-)

-- 
1.8.3.2

