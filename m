Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbaI3Ae5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:34:57 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39184 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083AbaI3Aey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:34:54 -0400
From: Richard Yao <ryao@gentoo.org>
To: viro@zeniv.linux.org.uk
Cc: kernel@gentoo.org, mthode@mthode.org, michael@fds-team.de,
        drobbins@funtoo.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Yao <ryao@gentoo.org>
Subject: [PATCH v4 0/1] vfs: Respect MS_RDONLY at bind mount creation
Date: Mon, 29 Sep 2014 20:34:40 -0400
Message-Id: <1412037281-25960-1-git-send-email-ryao@gentoo.org>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This revision implements a suggestion from Mateusz Guzik to do
`mnt->mnt.mnt_flags |= MNT_READONLY`. As he pointed out, there are no writers
against which to synchronize, so we can adjust the flag directly. This becomes
obvious when we see that set_mnt_shared() sets the MNT_SHARED flag directly.

Richard Yao (1):
  vfs: Respect MS_RDONLY at bind mount creation

 fs/namespace.c | 20 ++++++++++++++++----
 fs/pnode.h     | 17 +++++++++--------
 2 files changed, 25 insertions(+), 12 deletions(-)

-- 
1.8.5.5

