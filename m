Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbaFPJFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:05:07 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:46101 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbaFPJFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:05:03 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Ian Kent <raven@themaw.net>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 0/2] /proc/stat vs. failed order-4 allocation
Date: Mon, 16 Jun 2014 11:04:50 +0200
Message-Id: <1402909492-36486-1-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.5.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061609-8372-0000-0000-000000363C14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches are supposed to "fix" failed order-4 memory
allocations which have been observed when reading /proc/stat.
The problem has been observed on s390 as well as on x86.

To address the problem change the seq_file memory allocations to
fallback to use vmalloc, so that allocations also work if memory
is fragmented.

This approach seems to be simpler and less intrusive than changing
/proc/stat to use an interator. Also it "fixes" other users as well,
which use seq_file's single_open() interface.

Heiko Carstens (2):
  proc/stat: convert to single_open_size()
  fs/seq_file: fallback to vmalloc allocation

 fs/proc/stat.c | 22 ++--------------------
 fs/seq_file.c  | 30 +++++++++++++++++++++---------
 2 files changed, 23 insertions(+), 29 deletions(-)

-- 
1.8.5.5

