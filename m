Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbaEVMFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:05:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817AbaEVMFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:05:10 -0400
Message-ID: <1400760284.3145.15.camel@holly>
Subject: [PATCH] Documentation: incorrect formula to calculate CommitLimit
 value
From: Petr Oros <poros@redhat.com>
Reply-To: poros@redhat.com
To: rdunlap@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        trivial@kernel.org
Date: Thu, 22 May 2014 14:04:44 +0200
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The formula to calculate "CommitLimit" value mentioned in kernel documentation is incorrect.
Right formula is: CommitLimit = ([total RAM pages] - [total huge TLB pages]) * overcommit_ratio / 100 + [total swap pages]

Signed-off-by: Petr Oros <poros@redhat.com>
---
 Documentation/filesystems/proc.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 8b9cd8e..b58d764 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -854,7 +854,8 @@ WritebackTmp: Memory used by FUSE for temporary writeback buffers
               if strict overcommit accounting is enabled (mode 2 in
               'vm.overcommit_memory').
               The CommitLimit is calculated with the following formula:
-              CommitLimit = ('vm.overcommit_ratio' * Physical RAM) + Swap
+              CommitLimit = ([total RAM pages] - [total huge TLB pages]) *
+                             overcommit_ratio / 100 + [total swap pages]
               For example, on a system with 1G of physical RAM and 7G
               of swap with a `vm.overcommit_ratio` of 30 it would
               yield a CommitLimit of 7.3G.
-- 
1.9.0


