Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaJFR0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 13:26:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbaJFR0I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 13:26:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org
cc: dhowells@redhat.com, d.kasatkin@samsung.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KEYS: 
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4791.1412616356.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Oct 2014 18:25:56 +0100
Message-ID: <4792.1412616356@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Can you pull these fixes into your next branch?

 (1) Handle error codes in pointers correctly so as not to crash.

 (2) Fix the asymmetric key description to make module signature checking work
     right (I changed the description to include the X.509 serial number, but
     the module uses the subjectKeyId still).

 (3) Bring back matching of keys based on partial matches on the auxiliary
     IDs (required for IMA).

 (4) Make the PGP fingerprint field in /proc/keys hold the tail end of the
     SKID once again (if present).

 (5) IMA needs to zero-pad the key ID it requests a match on because the hex
     string will be rejected if it's not a multiple of two digits.

David
---
The following changes since commit c867d07e3c861e75509650b8a359351d634db93a:

  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity into next (2014-10-02 19:47:23 +1000)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-next-fixes-20141006

for you to fetch changes up to 594081ee7145cc30a3977cb4e218f81213b63dc5:

  integrity: do zero padding of the key id (2014-10-06 17:33:27 +0100)

----------------------------------------------------------------
(from the branch description for keys-next-fixes local branch)

clone of "keys-fixes"
Keyrings fixes for next

----------------------------------------------------------------
David Howells (1):
      X.509: If available, use the raw subjKeyId to form the key description

Dmitry Kasatkin (6):
      KEYS: handle error code encoded in pointer
      KEYS: Restore partial ID matching functionality for asymmetric keys
      KEYS: use swapped SKID for performing partial matching
      KEYS: strip 'id:' from ca_keyid
      KEYS: output last portion of fingerprint in /proc/keys
      integrity: do zero padding of the key id

 crypto/asymmetric_keys/asymmetric_keys.h  |  3 --
 crypto/asymmetric_keys/asymmetric_type.c  | 84 +++++++++++++++++++++++--------
 crypto/asymmetric_keys/pkcs7_trust.c      |  9 ++--
 crypto/asymmetric_keys/x509_cert_parser.c | 14 +++---
 crypto/asymmetric_keys/x509_parser.h      |  8 +--
 crypto/asymmetric_keys/x509_public_key.c  | 29 ++++++++---
 include/crypto/public_key.h               |  3 +-
 include/keys/asymmetric-type.h            |  3 ++
 security/integrity/digsig_asymmetric.c    |  2 +-
 9 files changed, 110 insertions(+), 45 deletions(-)
