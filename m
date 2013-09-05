Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab3IES4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 14:56:07 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:37522 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab3IES4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 14:56:06 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: [PATCH v2 0/1] dcache: Translating dentry into pathname without taking rename_lock
Date: Thu,  5 Sep 2013 14:55:15 -0400
Message-Id: <1378407316-59852-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change History

v1->v2:
 - Check for internal vs external dname, taking d_lock only for
   external dname for safety.
 - Replace memchr() by a byte-by-byte checking for loop.
 - Try lockless dentry to pathname conversion 3 times before falling
   back to taking the rename_lock to prevent live-lock.
 - Make code re-factoring suggested by George Spelvin.

Waiman Long (1):
  dcache: Translating dentry into pathname without taking rename_lock

 fs/dcache.c |  213 ++++++++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 151 insertions(+), 62 deletions(-)

