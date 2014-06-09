Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbaFIWId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:08:33 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:44101
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246AbaFIWIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:08:30 -0400
Date: Tue, 10 Jun 2014 00:08:28 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org, zohar@linux.vnet.ibm.com,
        akpm@linux-foundation.org, linux-security-module@vger.kernel.org
Subject: [security-next] Pull request (merge window)
Message-ID: <20140609220828.GA3044@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending unchanged, as this still applies cleanly on top of current git
HEAD)

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

This is a merge of James Morris' security-next tree from 3.14 to yesterday's
master, plus 4 patches from Paul Moore which are in linux-next, plus one patch
from Mimi.

The following changes since commit c9482a5bdcc09be9096f40e858c5fe39c389cd52:

  kernfs: move the last knowledge of sysfs out from kernfs (2014-06-03 08:11:18 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sergeh/linux-security serge-next-1

for you to fetch changes up to 2d7667f8d83ee059c2f792040bed255f716c634c:

  Merge branch 'james-next-mimi-paul' into serge-next (2014-06-03 15:48:34 -0500)

- ----------------------------------------------------------------

Casey Schaufler (4):
      Smack: Correctly remove SMACK64TRANSMUTE attribute
      Smack: bidirectional UDS connect check
      Smack: Verify read access on file open - v3
      Smack: Label cgroup files for systemd

Dave Jones (2):
      selinux: conditionally reschedule in mls_convert_context while loading selinux policy
      selinux: conditionally reschedule in hashtab_insert while loading selinux policy

David Howells (1):
      KEYS: Move the flags representing required permission to linux/key.h

Dmitry Kasatkin (1):
      smack: fix key permission verification

James Morris (3):
      Merge commit 'v3.14' into next
      Merge tag 'keys-20140314' of git://git.kernel.org/.../dhowells/linux-fs into next
      Merge branch 'smack-for-3.16' of git://git.gitorious.org/smack-next/kernel into next

Joe Perches (1):
      security: Convert use of typedef ctl_table to struct ctl_table

José Bollo (2):
      Minor improvement of 'smack_sb_kern_mount'
      SMACK: Fix handling value==NULL in post setxattr

Lukasz Pawelczyk (3):
      Smack: fix the subject/object order in smack_ptrace_traceme()
      Smack: unify all ptrace accesses in the smack
      Smack: adds smackfs/ptrace interface

Mimi Zohar (1):
      ima: audit log files opened with O_DIRECT flag

Pankaj Kumar (1):
      bugfix patch for SMACK

Paul Moore (1):
      selinux: reject setexeccon() on MNT_NOSUID applications with -EACCES

Serge Hallyn (1):
      Merge branch 'james-next-mimi-paul' into serge-next

Stephen Smalley (1):
      selinux:  Report permissive mode in avc: denied messages.

Toralf Förster (1):
      Warning in scanf string typing

 Documentation/ABI/testing/ima_policy |   2 +-
 Documentation/security/Smack.txt     |  10 ++
 include/linux/key.h                  |  11 ++
 include/linux/security.h             |   6 +-
 security/capability.c                |   2 +-
 security/integrity/ima/ima_api.c     |  10 +-
 security/integrity/ima/ima_main.c    |   5 +-
 security/integrity/ima/ima_policy.c  |   6 +-
 security/integrity/integrity.h       |   1 +
 security/keys/internal.h             |  11 +-
 security/keys/key.c                  |   6 +-
 security/keys/keyctl.c               |  44 +++----
 security/keys/keyring.c              |   8 +-
 security/keys/permission.c           |   4 +-
 security/keys/persistent.c           |   4 +-
 security/keys/proc.c                 |   2 +-
 security/keys/sysctl.c               |   2 +-
 security/security.c                  |   2 +-
 security/selinux/avc.c               |   7 +-
 security/selinux/hooks.c             |  13 +-
 security/selinux/include/avc.h       |   4 +-
 security/selinux/ss/hashtab.c        |   3 +
 security/selinux/ss/mls.c            |   2 +
 security/smack/smack.h               |  16 ++-
 security/smack/smack_access.c        |  38 ++++--
 security/smack/smack_lsm.c           | 249 ++++++++++++++++++++++++++---------
 security/smack/smackfs.c             |  76 ++++++++++-
 27 files changed, 407 insertions(+), 137 deletions(-)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJTj0gOAAoJELF1z6mPGSryVy4H/iqVDXUdDrW80Y2Eb1tdsDo/
mApSqV5seKID5QMlRKa2D7diuEbsyhheU/4nuzafm0H3adCnDJoBdjuU6a+XgRBr
m58xYpzR/BR3Wf0R7Bautoud/Vf0usMOqKok3e2fiVEK2JeEODuiINrgNsFA+N4h
FzbeA0SXpdKeT6gqxO7b1gun/FQyE/+L8D6ox8ZCZcVHjEFuaWxkDhL/z5bUkCXI
bjWYhTBPl4bL1ZrnfjV2uIaLR2yaOx2pDmclnmGgX+fNhWQi6dPdM6VRFbL4WMJf
368hpaJR1MWSF5npzu+CHT2Gb5piuCo/Jt5wJpW6GL3TFxoQayZkgpakXXohW2U=
=EiFM
-----END PGP SIGNATURE-----
