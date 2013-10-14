Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab3JNJgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 05:36:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55094 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab3JNJgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 05:36:09 -0400
Subject: [PATCH 0/3] procfs,
 vmcore: fix regression of mmap on /proc/vmcore since v3.12-rc1
To: akpm@linux-foundation.org
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, ebiederm@xmission.com, holzheu@linux.vnet.ibm.com,
        adobriyan@gmail.com, vgoyal@redhat.com
Date: Mon, 14 Oct 2013 18:36:06 +0900
Message-ID: <20131014093606.9801.11175.stgit@localhost6.localdomain6>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set fixes regression of mmap on /proc/vmcore since
v3.12-rc1. The primary one is the 2nd patch. The 1st patch is another
bug I found during investiation and it affects mmap on /proc/vmcore
even if only 2nd patch is applied, so fix it together in this patch
set. The last patch is just for cleaning up of target function in both
1st and 2nd patches.

---

HATAYAMA Daisuke (3):
      procfs: fix unintended truncation of returned mapped address
      procfs: Call default get_unmapped_area on MMU-present architectures
      procfs: clean up proc_reg_get_unmapped_area for 80-column limit


 fs/proc/inode.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

-- 
Thanks.
HATAYAMA, Daisuke
