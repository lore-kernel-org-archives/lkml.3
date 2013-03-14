Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab3CNQKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 12:10:16 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:44626 "EHLO
	homiemail-a46.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933603Ab3CNQKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 12:10:13 -0400
From: Shea Levy <shea@shealevy.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Shea Levy <shea@shealevy.com>
Subject: [PATCH 0/2] vfs: Report a mount r/o if the superblock is
Date: Thu, 14 Mar 2013 12:09:18 -0400
Message-Id: <1363277360-1947-1-git-send-email-shea@shealevy.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By calling mount(2) with MS_REMOUNT | MS_BIND on a non-bind readonly
mountpoint, it is possible to have a readonly mount without MNT_READONLY
in its mnt_flags. Currently, /proc/<pid>/mountinfo and statfs will
report such a mount as r/w, even though for all intents and purposes it
is still readonly.

This patchset fixes show_mountinfo and statfs to report such mounts as
readonly.

Signed-off-by: Shea Levy <shea@shealevy.com>

