Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbaJNI7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 04:59:22 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:59631 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbaJNI7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 04:59:08 -0400
Message-ID: <543CE5D8.1050306@converseincode.com>
Date: Tue, 14 Oct 2014 10:59:04 +0200
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: akpm@linux-foundation.org, bruce.w.allan@intel.com, d.kasatkin@samsung.com,
        james.l.morris@oracle.com, john.griffin@intel.com,
        linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net,
        linux-ima-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
        neilb@suse.de, qat-linux@intel.com, serge@hallyn.com,
        thomas.lendacky@amd.com, zohar@linux.vnet.ibm.com, agk@redhat.com,
        clm@fb.com, davem@davemloft.net, dm-devel@redhat.com, fabf@skynet.be,
        herbert@gondor.apana.org.au, jbacik@fb.com, snitzer@redhat.com,
        tadeusz.struk@intel.com
Subject: [GIT PULL] LLVMLinux patches for v3.18
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches remove the use of VLAIS using a new SHASH_DESC_ON_STACK macro.
Some of the previously accepted VLAIS removal patches haven't used this
macro. I will
push new patches to consistently use this macro in all those older cases
for 3.19

The following changes since commit 2d65a9f48fcdf7866aab6457bc707ca233e0c791:

  Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux
(2014-10-14 09:39:08 +0200)

are available in the git repository at:

  git://git.linuxfoundation.org/llvmlinux/kernel.git
tags/llvmlinux-for-v3.18

for you to fetch changes up to 4c5c30249452aaebf258751ea4222eba3dd3da4c:

  crypto: LLVMLinux: Remove VLAIS usage from crypto/testmgr.c
(2014-10-14 10:51:24 +0200)

----------------------------------------------------------------
LLVMLinux patches for v3.18

----------------------------------------------------------------
Behan Webster (6):
      crypto: LLVMLinux: Add macro to remove use of VLAIS in crypto code
      crypto: LLVMLinux: Remove VLAIS from crypto/mv_cesa.c
      crypto: LLVMLinux: Remove VLAIS from crypto/n2_core.c
      crypto: LLVMLinux: Remove VLAIS from crypto/omap_sham.c
      crypto: LLVMLinux: Remove VLAIS from crypto/.../qat_algs.c
      security, crypto: LLVMLinux: Remove VLAIS from ima_crypto.c

Jan-Simon Möller (5):
      crypto: LLVMLinux: Remove VLAIS from crypto/ccp/ccp-crypto-sha.c
      crypto, dm: LLVMLinux: Remove VLAIS usage from dm-crypt
      crypto: LLVMLinux: Remove VLAIS usage from crypto/hmac.c
      crypto: LLVMLinux: Remove VLAIS usage from libcrc32c.c
      crypto: LLVMLinux: Remove VLAIS usage from crypto/testmgr.c

Vinícius Tinti (1):
      btrfs: LLVMLinux: Remove VLAIS

 crypto/hmac.c                            | 25 ++++++++---------
 crypto/testmgr.c                         | 14 ++++------
 drivers/crypto/ccp/ccp-crypto-sha.c      | 13 ++++-----
 drivers/crypto/mv_cesa.c                 | 41 ++++++++++++----------------
 drivers/crypto/n2_core.c                 | 11 +++-----
 drivers/crypto/omap-sham.c               | 28 ++++++++-----------
 drivers/crypto/qat/qat_common/qat_algs.c | 31 ++++++++++-----------
 drivers/md/dm-crypt.c                    | 34 ++++++++++-------------
 fs/btrfs/hash.c                          | 16 +++++------
 include/crypto/hash.h                    |  5 ++++
 lib/libcrc32c.c                          | 16 +++++------
 security/integrity/ima/ima_crypto.c      | 47
+++++++++++++-------------------
 12 files changed, 122 insertions(+), 159 deletions(-)

