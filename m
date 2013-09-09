Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3IIQTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:19:05 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:8217 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3IIQTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:19:02 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: [PATCH v4 0/1] dcache: Translating dentry into pathname without taking rename_lock
Date: Mon,  9 Sep 2013 12:18:12 -0400
Message-Id: <1378743493-33546-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change History

v3->v4:
 - Extract the begin and end blocks of the rename_lock sequence number
   check into helper functions to make the code easier to read.

v2->v3:
 - Simplify prepend_name() to blindly copy the dname over until it
   reaches a null byte or the specified length leaving the sequence
   check to handle error case.

v1->v2:
 - Check for internal vs external dname, taking d_lock only for
   external dname for safety.
 - Replace memchr() by a byte-by-byte checking for loop.
 - Try lockless dentry to pathname conversion 3 times before falling
   back to taking the rename_lock to prevent live-lock.
 - Make code re-factoring suggested by George Spelvin.

Waiman Long (1):
  dcache: Translating dentry into pathname without taking rename_lock

 fs/dcache.c |  196 ++++++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 133 insertions(+), 63 deletions(-)

