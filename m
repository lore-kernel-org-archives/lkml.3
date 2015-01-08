Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbbAHQu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:50:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151AbbAHQuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:50:25 -0500
Subject: [RFC PATCH 0/5] Overhaul the audit filename handling
From: Paul Moore <pmoore@redhat.com>
To: linux-audit@redhat.com, viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 08 Jan 2015 11:50:23 -0500
Message-ID: <20150108164514.11316.85331.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There have been some patches added to v3.19-rcX to fix various
problems in the way audit handles filenames but they have been hacks
on top of hacks, not really something we want long term.  This
patchset reworks the way audit handles filenames, removing a lot of
nasty hacks added recently, and fixing a few bugs that still remain.

Most significant to folks outside of audit, patch 5/5 does away with
the nasty getname()/putname() kludge in favor of a less ugly reference
count approach.

Comments and feedback are welcome.  If nothing ugly pops up on review
I'll see if Linus is interested in taking this for the next v3.19-rcX
release, otherwise I'll toss it into linux-next for v3.20.

-Paul

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
