Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbaLBHzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:55:25 -0500
Received: from tundra.namei.org ([65.99.196.166]:51372 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbaLBHzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:55:25 -0500
Date: Tue, 2 Dec 2014 18:55:15 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Keyrings / NFS fixes
Message-ID: <alpine.LRH.2.11.1412021853310.22195@namei.org>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From David Howells, please pull for 3.18.

The first one fixes the handling of maximum buffer size for key 
descriptions, fixing the size at 4095 + NUL char rather than whatever 
PAGE_SIZE happens to be and permits you to read back the full description 
without it getting clipped because some extra information got prepended.

The second and third fix a bug in NFS idmapper handling whereby a key
representing a mapping between an id and a name expires and causing
EKEYEXPIRED to be seen internally in NFS (which prevents the mapping from
happening) rather than re-looking up the mapping.

The following changes since commit 3a18ca061311f2f1ee9c44012f89c7436d392117:

  Merge tag 'ext4_for_linus_urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2014-12-01 20:11:49 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

David Howells (3):
      KEYS: Fix the size of the key description passed to/from userspace
      KEYS: Simplify KEYRING_SEARCH_{NO,DO}_STATE_CHECK flags
      KEYS: request_key() should reget expired keys rather than give EKEYEXPIRED

James Morris (1):
      Merge tag 'keys-fixes-20141201' of git://git.kernel.org/.../dhowells/linux-fs into for-linus

 security/keys/internal.h         |    1 +
 security/keys/keyctl.c           |   56 +++++++++++++++++--------------------
 security/keys/keyring.c          |   10 ++++---
 security/keys/request_key.c      |    2 +
 security/keys/request_key_auth.c |    1 +
 5 files changed, 36 insertions(+), 34 deletions(-)
