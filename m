Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaBNOPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 09:15:24 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:21624 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbaBNOPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 09:15:23 -0500
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: criu@openvz.org, Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Emelyanov <xemul@parallels.com>,
        Aditya Kali <adityakali@google.com>
Subject: [PATCH RFC 0/3] c/r: add ability to restore mm attributes in a non-root userns
Date: Fri, 14 Feb 2014 18:13:26 +0400
Message-Id: <1392387209-330-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently PR_SET_MM_* require the global CAP_SYS_RESOURCE,
which is absent in a non-root userns.

Here are three groups of attributes:
1. PR_SET_MM_START_*_DATA, PR_SET_MM_*BRK, PR_SET_MM_*_STACK
These attributes can affect resource limits, so here is no sense
to restrict them if a proper limit is unlimited.
2. PR_MM_SET_EXE_FILE. We have not found other way than add
a secure bit. This bit is set from a root userns and inhereted by
children. Thanks to Pavel Emelyanov for the idea.
3. All other attributes don't affect other tasks or limits, so
can be changed without special permissions.

Andrey Vagin (3):
  prctl: reduce permissions to change boundaries of data, brk and stack
  capabilities: add a secure bit to allow changing a task exe link
  prctl: allow to use PR_MM_SET_* which affect only a current task

 include/uapi/linux/securebits.h |  9 ++++++++-
 kernel/sys.c                    | 21 +++++++++++++++++++--
 kernel/user_namespace.c         |  3 ++-
 security/commoncap.c            |  7 +++++++
 4 files changed, 36 insertions(+), 4 deletions(-)

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Aditya Kali <adityakali@google.com>

-- 
1.8.5.3

