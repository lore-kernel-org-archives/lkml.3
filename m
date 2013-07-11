Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab3GKSSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 14:18:21 -0400
Received: from mx11.netapp.com ([216.240.18.76]:23741 "EHLO mx11.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358Ab3GKSST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 14:18:19 -0400
X-IronPort-AV: E=Sophos;i="4.89,1045,1367996400"; 
   d="scan'208";a="33208842"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux linux-kernel <linux-kernel@vger.kernel.org>,
        Linux NFS mailing list <linux-nfs@vger.kernel.org>
Subject: [GIT PULL] Please pull NFS client updates
Thread-Topic: [GIT PULL] Please pull NFS client updates
Thread-Index: AQHOfmMEpLV8lWr8DkyKFaroLEsz4g==
Date: Thu, 11 Jul 2013 18:18:17 +0000
Message-ID: <1373566697.12823.30.camel@leira.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CFFB7A0795EB634688EE34ED54E37F54@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6BIIZ9Q025592

Hi Linus,

The following pull request mainly contains some small readdir
optimisations that had dependencies on Al Viro's readdir rewrite. There
is also a fix for a nasty deadlock which surfaced earlier in this merge
window.

The following changes since commit a82a729f04232ccd0b59406574ba4cf20027a49d:

  Merge branch 'akpm' (updates from Andrew Morton) (2013-07-09 13:33:36 -0700)

are available in the git repository at:


  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.11-2

for you to fetch changes up to eeee245268c951262b861bc1be4e9dc812352499:

  SUNRPC: Fix a deadlock in rpc_client_register() (2013-07-10 15:58:55 -0400)

----------------------------------------------------------------
NFS client updates for Linux 3.11 (part 2)

Highlights include:
- Fix an_rpc pipefs regression that causes a deadlock on mount
- Readdir optimisations by Scott Mayhew and Jeff Layton
- clean up the rpc_pipefs dentry operation setup

----------------------------------------------------------------
Fengguang Wu (1):
      rpc_pipe: rpc_dir_inode_operations can be static

Jeff Layton (2):
      nfs: set verifier on existing dentries in nfs_prime_dcache
      rpc_pipe: set dentry operations at d_alloc time

Scott Mayhew (3):
      NFS: Make nfs_attribute_cache_expired() non-static
      NFS: Make nfs_readdir revalidate less often
      NFS: Allow nfs_updatepage to extend a write under additional circumstances

Trond Myklebust (1):
      SUNRPC: Fix a deadlock in rpc_client_register()

 fs/nfs/dir.c           |  6 ++++--
 fs/nfs/inode.c         |  2 +-
 fs/nfs/write.c         | 31 +++++++++++++++++++++++--------
 include/linux/nfs_fs.h |  1 +
 net/sunrpc/clnt.c      | 16 +++++++++-------
 net/sunrpc/rpc_pipe.c  | 25 ++++++++++++++++++++-----
 6 files changed, 58 insertions(+), 23 deletions(-)

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
