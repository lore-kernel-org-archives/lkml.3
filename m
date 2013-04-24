Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab3DXGUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 02:20:13 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:49639 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab3DXGUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 02:20:10 -0400
Subject: [PATCH v2 0/8] powerpc/pseries: Nvram-to-pstore
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Wed, 24 Apr 2013 11:49:58 +0530
Message-ID: <20130424061807.7341.909.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042406-2000-0000-0000-00000BD92E85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the kernel provides the contents of p-series NVRAM only as a
simple stream of bytes via /dev/nvram, which must be interpreted in user
space by the nvram command in the powerpc-utils package. This patch set
exploits the pstore subsystem to expose each partition in NVRAM as a
separate file in /dev/pstore. For instance Oops messages will stored in a
file named [dmesg-nvram-2].

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

