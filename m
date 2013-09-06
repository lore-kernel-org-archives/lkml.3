Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724Ab3IFQJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 12:09:32 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:43937 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3IFQJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 12:09:31 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: [PATCH v3 0/1] dcache: Translating dentry into pathname without taking rename_lock
Date: Fri,  6 Sep 2013 12:08:57 -0400
Message-Id: <1378483738-10129-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change History

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

 fs/dcache.c |  178 ++++++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 116 insertions(+), 62 deletions(-)

