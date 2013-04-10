Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934274Ab3DJHVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 03:21:05 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:51142 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab3DJHVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 03:21:02 -0400
Subject: [PATCH 0/8] Nvram-to-pstore
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, mahesh@linux.vnet.ibm.com, anton@samba.org,
        ananth@in.ibm.com
Date: Wed, 10 Apr 2013 12:50:47 +0530
Message-ID: <20130410071835.20150.56489.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041007-1396-0000-0000-000002C76AF5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the kernel provides the contents of p-series NVRAM only as a
simple stream of bytes via /dev/nvram, which must be interpreted in user
space by the nvram command in the powerpc-utils package.  This patch set
exploits the pstore subsystem to expose each partition in NVRAM as a
separate file in /dev/pstore. For instance Oops messages will stored in a
file named [dmesg-nvram-2].

---

Aruna Balakrishnaiah (8):
      Remove syslog prefix in uncompressed oops text
      Add version and timestamp to oops header
      Introduce generic read function to read nvram-partitions
      Read/Write oops nvram partition via pstore
      Read rtas partition via pstore
      Distinguish between a os-partition and non-os partition
      Read of-config partition via pstore
      Read common partition via pstore


 arch/powerpc/platforms/pseries/nvram.c |  329 ++++++++++++++++++++++++++++----
 fs/pstore/inode.c                      |    9 +
 include/linux/pstore.h                 |    4 
 3 files changed, 304 insertions(+), 38 deletions(-)

-- 

