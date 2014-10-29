Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaJ2Dzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 23:55:40 -0400
Received: from tundra.namei.org ([65.99.196.166]:50467 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbaJ2Dzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 23:55:39 -0400
Date: Wed, 29 Oct 2014 14:55:34 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        security@kernel.org
Subject: [GIT PULL] Fix for Integrity subsystem null pointer deref
Message-ID: <alpine.LRH.2.11.1410291450290.28213@namei.org>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes fix a bug in xattr handling, where the evm and ima 
inode_setxattr() functions do not check for empty xattrs being passed from 
userspace (leading to user-triggerable null pointer dereferences).

Please pull.


The following changes since commit 9f76628da20f96a179ca62b504886f99ecc29223:

  Merge branch 'for-3.18' of git://linux-nfs.org/~bfields/linux (2014-10-28 13:32:06 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Dmitry Kasatkin (2):
      ima: check xattr value length and type in the ima_inode_setxattr()
      evm: check xattr value length and type in evm_inode_setxattr()

James Morris (1):
      Merge branch 'for-linus' of git://git.kernel.org/.../zohar/linux-integrity into for-linus

 security/integrity/evm/evm_main.c     |    9 ++++++---
 security/integrity/ima/ima_appraise.c |    2 ++
 security/integrity/integrity.h        |    1 +
 3 files changed, 9 insertions(+), 3 deletions(-)
