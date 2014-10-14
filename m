Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbaJNKEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 06:04:06 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:3537 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386AbaJNKEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 06:04:05 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/4] blkdev: flush optimization
Date: Tue, 14 Oct 2014 14:03:51 +0400
Message-Id: <1413281035-6483-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some filesystems try to optimize barrier flushes by maintaining
fs-specific generation counters, but if we introduce generic
flush generation counter for block device filesystems may use
it for fdatasync(2) optimization. Optimization should works if
userspace performs mutli-threaded IO with a lot of fdatasync()

TOC:
blkdev: add flush generation counter
md: add flush_idx support for stacked devices
ext4: cleanup data integrity sync fo nonjournal mode
ext4: Add fdatasync scalability optimization
