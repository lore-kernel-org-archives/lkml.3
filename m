Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbbAVFAC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 00:00:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbbAVE75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 23:59:57 -0500
Subject: [PATCH v2 0/5] Overhaul the audit filename handling
From: Paul Moore <pmoore@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-audit@redhat.com
Cc: rgb@redhat.com, sd@queasysnail.net, linux-kernel@vger.kernel.org,
        linux@roeck-us.net, viro@zeniv.linux.org.uk
Date: Wed, 21 Jan 2015 23:59:49 -0500
Message-ID: <20150122045303.1347.98054.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset has some important changes from the previous revision,
namely a fix from Al Viro (included in 2/5) that resolves a boot panic
on some systems as well as some smaller, less noteworthy fixes found
in the linux-next announcement thread from January 20th (refcount bump
in __audit_reusename() and a inode type in __audit_inode()).

This patchset still needs some additional testing to verify that the
audit code still functions properly (the minor fixes mentioned above)
and there is an additional patch from Al that should be included as
well, but I wanted to post this and push the series to the audit next
branch quickly since a number of folks were affected by the boot panic.

---

Paul Moore (5):
      fs: rework getname_kernel to handle up to PATH_MAX sized filenames
      fs: create proper filename objects using getname_kernel()
      audit: enable filename recording via getname_kernel()
      audit: fix filename matching in __audit_inode() and __audit_inode_child()
      audit: replace getname()/putname() hacks with reference counters


 fs/exec.c             |   11 +++
 fs/namei.c            |  144 ++++++++++++++++++++++++++++-------------
 fs/open.c             |   11 +++
 include/linux/audit.h |    3 -
 include/linux/fs.h    |    9 +--
 kernel/audit.h        |   17 +----
 kernel/auditsc.c      |  171 ++++++++++---------------------------------------
 7 files changed, 155 insertions(+), 211 deletions(-)
