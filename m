Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbbAGQCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:02:32 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:43059 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbbAGQCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:02:30 -0500
Message-ID: <54AD5893.9040701@plexistor.com>
Date: Wed, 07 Jan 2015 18:02:27 +0200
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jens Axboe <axboe@fb.com>, Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCHSET 0/4 v4] brd: partition fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Hi

Currently brd has multiple bugs when trying to use partitions. After this
set all known problems are solved. Please see individual patch for description
of the problem.
(Another merge window, another patchset send. I wish you would tell me to
 just *uck-off, instead of this silence. What is so big a deal about this
 simple bug fixes.)

These should go into current v3.19-rcXX merge window they are real bugs
solving Data corruption, when using partitions.

[v4]
- Rebase to 3.19-rc3
- Removed the getgeo patch it is no longer needed by new fdisk
- Minor change to patch: [4/4] brd: Request from fdisk 4k alignment
  As suggested by Martin

[v3]
Same exact code but some commit messages changed to try and explain better
what was fixed and why. (Rebased on 3.18-rc3 but nothing changed in brd.c
since then)

[v2]
Based on Jens's linux-next [30e996a] incorporating the brd patch by Dmitry Monakhov.
Dmitry has introduced a new part_show parameter, this parameter is now removed
and we always "part_show=1".
Scripts that did part_show=1 will work just the same but will display a
message in logs. This is harmless. (And scripts can be modified to
remove this parameter)

[v1]
Current situation is that any attempt to use partitions with brd device would
create the partition but then any use will trash the data.

See: http://www.spinics.net/lists/linux-scsi/msg76737.html

So these patches fixes up all the problems we saw with the code, but not sacrificing
any of the old fixtures. See [patch 3/4] for more explanations.

list of patches:
[PATCH 1/4] axonram: Fix bug in direct_access
[PATCH 2/4] block: Change direct_access calling convention

	These 2 above are from Matthew's DAX series latest version.
	Exactly as is, taken from the 01org/prd.git tree
	They are needed so to support direct_access with partitions.

[PATCH 3/4] brd: Fix all partitions BUGs

	This one fixes all the very HARD bugs, which today
	cause data corruption.

[PATCH 4/4] brd: Request from fdisk 4k alignment

One can fetch/view these patches from a public tree here:
  git: git://git.open-osd.org/pmem.git brd-partitions branch
  web: http://git.open-osd.org/gitweb.cgi?p=pmem.git;a=shortlog;h=refs/heads/brd-partitions

Thanks
Boaz

