Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaKYBH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 20:07:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbaKYBH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 20:07:27 -0500
Subject: [RFC PATCH 0/4] Namespace contrained helper execution
From: Ian Kent <ikent@redhat.com>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Oleg Nesterov <onestero@redhat.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Tue, 25 Nov 2014 09:07:13 +0800
Message-ID: <20141125005255.4974.54193.stgit@pluto.fritz.box>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Some time ago an attempt was made to update call_usermodehelper()
to execute within it's namespace.

Comments at the time were basically that the approach didn't go
nearly far enough to constrain the process.

This series attempts to remedy that by taking care to create an
appropriate namespace environment then switch to it and setup
fs_struct for path walking prior to the user mode helper thread
runner calling do_execve().

Please review and comment on the patch series.
Ian

---

Benjamin Coddington (1):
      KEYS: exec request-key within the requesting task's namespace

Ian Kent (3):
      vfs - fs/namespaces.c: break out mntns_setfs() from mntns_install()
      nsproxy - make create_new_namespaces() non-static
      kmod - add call_usermodehelper_ns() helper


 fs/namespace.c              |   41 ++++++++++++++++++++++++++++-----------
 include/linux/kmod.h        |   17 ++++++++++++++++
 include/linux/mount.h       |    1 +
 include/linux/nsproxy.h     |    3 +++
 kernel/kmod.c               |   39 +++++++++++++++++++++++++++++++++++++
 kernel/nsproxy.c            |    2 +-
 security/keys/request_key.c |   45 +++++++++++++++++++++++++++++++++++++------
 7 files changed, 129 insertions(+), 19 deletions(-)

--
Signature
