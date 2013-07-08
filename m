Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab3GHSAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 14:00:09 -0400
Received: from [216.240.18.76] ([216.240.18.76]:62397 "EHLO mx11.netapp.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab3GHSAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 14:00:07 -0400
X-IronPort-AV: E=Sophos;i="4.87,1021,1363158000"; 
   d="scan'208";a="32460248"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux NFS mailing list <linux-nfs@vger.kernel.org>,
        Linux linux-kernel <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>
Subject: [GIT PULL] Please pull NFS client updates
Thread-Topic: [GIT PULL] Please pull NFS client updates
Thread-Index: AQHOfATm8LMCuoio9EeZMu2GWsYesg==
Date: Mon, 8 Jul 2013 17:59:33 +0000
Message-ID: <1373306369.2231.16.camel@leira.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C5C42E115AD4B14195002AC14622E13A@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r68I0Hxk006284

Hi Linus,

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.11-1

for you to fetch changes up to 959d921f5eb8878ea16049a7f6e9bcbb6dfbcb88:

  Merge branch 'labeled-nfs' into linux-next (2013-06-28 16:29:51 -0400)

----------------------------------------------------------------

NFS client updates for Linux 3.11

Feature highlights include:
- Add basic client support for NFSv4.2
- Add basic client support for Labeled NFS (selinux for NFSv4.2)
- Fix the use of credentials in NFSv4.1 stateful operations, and
  add support for NFSv4.1 state protection.

Bugfix highlights:
- Fix another NFSv4 open state recovery race
- Fix an NFSv4.1 back channel session regression
- Various rpc_pipefs races
- Fix another issue with NFSv3 auth negotiation


Please note that Labeled NFS does require some additional support from
the security subsystem. The relevant changesets have all been reviewed
and acked by James Morris.

----------------------------------------------------------------
Andy Adamson (6):
      NFSv4.1 Fix a pNFS session draining deadlock
      NFSv4.1 end back channel session draining
      NFSv4.1 Fix gdia_maxcount calculation to fit in ca_maxresponsesize
      NFSv4.1 use pnfs_device maxcount for the blocklayout gdia_maxcount
      NFSv4.1 use pnfs_device maxcount for the objectlayout gdia_maxcount
      NFSv4.1 Refactor nfs4_init_session and nfs4_init_channel_attrs

Bryan Schumaker (4):
      NFS: Make callbacks minor version generic
      NFS: Add in v4.2 callback operation
      NFS: Apply v4.1 capabilities to v4.2
      NFS: Improve legacy idmapping fallback

Chuck Lever (3):
      NFS: Fix SETCLIENTID fallback if GSS is not available
      NFS: Fix security flavor negotiation with legacy binary mounts
      NFS: Set NFS_CS_MIGRATION for NFSv4 mounts

David Quigley (10):
      Security: Add hook to calculate context based on a negative dentry.
      Security: Add Hook to test if the particular xattr is part of a MAC model.
      LSM: Add flags field to security_sb_set_mnt_opts for in kernel mount data.
      SELinux: Add new labeling type native labels
      NFSv4: Add label recommended attribute and NFSv4 flags
      NFSv4: Extend fattr bitmaps to support all 3 words
      NFS:Add labels to client function prototypes
      NFS: Add label lifecycle management
      NFS: Client implementation of Labeled-NFS
      NFS: Extend NFS xattr handlers to accept the security namespace

Djalal Harouni (1):
      NFSv4: SETCLIENTID add the format string for the NETID

Jeff Layton (5):
      rpc_pipefs: only set rpc_dentry_ops if d_op isn't already set
      nfs: refactor "need_mount" code out of nfs_try_mount
      nfs: move server_authlist into nfs_try_mount_request
      nfs: have nfs_mount fake up a auth_flavs list when the server didn't provide it
      nfs: have NFSv3 try server-specified auth flavors in turn

Stanislav Kinsbursky (4):
      SUNRPC: fix races on PipeFS MOUNT notifications
      SUNRPC: fix races on PipeFS UMOUNT notifications
      SUNRPC: split client creation routine into setup and registration
      SUNRPC: PipeFS MOUNT notification optimization for dying clients

Steve Dickson (4):
      NFS: Add NFSv4.2 protocol constants
      NFSv4.2: Added NFS v4.2 support to the NFS client
      NFSv4: Introduce new label structure
      Kconfig: Add Kconfig entry for Labeled NFS V4 client

Trond Myklebust (26):
      SUNRPC: Fix a bug in gss_create_upcall
      SUNRPC: Faster detection if gssd is actually running
      SUNRPC: Convert auth_gss pipe detection to work in namespaces
      SUNRPC: Prevent an rpc_task wakeup race
      NFSv4: Fix a thinko in nfs4_try_open_cached
      NFSv4.1: Ensure that layoutget is called using the layout credential
      NFSv4.1: Ensure that layoutreturn uses the correct credential
      NFSv4.1: Ensure that reclaim_complete uses the right credential
      NFSv4.1: Ensure that test_stateid and free_stateid use correct credentials
      NFSv4.1: Use layout credentials for get_deviceinfo calls
      NFSv4.1: Enable state protection
      NFSv4.1: Simplify setting the layout header credential
      SUNRPC: Fix a potential race in rpc_execute
      SUNRPC: Remove unused function rpc_queue_empty
      SUNRPC: Remove the unused helpers task_for_each() and task_for_first()
      SUNRPC: Remove unused functions rpc_task_set/has_priority
      SUNRPC: Remove redundant call to rpc_set_running() in __rpc_execute()
      NFSv4: Remove redundant check for FMODE_EXEC in nfs_finish_open
      NFSv4: Cleanup: pass the nfs_open_context to nfs4_do_open
      NFSv4: Refactor _nfs4_open_and_get_state to set ctx->state
      NFSv4: Move dentry instantiation into the NFSv4-specific atomic open code
      NFSv4: Close another NFSv4 recovery race
      NFSv4: Move the DNS resolver into the NFSv4 module
      NFSv4.1: layout segment comparison helpers should take 'const' parameters
      NFSv4.1: Clean up layout segment comparison helper names
      Merge branch 'labeled-nfs' into linux-next

 fs/nfs/Kconfig                      |  14 +
 fs/nfs/Makefile                     |   6 +-
 fs/nfs/blocklayout/blocklayout.c    |   3 +-
 fs/nfs/callback.c                   |   1 +
 fs/nfs/callback.h                   |   3 +
 fs/nfs/callback_proc.c              |   5 +-
 fs/nfs/callback_xdr.c               |  54 ++-
 fs/nfs/client.c                     |   4 +-
 fs/nfs/dir.c                        |  75 ++--
 fs/nfs/dns_resolve.c                |  32 +-
 fs/nfs/getroot.c                    |   2 +-
 fs/nfs/idmap.c                      |  56 ++-
 fs/nfs/inode.c                      | 136 +++++--
 fs/nfs/internal.h                   |   3 +-
 fs/nfs/mount_clnt.c                 |  14 +-
 fs/nfs/namespace.c                  |   2 +-
 fs/nfs/nfs3proc.c                   |   7 +-
 fs/nfs/nfs4_fs.h                    |   8 +-
 fs/nfs/nfs4client.c                 |  17 +-
 fs/nfs/nfs4file.c                   |   1 -
 fs/nfs/nfs4filelayout.c             |   3 +-
 fs/nfs/nfs4filelayout.h             |   3 +-
 fs/nfs/nfs4filelayoutdev.c          |   8 +-
 fs/nfs/nfs4proc.c                   | 691 ++++++++++++++++++++++++++++++------
 fs/nfs/nfs4session.c                |  44 +--
 fs/nfs/nfs4session.h                |  20 +-
 fs/nfs/nfs4state.c                  |  51 +--
 fs/nfs/nfs4super.c                  |  14 +-
 fs/nfs/nfs4xdr.c                    | 182 ++++++++--
 fs/nfs/objlayout/objlayout.c        |   4 +-
 fs/nfs/pnfs.c                       |  42 +--
 fs/nfs/pnfs.h                       |   6 +-
 fs/nfs/proc.c                       |  13 +-
 fs/nfs/super.c                      | 201 ++++++-----
 fs/nfsd/nfsd.h                      |   6 +
 include/linux/nfs4.h                |  22 ++
 include/linux/nfs_fs.h              |  27 +-
 include/linux/nfs_fs_sb.h           |   8 +-
 include/linux/nfs_xdr.h             |  20 +-
 include/linux/security.h            |  57 ++-
 include/linux/sunrpc/sched.h        |  20 --
 net/sunrpc/auth_gss/auth_gss.c      |  62 ++--
 net/sunrpc/clnt.c                   |  71 ++--
 net/sunrpc/netns.h                  |   4 +
 net/sunrpc/rpc_pipe.c               |  13 +-
 net/sunrpc/sched.c                  |  27 +-
 security/capability.c               |  19 +-
 security/security.c                 |  24 +-
 security/selinux/hooks.c            |  92 ++++-
 security/selinux/include/security.h |   2 +
 security/selinux/ss/policydb.c      |   5 +-
 security/smack/smack_lsm.c          |  11 +
 52 files changed, 1631 insertions(+), 584 deletions(-)

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
