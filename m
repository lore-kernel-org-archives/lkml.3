Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbaKCLsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 06:48:52 -0500
Received: from mail-wg0-f73.google.com ([74.125.82.73]:39548 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaKCLsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 06:48:43 -0500
From: David Drysdale <drysdale@google.com>
To: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Will Drewry <wad@chromium.org>,
        Jorge Lucangeli Obes <jorgelo@google.com>,
        Ricky Zhou <rickyz@google.com>, Lee Campbell <leecam@google.com>,
        Julien Tinnes <jln@google.com>, Mike Depinet <mdepinet@google.com>,
        James Morris <james.l.morris@oracle.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, linux-api@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        David Drysdale <drysdale@google.com>
Subject: [PATCH 0/3] fs: add O_BENEATH flag to openat(2)
Date: Mon,  3 Nov 2014 11:48:22 +0000
Message-Id: <1415015305-15494-1-git-send-email-drysdale@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds a new O_BENEATH flag for openat(2) which restricts the
provided path, rejecting (with -EACCES) paths that are not beneath
the provided dfd.

This change was previously included as part of a larger patchset
(https://lkml.org/lkml/2014/7/25/426) for Capsicum support; however, it
is potentially useful as an independent change so I've pulled it out
separately here.

In particular, various folks from Chrome[OS] have indicated an interest
in having this functionality.


Changes since the version included in the Capsicum v2 patchset:
 - Add tests of normal symlinks
 - Fix man-page typo
 - Update patch to 3.17

Changes from v1 to v2 of Capsicum patchset:
 - renamed O_BENEATH_ONLY to O_BENEATH [Christoph Hellwig]


David Drysdale (2):
  fs: add O_BENEATH flag to openat(2)
  selftests: Add test of O_BENEATH & openat(2)

 arch/alpha/include/uapi/asm/fcntl.h       |   1 +
 arch/parisc/include/uapi/asm/fcntl.h      |   1 +
 arch/sparc/include/uapi/asm/fcntl.h       |   1 +
 fs/fcntl.c                                |   5 +-
 fs/namei.c                                |  43 ++++++---
 fs/open.c                                 |   4 +-
 include/linux/namei.h                     |   1 +
 include/uapi/asm-generic/fcntl.h          |   4 +
 tools/testing/selftests/Makefile          |   1 +
 tools/testing/selftests/openat/.gitignore |   3 +
 tools/testing/selftests/openat/Makefile   |  24 +++++
 tools/testing/selftests/openat/openat.c   | 149 ++++++++++++++++++++++++++++++
 12 files changed, 220 insertions(+), 17 deletions(-)
 create mode 100644 tools/testing/selftests/openat/.gitignore
 create mode 100644 tools/testing/selftests/openat/Makefile
 create mode 100644 tools/testing/selftests/openat/openat.c

-- 
2.1.0.rc2.206.gedb03e5

