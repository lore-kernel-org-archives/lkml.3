Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbaJXOXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:23:34 -0400
Received: from imap.thunk.org ([74.207.234.97]:41303 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbaJXOXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:23:33 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] /dev/random updates for 3.18
Date: Fri, 24 Oct 2014 10:23:30 -0400
Message-ID: <nsxioj9r1gd.fsf@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random.git tags/random_for_linus

for you to fetch changes up to 7185ad2672a7d50bc384de0e38d90b75d99f3d82:

  crypto: memzero_explicit - make sure to clear out sensitive data (2014-10-17 11:44:07 -0400)

----------------------------------------------------------------
This adds a memzero_explicit() call which is guaranteed not to be
optimized away by GCC.  This is important when we are wiping
cryptographically sensitive material.

----------------------------------------------------------------
Daniel Borkmann (2):
      random: add and use memzero_explicit() for clearing data
      crypto: memzero_explicit - make sure to clear out sensitive data

 crypto/cts.c            |  3 ++-
 crypto/sha1_generic.c   |  2 +-
 crypto/sha256_generic.c |  5 ++---
 crypto/sha512_generic.c |  2 +-
 crypto/tgr192.c         |  4 ++--
 crypto/vmac.c           |  2 +-
 crypto/wp512.c          |  8 ++++----
 drivers/char/random.c   |  8 ++++----
 include/linux/string.h  |  5 +++--
 lib/string.c            | 16 ++++++++++++++++
 10 files changed, 36 insertions(+), 19 deletions(-)
