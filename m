Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbbASUH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:07:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbbASUH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 15:07:57 -0500
Subject: [PATCH 0/5] Overhaul the audit filename handling
From: Paul Moore <pmoore@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-audit@redhat.com
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2015 15:07:54 -0500
Message-ID: <20150119200408.29706.24386.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the same patchset that was sent earlier with the RFC prefix,
the only differences are the inclusion of a reviewer and the fact that
I've stripped the RFC prefix.  I'm including this in the audit-next
branch and plan on pushing this to Linus in the next merge window.

For those of you who didn't bother looking at the RFC posting, this
patchset resolves various problems in the way audit handles filenames.
The patches rework the way audit handles filenames, removing a lot of
nasty hacks added recently, and fixing a few bugs that still remain.
Most significant to folks outside of audit, patch 5/5 does away with
the nasty getname()/putname() kludge in favor of a less ugly reference
count approach.

---

Paul Moore (5):
      fs: rework getname_kernel to handle up to PATH_MAX sized filenames
      fs: create proper filename objects using getname_kernel()
      audit: enable filename recording via getname_kernel()
      audit: fix filename matching in __audit_inode() and __audit_inode_child()
      audit: replace getname()/putname() hacks with reference counters


 fs/exec.c             |   11 +++
 fs/namei.c            |   98 ++++++++++++++++++-----------
 fs/open.c             |   11 +++
 include/linux/audit.h |    3 -
 include/linux/fs.h    |    9 +--
 kernel/audit.h        |   17 +----
 kernel/auditsc.c      |  167 +++++++++----------------------------------------
 7 files changed, 115 insertions(+), 201 deletions(-)
