Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3ILO4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:56:09 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:3143 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3ILO4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:56:00 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH 0/2 v2] dcache: get/release read lock in read_seqbegin_or_lock() & friend
Date: Thu, 12 Sep 2013 10:55:33 -0400
Message-Id: <1378997735-22844-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change log
----------
v1->v2:
  - Rename the new seqlock primitives to read_seqexcl_lock* and
    read_seqexcl_unlock*.
  - Clarify in the commit log and comments about the exclusive nature
    of the read lock.

Waiman Long (2):
  seqlock: Add a new locking reader type
  dcache: get/release read lock in read_seqbegin_or_lock() & friend

 fs/dcache.c             |   31 +++++++++++----------
 include/linux/seqlock.h |   68 +++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 79 insertions(+), 20 deletions(-)

