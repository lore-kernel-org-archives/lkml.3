Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbaCaN3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:29:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683AbaCaN2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:28:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
cc: dhowells@redhat.com, d.kasatkin@samsung.com, casey@schaufler-ca.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] KEYS: Make perm request flags available to security modules
Date: Mon, 31 Mar 2014 14:28:25 +0100
Message-ID: <8321.1396272505@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Can you pull this pair of patches please?  They move the flags that are used
to request specific permissions to a more public header file so that they can
then be used by Smack (and other security modules).

The flags for requesting permissions on keys are not the same as the flags in
the permissions mask on a key (the latter has four sets that interact).

Note that the flags have to be renamed so that they don't conflict with
input symbols (eg. keyboard key names).

David
---
The following changes since commit c60f7d5a8e7c639de5d9dfe07e1e91d302d506e4:

  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux (2014-03-13 21:32:16 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-20140314

for you to fetch changes up to fffea214abf66a8672cfd6697fae65e743e22f11:

  smack: fix key permission verification (2014-03-14 17:44:49 +0000)

----------------------------------------------------------------
(from the branch description for keys-dmitry local branch)

Keyrings stuff for/from Dmitry Kasatkin
Keyrings changes

----------------------------------------------------------------
David Howells (1):
      KEYS: Move the flags representing required permission to linux/key.h

Dmitry Kasatkin (1):
      smack: fix key permission verification

 include/linux/key.h        | 11 +++++++++++
 include/linux/security.h   |  6 +++---
 security/capability.c      |  2 +-
 security/keys/internal.h   | 11 +----------
 security/keys/key.c        |  6 +++---
 security/keys/keyctl.c     | 44 ++++++++++++++++++++++----------------------
 security/keys/keyring.c    |  8 ++++----
 security/keys/permission.c |  4 ++--
 security/keys/persistent.c |  4 ++--
 security/keys/proc.c       |  2 +-
 security/security.c        |  2 +-
 security/selinux/hooks.c   |  2 +-
 security/smack/smack_lsm.c |  9 +++++++--
 13 files changed, 59 insertions(+), 52 deletions(-)
