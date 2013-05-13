Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab3EMOQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:16:51 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:2343 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446Ab3EMOQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:16:50 -0400
From: Oskar Andero <oskar.andero@sonymobile.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Radovan Lekanovic <radovan.lekanovic@sonymobile.com>,
        David Rientjes <rientjes@google.com>,
        Oskar Andero <oskar.andero@sonymobile.com>
Subject: [RFC PATCH 0/2] return value from shrinkers
Date: Mon, 13 May 2013 16:16:33 +0200
Message-ID: <1368454595-5121-1-git-send-email-oskar.andero@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In a previous discussion on lkml it was noted that the shrinkers use the
magic value "-1" to signal that something went wrong.

This patch-set implements the suggestion of instead using errno.h values
to return something more meaningful.

The first patch simply changes the check from -1 to any negative value and
updates the comment accordingly.

The second patch updates the shrinkers to return an errno.h value instead
of -1. Since this one spans over many different areas I need input on what is
a meaningful return value. Right now I used -EBUSY on everything for consitency.

What do you say? Is this a good idea or does it make no sense at all?

Thanks!

-Oskar

Oskar Andero (2):
  mm: vmscan: let any negative return value from shrinker mean error
  Clean-up shrinker return values

 drivers/staging/android/ashmem.c     | 2 +-
 drivers/staging/zcache/zcache-main.c | 2 +-
 fs/gfs2/glock.c                      | 2 +-
 fs/gfs2/quota.c                      | 2 +-
 fs/nfs/dir.c                         | 2 +-
 fs/ubifs/shrinker.c                  | 2 +-
 include/linux/shrinker.h             | 5 +++--
 mm/vmscan.c                          | 2 +-
 net/sunrpc/auth.c                    | 2 +-
 9 files changed, 11 insertions(+), 10 deletions(-)

-- 
1.8.1.5

