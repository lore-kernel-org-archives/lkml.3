Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab3ILUbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:31:10 -0400
Received: from mx11.netapp.com ([216.240.18.76]:28785 "EHLO mx11.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755956Ab3ILUbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:31:06 -0400
X-IronPort-AV: E=Sophos;i="4.90,892,1371106800"; 
   d="scan'208";a="49293906"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux NFS mailing list <linux-nfs@vger.kernel.org>,
        Linux linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Please pull NFS client changes (part 2)
Thread-Topic: [GIT PULL] Please pull NFS client changes (part 2)
Thread-Index: AQHOr/cBPj6sy++ZHEKSuRAOnn9d0g==
Date: Thu, 12 Sep 2013 20:31:05 +0000
Message-ID: <1379017863.2627.5.camel@leira.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <70C865C4D9F3BA4684792FC51FC0A372@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8CKVGkJ016330

Hi Linus,

The following changes since commit b1b3e136948a2bf4915326acb0d825d7d180753f:

  NFSv4: use mach cred for SECINFO_NO_NAME w/ integrity (2013-09-07 18:39:25 -0400)

are available in the git repository at:

  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.12-2

for you to fetch changes up to 23c323af0375a7f63732bed0386aba5935b8de69:

  SUNRPC: No, I did not intend to create a 256KiB hashtable (2013-09-12 10:16:31 -0400)

----------------------------------------------------------------
NFS client bugfixes:

- Fix a few credential reference leaks resulting from the SP4_MACH_CRED
  NFSv4.1 state protection code.
- Fix the SUNRPC bloatometer footprint: convert a 256K hashtable into the
  intended 64 byte structure.
- Fix a long standing XDR issue with FREE_STATEID
- Fix a potential WARN_ON spamming issue
- Fix a missing dprintk() kuid conversion

New features:
- Enable the NFSv4.1 state protection support for the WRITE and COMMIT
  operations.

----------------------------------------------------------------
Andy Adamson (1):
      NFSv4.1 fix decode_free_stateid

Geert Uytterhoeven (1):
      sunrpc: Add missing kuids conversion for printing

Trond Myklebust (1):
      SUNRPC: No, I did not intend to create a 256KiB hashtable

Weston Andros Adamson (4):
      NFSv4.1: sp4_mach_cred: ask for WRITE and COMMIT
      NFSv4.1: fix SECINFO* use of put_rpccred
      NFSv4.1: sp4_mach_cred: no need to ref count creds
      NFSv4.1: sp4_mach_cred: WARN_ON -> WARN_ON_ONCE

 fs/nfs/nfs4_fs.h               | 10 +++++-----
 fs/nfs/nfs4proc.c              | 22 ++++++++++++++--------
 fs/nfs/nfs4xdr.c               | 17 ++---------------
 net/sunrpc/auth_generic.c      |  2 +-
 net/sunrpc/auth_gss/auth_gss.c |  2 +-
 5 files changed, 23 insertions(+), 30 deletions(-)

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
