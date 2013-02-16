Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab3BPBzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 20:55:44 -0500
Received: from dkim1.fusionio.com ([66.114.96.53]:41576 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3BPBzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 20:55:42 -0500
X-ASG-Debug-ID: 1360979740-0421b51e71204a0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Fri, 15 Feb 2013 20:55:36 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs updates
Message-ID: <20130216015536.GG28851@shiny.masoncoding.com>
X-ASG-Orig-Subj: [GIT PULL] Btrfs updates
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1360979740
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.122791
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

If you're doing another RC, please grab these two.  Otherwise I'll send
them off to -stable.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This fixes a long standing problem where the btrfs scan ioctl was racing
with mkfs.btrfs and dropping dirty pages created by mkfs.  It also fixes
a crash during tree log replay with quota enabled.

David Sterba (1) commits (+64/-6):
    btrfs: access superblock via pagecache in scan_one_device

Arne Jansen (1) commits (+1/-1):
    Btrfs: fix crash in log replay with qgroups enabled

Total: (2) commits (+65/-7)

 fs/btrfs/ctree.c   |  2 +-
 fs/btrfs/volumes.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 65 insertions(+), 7 deletions(-)

