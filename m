Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab3CHGP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:15:58 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:65199 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3CHGP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:15:57 -0500
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: lucas.de.marchi@gmail.com
Cc: David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] kmod/usermodehelper changes
Date: Fri,  8 Mar 2013 03:15:06 -0300
Message-Id: <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v1:
  - Remove call_usermodehelper_fns() converting all calling sites to either
    call_usermodelper() or call_usermodehelper_setup() + call_usermodehelper_exec()
  - Don't check the return code in call_usermodehelper_freeinfo() - now that
    allocating the subprocess_info is separating from executing it, it's safe to
    allways call the cleanup.

Lucas De Marchi (7):
  kernel/sys.c: Use the simpler call_usermodehelper()
  usermodehelper: Export _exec() and _setup() functions
  kmod: split call to call_usermodehelper_fns()
  KEYS: split call to call_usermodehelper_fns()
  coredump: remove trailling whitespaces
  Split remaining calls to call_usermodehelper_fns()
  kmod: remove call_usermodehelper_fns()

 fs/coredump.c               |  21 +++++++---
 include/linux/kmod.h        |  17 ++++----
 init/do_mounts_initrd.c     |  11 ++++-
 kernel/kmod.c               | 100 +++++++++++++++++++++++---------------------
 kernel/sys.c                |   3 +-
 security/keys/request_key.c |  14 +++++--
 6 files changed, 96 insertions(+), 70 deletions(-)

-- 
1.8.1.5

