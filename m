Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab3FESu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 14:50:58 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:37834 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab3FESu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 14:50:57 -0400
Subject: [PATCH v4 0/8] Nvram-to-pstore
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Thu, 06 Jun 2013 00:20:39 +0530
Message-ID: <20130605184756.25794.43872.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060518-1396-0000-0000-000003123F75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the kernel provides the contents of p-series NVRAM only as a
simple stream of bytes via /dev/nvram, which must be interpreted in user
space by the nvram command in the powerpc-utils package. This patch set
exploits the pstore subsystem to expose each partition in NVRAM as a
separate file in /dev/pstore. For instance, Oops messages will be stored
in a file named [dmesg-nvram-2].

Changes from v3:
	- Change filename prefix for of-config and common partition

Changes from v2:
	- Fix renaming of pstore type ids in nvram.c

Changes from v1:
	- Reduce #ifdefs by and remove forward declarations of pstore callbacks
	- Handle return value of nvram_write_os_partition
	- Remove empty pstore callbacks and register pstore only when pstore
	  is configured
---

Aruna Balakrishnaiah (8):
      powerpc/pseries: Remove syslog prefix in uncompressed oops text
      powerpc/pseries: Add version and timestamp to oops header
      powerpc/pseries: Introduce generic read function to read nvram-partitions
      powerpc/pseries: Read/Write oops nvram partition via pstore
      powerpc/pseries: Read rtas partition via pstore
      powerpc/pseries: Distinguish between a os-partition and non-os partition
      powerpc/pseries: Read of-config partition via pstore
      powerpc/pseries: Read common partition via pstore


 arch/powerpc/platforms/pseries/nvram.c |  353 +++++++++++++++++++++++++++-----
 fs/pstore/inode.c                      |    9 +
 include/linux/pstore.h                 |    4 
 3 files changed, 313 insertions(+), 53 deletions(-)

-- 

