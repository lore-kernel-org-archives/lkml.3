Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbbAGQYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:24:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbbAGQYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:24:11 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org
cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [GIT PULL] Keyrings fixes, including one CVE fix
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <31157.1420647836.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Wed, 07 Jan 2015 16:23:56 +0000
Message-ID: <31158.1420647836@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Could you pass these on to Linus please?  There are two fixes:

 (1) Fix for the order in which things are done during key garbage
     collection to prevent named keyrings causing a crash [CVE-2014-9529].

 (2) Fix assoc_array to explicitly #include rcupdate.h to prevent compilation
     errors under certain circumstances.

David
---
The following changes since commit 693a30b8f19a964087a3762d09fb2e1cbad6b0d4:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml (2015-01-04 11:46:43 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-fixes-20150107

for you to fetch changes up to 990428b8ead311c68a850ead7ec8557a10b8893a:

  assoc_array: Include rcupdate.h for call_rcu() definition (2015-01-07 16:08:41 +0000)

----------------------------------------------------------------
(from the branch description for keys-fixes local branch)

Keyrings fixes
Keyrings fixes

----------------------------------------------------------------
Pranith Kumar (1):
      assoc_array: Include rcupdate.h for call_rcu() definition

Sasha Levin (1):
      KEYS: close race between key lookup and freeing

 lib/assoc_array.c  | 1 +
 security/keys/gc.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)
