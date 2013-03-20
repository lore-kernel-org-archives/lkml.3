Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911Ab3CTNJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:09:16 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:48758 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757102Ab3CTNJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:09:14 -0400
From: tal.tchwella@gmail.com
To: linux-kernel@vger.kernel.org
Cc: tchwella@mit.edu
Subject: [PATCH 0/3] Patches to enable chroot for all users
Date: Wed, 20 Mar 2013 06:09:04 -0700
Message-Id: <1363784947-24060-1-git-send-email-tal.tchwella@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tal Tchwella <tchwella@mit.edu>

I want to suggest adding chroot capability to all users.
The following patches enable that capability, while considering the security mechanism needed to disable escape routes for chroots by non-root users,
and keeping chroot backward-compatible for root users.
The first patch establishes the concept of multi-user chroot, while disabling checks for root user in the chroot process.
The second patch checks whether a fd that is sent to a chroot application by a non-root user refers to a directory. 
If that is the case, that fd is skipped, to disable an escape route. 
The third patch disables the option for applications that have open fds to directories to be chrooted by a non-root user.

These patches were applied and test on linux-kernel 3.2.0-31-generic.

Any comments, feedback and suggestions are appreciated!

Thanks,
Tal


Tal Tchwella (3):
  enabled chroot for all users
  socket checks for uds fds transfer
  open fds check when starting chroot

 fs/exec.c             |    3 +++
 fs/open.c             |   32 ++++++++++++++++++++++++++++++--
 include/linux/sched.h |   12 ++++++++++++
 init/main.c           |    1 +
 kernel/fork.c         |    2 ++
 net/core/scm.c        |    9 +++++++++
 6 files changed, 57 insertions(+), 2 deletions(-)

-- 
1.7.9.5

