Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbaLaUd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 15:33:29 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:51843 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaLaUd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 15:33:28 -0500
From: Paul Moore <paul@paul-moore.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Audit fixes for 3.19 #2
Date: Wed, 31 Dec 2014 15:33:25 -0500
Message-ID: <3159430.4MhUX0bhoZ@sifl>
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

One audit patch to resolve a panic/oops when recording filenames in the audit 
log, see the mail archive link below.  The fix isn't as nice as I would like, 
as it involves an allocate/copy of the filename, but it solves the problem and 
the overhead should only affect users who have configured audit rules 
involving file names.  We'll revisit this issue with future kernels in an 
attempt to make this suck less, but in the meantime I think this fix should go 
into the next release of v3.19-rcX.

 * https://marc.info/?t=141986927600001&r=1&w=2

Thanks,
-Paul

---
The following changes since commit 041d7b98ffe59c59fdd639931dea7d74f9aa9a59:

  audit: restore AUDIT_LOGINUID unset ABI (2014-12-23 16:40:18 -0500)

are available in the git repository at:

  git://git.infradead.org/users/pcmoore/audit upstream

for you to fetch changes up to fcf22d8267ad2601fe9b6c549d1be96401c23e0b:

  audit: create private file name copies when auditing inodes (2014-12-30 
         09:26:21 -0500)

----------------------------------------------------------------
Paul Moore (1):
      audit: create private file name copies when auditing inodes

 kernel/auditsc.c | 49 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 40 insertions(+), 9 deletions(-)

