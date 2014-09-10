Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbaIJVWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:22:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582AbaIJVWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:22:07 -0400
Subject: [PATCH 0/6] KEYS: Miscellaneous fixes
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 10 Sep 2014 22:21:54 +0100
Message-ID: <20140910212154.10752.23343.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi James,

Here are some fixes to go upstream:

 (1) Fix a bug in the assoc_array garbage collector [CVE-2014-3631].

 (2) Reinstate the production of EPERM for key types beginning with '.' in
     requests from userspace.

 (3) Fix some missing 'static' annotations.

 (4) Tidy up the cleanup of PKCS#7 message signed information blocks and fix a
     bug this made more obvious.

They can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-fixes

Tagged with:

	keys-fixes-20140910

David
---
David Howells (6):
      KEYS: Fix termination condition in assoc array garbage collection
      KEYS: Reinstate EPERM for a key type name beginning with a '.'
      KEYS: Fix missing statics
      PKCS#7: Add a missing static
      PKCS#7: Provide a single place to do signed info block freeing
      PKCS#7: Fix the parser cleanup to drain parsed out X.509 certs


 crypto/asymmetric_keys/pkcs7_parser.c |   61 ++++++++++++++++++---------------
 crypto/asymmetric_keys/pkcs7_trust.c  |    6 ++-
 lib/assoc_array.c                     |    4 ++
 security/keys/keyctl.c                |    2 +
 security/keys/request_key_auth.c      |    4 +-
 5 files changed, 43 insertions(+), 34 deletions(-)

