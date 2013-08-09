Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968164Ab3HIQkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:40:31 -0400
Received: from mx1.netapp.com ([216.240.18.38]:27492 "EHLO mx1.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968090Ab3HIQk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:40:29 -0400
X-IronPort-AV: E=Sophos;i="4.89,846,1367996400"; 
   d="scan'208";a="272476659"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux linux-kernel <linux-kernel@vger.kernel.org>,
        Linux NFS mailing list <linux-nfs@vger.kernel.org>
Subject: [GIT PULL] Please pull NFS client bug fixes
Thread-Topic: [GIT PULL] Please pull NFS client bug fixes
Thread-Index: AQHOlR8nStyyDnfcqk2aYfXUb6aWRA==
Date: Fri, 9 Aug 2013 16:40:27 +0000
Message-ID: <1376066427.7093.1.camel@leira.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <1FBD0595CBB4E44A9882F77929B79755@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r79Gebdc011404

Hi Linus,

The following changes since commit c095ba7224d8edc71dcef0d655911399a8bd4a3f:

  Linux 3.11-rc4 (2013-08-04 13:46:46 -0700)

are available in the git repository at:

  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.11-4

for you to fetch changes up to b72888cb0ba63b2dfc6c8d3cd78a7fea584bebc6:

  NFSv4: Fix up nfs4_proc_lookup_mountpoint (2013-08-07 20:47:26 -0400)

----------------------------------------------------------------
NFS client bugfixes for 3.11

- Stable patch for lockd to fix Oopses due to inappropriate calls to
  utsname()->nodename
- Stable patches for sunrpc to fix Oopses on shutdown when using
  AF_LOCAL sockets with rpcbind
- Fix memory leak and error checking issues in nfs4_proc_lookup_mountpoint
- Fix a regression with the sync mount option failing to work for nfs4 mounts
- Fix a writeback performance issue when doing cache invalidation
- Remove an incorrect call to nfs_setsecurity in nfs_fhget

----------------------------------------------------------------
Scott Mayhew (1):
      NFSv4: Fix the sync mount option for nfs4 mounts

Trond Myklebust (6):
      LOCKD: Don't call utsname()->nodename from nlmclnt_setlockargs
      SUNRPC: Don't auto-disconnect from the local rpcbind socket
      SUNRPC: If the rpcbind channel is disconnected, fail the call to unregister
      NFS: Fix writeback performance issue on cache invalidation
      NFS: Remove unnecessary call to nfs_setsecurity in nfs_fhget()
      NFSv4: Fix up nfs4_proc_lookup_mountpoint

 fs/lockd/clntlock.c          | 13 ++++++++----
 fs/lockd/clntproc.c          |  5 +++--
 fs/nfs/inode.c               | 11 +++++++---
 fs/nfs/nfs4proc.c            |  8 +++-----
 fs/nfs/super.c               |  4 ++++
 include/linux/sunrpc/sched.h |  1 +
 net/sunrpc/clnt.c            |  4 ++++
 net/sunrpc/netns.h           |  1 +
 net/sunrpc/rpcb_clnt.c       | 48 ++++++++++++++++++++++++++++++++------------
 9 files changed, 68 insertions(+), 27 deletions(-)

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
