Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab3IIPdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:33:10 -0400
Received: from mx12.netapp.com ([216.240.18.77]:27428 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab3IIPdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:33:06 -0400
X-IronPort-AV: E=Sophos;i="4.90,866,1371106800"; 
   d="scan'208";a="87989598"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux NFS mailing list <linux-nfs@vger.kernel.org>,
        Linux linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Please pull NFS client updates for 3.12
Thread-Topic: [GIT PULL] Please pull NFS client updates for 3.12
Thread-Index: AQHOrXHbqB6pgxBKckCuKZUgBzC4Kg==
Date: Mon, 9 Sep 2013 15:32:57 +0000
Message-ID: <1378740776.2635.1.camel@leira.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7CC311673629AB458462066AEABD76D8@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r89FXJ0U020782

Hi Linus,

The following changes since commit 7c6d4dca777d6423cb9ccdc019cad94c75adcbe4:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mattst88/alpha (2013-07-23 14:39:57 -0700)

are available in the git repository at:


  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.12-1

for you to fetch changes up to b1b3e136948a2bf4915326acb0d825d7d180753f:

  NFSv4: use mach cred for SECINFO_NO_NAME w/ integrity (2013-09-07 18:39:25 -0400)

----------------------------------------------------------------
NFS client updates for Linux 3.12

Highlights include:

- Fix NFSv4 recovery so that it doesn't recover lost locks in cases such as
  lease loss due to a network partition, where doing so may result in data
  corruption. Add a kernel parameter to control choice of legacy behaviour
  or not.
- Performance improvements when 2 processes are writing to the same file.
- Flush data to disk when an RPCSEC_GSS session timeout is imminent.
- Implement NFSv4.1 SP4_MACH_CRED state protection to prevent other
  NFS clients from being able to manipulate our lease and file lockingr
  state.
- Allow sharing of RPCSEC_GSS caches between different rpc clients
- Fix the broken NFSv4 security auto-negotiation between client and server
- Fix rmdir() to wait for outstanding sillyrename unlinks to complete
- Add a tracepoint framework for debugging NFSv4 state recovery issues.
- Add tracing to the generic NFS layer.
- Add tracing for the SUNRPC socket connection state.
- Clean up the rpc_pipefs mount/umount event management.
- Merge more patches from Chuck in preparation for NFSv4 migration support.

----------------------------------------------------------------
Andy Adamson (10):
      NFSv4.1 Use the mount point rpc_clnt for layoutreturn
      NFS Remove unused authflavour parameter from init_client
      NFSv4.1 Increase NFS4_DEF_SLOT_TABLE_SIZE
      NFSv4.1 Use clientid management rpc_clnt for secinfo
      NFSv4.1 Use clientid management rpc_clnt for secinfo_no_name
      SUNRPC: don't map EKEYEXPIRED to EACCES in call_refreshresult
      SUNRPC new rpc_credops to test credential expiry
      NFS avoid expired credential keys for buffered writes
      SUNRPC refactor rpcauth_checkverf error returns
      NFSv4.1 Use MDS auth flavor for data server connection

Chuck Lever (20):
      NFS: Fix return type of nfs4_end_drain_session() stub
      NFS: Use root's credential for lease management when keytab is missing
      NFS: Never use user credentials for lease renewal
      NFS: When displaying session slot numbers, use "%u" consistently
      NFS: Rename nfs41_call_sync_data as a common data structure
      NFS: Clean up nfs4_setup_sequence()
      NFS: Common versions of sequence helper functions
      NFS: Add RPC callouts to start NFSv4.0 synchronous requests
      NFS: Remove unused call_sync minor version op
      NFS: Enable slot table helpers for NFSv4.0
      NFS: Add global helper to set up a stand-along nfs4_slot_table
      NFS: Add global helper for releasing slot table resources
      NFS: Add a slot table to struct nfs_client for NFSv4.0 transport blocking
      NFS: NFSv4.0 transport blocking
      NFS: Enable nfs4_setup_sequence() for DELEGRETURN
      NFS: Add nfs4_sequence calls for RELEASE_LOCKOWNER
      NFS: Add nfs4_sequence calls for OPEN_CONFIRM
      NFS: Update session draining barriers for NFSv4.0 transport blocking
      When CONFIG_NFS_V4_1 is not enabled, "make C=2" emits this warning:
      NFS: Fix warning introduced by NFSv4.0 transport blocking patches

Jeff Layton (2):
      rpc_pipe: convert back to simple_dir_inode_operations
      nfs: verify open flags before allowing an atomic open

Nadav Shemer (1):
      nfs: fix open(O_RDONLY|O_TRUNC) in NFS4.0

NeilBrown (2):
      NFS: remove incorrect "Lock reclaim failed!" warning.
      NFSv4: Don't try to recover NFSv4 locks when they are lost.

Trond Myklebust (63):
      NFSv4: encode_attrs should not backfill the bitmap and attribute length
      NFSv4: Fix nfs4_init_uniform_client_string for net namespaces
      NFSv4: Refuse mount attempts with proto=udp
      NFS: Remove the NFSv4 "open optimisation" from nfs_permission
      NFSv3: Deal with a sparse warning in nfs3_proc_create
      NFSv4: Deal with a sparse warning in nfs4_opendata_alloc
      NFSv4: Deal with some more sparse warnings
      NFSv4: Deal with a sparse warning in nfs_idmap_get_key()
      NFSv4: Fix an incorrect pointer declaration in decode_first_pnfs_layout_type
      NFS: Clean up nfs_sillyrename()
      NFS: refactor code for calculating the crc32 hash of a filehandle
      NFS: Add event tracing for generic NFS events
      NFS: Pass in lookup flags from nfs_atomic_open to nfs_lookup
      NFS: Add event tracing for generic NFS lookups
      NFS: Add tracepoints for debugging generic file create events
      NFS: Add tracepoints for debugging directory changes
      NFS: Add tracepoints for debugging NFS rename and sillyrename issues
      NFS: Add tracepoints for debugging NFS hard links
      NFSv4: Add tracepoints for debugging state management problems
      NFSv4: Add tracepoints for debugging file open
      NFSv4: Add tracepoints for debugging file locking
      NFSv4: Add tracepoints for debugging lookup/create operations
      NFSv4: Add tracepoints for debugging inode manipulations
      NFSv4: Add tracepoints for debugging rename
      NFSv4: Add tracepoints for debugging delegations
      NFSv4: Add tracepoints for debugging the idmapper
      NFSv4: Add tracepoints for debugging getattr
      NFSv4: Add tracepoints for debugging reads and writes
      NFSv4.1: Add tracepoints for debugging layoutget/return/commit
      NFSv4.1: Add tracepoints for debugging slot table operations
      NFSv4.1: Add tracepoints for debugging test_stateid events
      NFS: Fix up two use-after-free issues with the new tracing code
      SUNRPC: Deprecate rpc_client->cl_protname
      SUNRPC: Remove unused struct rpc_clnt field cl_protname
      SUNRPC: Cleanup rpc_setup_pipedir
      RPCSEC_GSS: Clean up upcall message allocation
      SUNRPC: Replace clnt->cl_principal
      RPCSEC_GSS: Further cleanups
      RPCSEC_GSS: Fix an Oopsable condition when creating/destroying pipefs objects
      NFSv4: Fix a potentially Oopsable condition in __nfs_idmap_unregister
      SUNRPC: Add a framework to clean up management of rpc_pipefs directories
      RPCSEC_GSS: Switch auth_gss to use the new framework for pipefs dentries
      SUNRPC: Remove the obsolete auth-only interface for pipefs dentry management
      NFSv4: Convert idmapper to use the new framework for pipefs dentries
      SUNRPC: Remove the rpc_client->cl_dentry
      SUNRPC: Add a helper to allow sharing of rpc_pipefs directory objects
      RPCSEC_GSS: Share rpc_pipes when an rpc_clnt owns multiple rpcsec auth caches
      RPCSEC_GSS: Share all credential caches on a per-transport basis
      SUNRPC: rpcauth_create needs to know about rpc_clnt clone status
      NFS: Ensure that rmdir() waits for sillyrenames to complete
      SUNRPC: Add tracepoints to help debug socket connection issues
      NFSv4: Document the recover_lost_locks kernel parameter
      SUNRPC: Ensure rpc_task->tk_pid is available for tracepoints
      SUNRPC: Add an identifier for struct rpc_clnt
      SUNRPC: Replace pointer values with task->tk_pid and rpc_clnt->cl_clid
      NFS: Don't check lock owner compatibility in writes unless file is locked
      NFS: Don't check lock owner compatability unless file is locked (part 2)
      NFS: Clean up the auth flavour array mess
      NFS: Clean up nfs_parse_security_flavors()
      NFSv4: Fix security auto-negotiation
      NFSv4: Disallow security negotiation for lookups when 'sec=' is specified
      NFSv4: Allow security autonegotiation for submounts
      NFS: nfs_compare_super shouldn't check the auth flavour unless 'sec=' was set

Weston Andros Adamson (9):
      NFSv4: use the mach cred for SECINFO w/ integrity
      nfs4.1: Minimal SP4_MACH_CRED implementation
      nfs4.1: Add state protection handler
      nfs4.1: Add SP4_MACH_CRED cleanup support
      nfs4.1: Add SP4_MACH_CRED secinfo support
      nfs4.1: Add SP4_MACH_CRED stateid support
      nfs4.1: Add SP4_MACH_CRED write and commit support
      nfs4: Map NFS4ERR_WRONG_CRED to EPERM
      NFSv4: use mach cred for SECINFO_NO_NAME w/ integrity

 Documentation/kernel-parameters.txt |   12 +
 fs/nfs/Makefile                     |    9 +-
 fs/nfs/callback_proc.c              |   11 +-
 fs/nfs/client.c                     |    6 +-
 fs/nfs/delegation.c                 |    3 +
 fs/nfs/dir.c                        |   81 ++-
 fs/nfs/file.c                       |   20 +-
 fs/nfs/idmap.c                      |  195 ++----
 fs/nfs/inode.c                      |   32 +-
 fs/nfs/internal.h                   |   31 +-
 fs/nfs/nfs3proc.c                   |   10 +-
 fs/nfs/nfs4_fs.h                    |   98 ++-
 fs/nfs/nfs4client.c                 |  240 ++++++--
 fs/nfs/nfs4filelayout.c             |   39 +-
 fs/nfs/nfs4getroot.c                |    4 +-
 fs/nfs/nfs4namespace.c              |   21 +-
 fs/nfs/nfs4proc.c                   |  793 ++++++++++++++++++------
 fs/nfs/nfs4session.c                |   86 ++-
 fs/nfs/nfs4session.h                |   37 +-
 fs/nfs/nfs4state.c                  |  174 +++---
 fs/nfs/nfs4super.c                  |    2 -
 fs/nfs/nfs4trace.c                  |   17 +
 fs/nfs/nfs4trace.h                  | 1148 +++++++++++++++++++++++++++++++++++
 fs/nfs/nfs4xdr.c                    |  214 ++++---
 fs/nfs/nfstrace.c                   |    9 +
 fs/nfs/nfstrace.h                   |  729 ++++++++++++++++++++++
 fs/nfs/pagelist.c                   |   22 +-
 fs/nfs/pnfs.c                       |    3 +
 fs/nfs/proc.c                       |    6 +-
 fs/nfs/read.c                       |    7 +-
 fs/nfs/super.c                      |   99 ++-
 fs/nfs/unlink.c                     |   38 +-
 fs/nfs/write.c                      |   57 +-
 include/linux/nfs_fs.h              |    1 +
 include/linux/nfs_fs_sb.h           |   13 +
 include/linux/nfs_xdr.h             |   25 +-
 include/linux/sunrpc/auth.h         |   28 +-
 include/linux/sunrpc/clnt.h         |    6 +-
 include/linux/sunrpc/rpc_pipe_fs.h  |   39 +-
 include/linux/sunrpc/sched.h        |    2 +-
 include/trace/events/sunrpc.h       |  181 +++++-
 net/sunrpc/auth.c                   |   27 +-
 net/sunrpc/auth_generic.c           |   82 +++
 net/sunrpc/auth_gss/auth_gss.c      |  442 ++++++++++----
 net/sunrpc/auth_null.c              |    6 +-
 net/sunrpc/auth_unix.c              |    6 +-
 net/sunrpc/clnt.c                   |  157 ++---
 net/sunrpc/rpc_pipe.c               |  193 +++++-
 net/sunrpc/sched.c                  |    2 +-
 net/sunrpc/stats.c                  |    2 +-
 net/sunrpc/xprtsock.c               |   13 +-
 51 files changed, 4504 insertions(+), 974 deletions(-)
 create mode 100644 fs/nfs/nfs4trace.c
 create mode 100644 fs/nfs/nfs4trace.h
 create mode 100644 fs/nfs/nfstrace.c
 create mode 100644 fs/nfs/nfstrace.h

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
