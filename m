Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbaLWXKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 18:10:09 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:61946 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaLWXKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 18:10:06 -0500
From: Paul Moore <paul@paul-moore.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Audit fixes for 3.19
Date: Tue, 23 Dec 2014 18:10:03 -0500
Message-ID: <1426990.sj1Az20XEf@sifl>
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Four patches to fix various problems with the audit subsystem, all are fairly 
small and straightforward.  One patch fixes a problem where we weren't using 
the correct gfp allocation flags (GFP_KERNEL regardless of context, oops), one 
patch fixes a problem with old userspace tools (this was broken for a while), 
one patch fixes a problem where we weren't recording pathnames correctly, and 
one fixes a problem with PID based filters.  In general I don't think there is 
anything controversial with this patchset, and it fixes some rather 
unfortunate bugs; the allocation flag one can be particularly scary looking 
for users.  Please pull for the next v3.19-rcX.

Thanks,
-Paul

---
The following changes since commit 0f7e94ee40d06f7a04e039392dfee8244bd8a7e0:

  Merge branch 'next' into upstream for v3.19 (2014-12-09 14:38:30 -0500)

are available in the git repository at:

  git://git.infradead.org/users/pcmoore/audit upstream

for you to fetch changes up to 041d7b98ffe59c59fdd639931dea7d74f9aa9a59:

  audit: restore AUDIT_LOGINUID unset ABI (2014-12-23 16:40:18 -0500)

----------------------------------------------------------------
Paul Moore (2):
      audit: don't attempt to lookup PIDs when changing PID filtering audit 
             rules
      audit: correctly record file names with different path name types

Richard Guy Briggs (2):
      audit: use supplied gfp_mask from audit_buffer in 
             kauditd_send_multicast_skb
      audit: restore AUDIT_LOGINUID unset ABI

 include/linux/audit.h |  4 ++++
 kernel/audit.c        |  8 ++++----
 kernel/auditfilter.c  | 23 ++++++++++-------------
 kernel/auditsc.c      | 14 ++++++++++----
 4 files changed, 28 insertions(+), 21 deletions(-)


