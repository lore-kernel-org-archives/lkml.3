Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaDUQXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:23:00 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:37843 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaDUQW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:22:58 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>,
        David Herrmann <dh.herrmann@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [RFC 0/2] Fix permission checks on open("/proc/self/fd/N", O_RDWR)
Date: Mon, 21 Apr 2014 09:22:46 -0700
Message-Id: <cover.1398097304.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a prototype of a real fix for a longstanding issue.  See patch 2
for the full descripton.

Andy Lutomirski (2):
  fs,proc: Pass nameidata to proc_get_link implementations
  fs,proc: Respect FMODE_WRITE when opening /proc/pid/fd/N

 fs/namei.c            |  3 +++
 fs/proc/base.c        | 13 ++++++++-----
 fs/proc/fd.c          | 22 ++++++++++++++++++----
 fs/proc/internal.h    |  3 ++-
 include/linux/namei.h |  1 +
 5 files changed, 32 insertions(+), 10 deletions(-)

-- 
1.9.0

