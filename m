Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbaGVVHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 17:07:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbaGVVH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 17:07:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: James Morris <jmorris@namei.org>
cc: dhowells@redhat.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        mimi.e.zohar@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>,
        vgoyal@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Keyrings and asymmetric keys patches for 3.17
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25693.1406063229.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Tue, 22 Jul 2014 22:07:09 +0100
Message-ID: <25694.1406063229@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a number of sets of patches for you to pull.  I've git-merged them
together into a single branch (keys-next) as there are some conflicts and
tagged the end.

The keys-preparse-1 branch has been updated with various Acked-bys and
Reviewed-bys plus one documentation change and retagged:

	git diff keys-next-20140717 keys-next-20140722 | diffstat
	keys.txt |    2 +-
	1 file changed, 1 insertion(+), 1 deletion(-)

The component subsets are:

 (1) Tag keys-preparse-1-20140722

     A set of patches that mostly convert extant key types to perform
     preparsing to make it possible to determine the amount of quota in
     advance.

     I haven't fixed the encrypted and trusted keys as yet as they incorrectly
     use the ->update() op, but I'd like to get the changes I have done out
     the door.

 (2) Tag keys-pkcs7-20140708

     A set of patches that can parse binary PKCS#7 messages and verify the
     X.509 certificates and signatures contained therein and look to see if
     there's an intersection between those certificates/signatures and a ring
     of trusted keys.

     This has a conflict with (1) that is solved in the merge: A debugging key
     type is added for testing the PKCS#7 parser and this uses the user
     keyring type.

 (3) Tag keys-pefile-20140709

     A set of patches that take a signed PE binary, extract the PKCS#7
     message, validate the signature of the signed parts of the PE binary and
     verify the PKCS#7 certificate using (2) above.

     Subsets (2) and (3) will then be used to do signed kexec.

 (4) Branch linux-integrity/next-with-key

     Mimi and Dmitry's keyrings patches.

     Note that this branch is on top of their next-without-key branch.  If you
     pull that first as Mimi has asked, git should connect this correctly.

     This is commit 7d2ce2320e8efdc4a6dcbae7b329ed3f0d1cd778.

 (5) Branch keys-fixes

     Three fixes:

     (a) Allow CAP_SYS_ADMIN capable processes to invalidate keys that are
     	 appropriately marked.

	 This has a conflict with (4) since both add new key flags.

     (b) Don't select MPILIB_EXTRA as it doesn't exist.

     (c) Select CRYPTO if SIGNATURE is enabled rather than depending on it to
     	 get module vs built-in correct.

There's some duplicate code between the patches in (2) and (4) for looking up
a key containing a public key.  The code exists in different places and
doesn't interfere with each other, so I'll deal with it later when one or both
of these sets has gone in.

David
---
The following changes since commit 32c2e6752ff0f48fe03b9e1c7c64bde580a840d2:

  ima: provide double buffering for hash calculation (2014-07-17 09:35:11 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-next-20140722

for you to fetch changes up to 633706a2ee81637be37b6bc02c5336950cc163b5:

  Merge branch 'keys-fixes' into keys-next (2014-07-22 21:55:45 +0100)

----------------------------------------------------------------

(from the branch description for keys-next local branch)

Keyrings for linux-next
Keyrings patches

----------------------------------------------------------------
David Howells (34):
      X.509: Add bits needed for PKCS#7
      X.509: Export certificate parse and free functions
      PKCS#7: Implement a parser [RFC 2315]
      PKCS#7: Digest the data in a signed-data message
      PKCS#7: Find the right key in the PKCS#7 key list and verify the signature
      PKCS#7: Verify internal certificate chain
      PKCS#7: Find intersection between PKCS#7 message and known, trusted keys
      PKCS#7: Provide a key type for testing PKCS#7
      KEYS: X.509: Fix a spelling mistake
      Provide PE binary definitions
      pefile: Parse a PE binary to find a key and a signature contained therein
      pefile: Strip the wrapper off of the cert data block
      pefile: Parse the presumed PKCS#7 content of the certificate blob
      pefile: Parse the "Microsoft individual code signing" data blob
      pefile: Digest the PE binary and compare to the PKCS#7 data
      pefile: Validate PKCS#7 trust chain
      KEYS: Allow special keys (eg. DNS results) to be invalidated by CAP_SYS_ADMIN
      KEYS: Provide a generic instantiation function
      KEYS: struct key_preparsed_payload should have two payload pointers
      KEYS: Allow expiry time to be set when preparsing a key
      KEYS: Call ->free_preparse() even after ->preparse() returns an error
      KEYS: user: Use key preparsing
      KEYS: Ceph: Use key preparsing
      KEYS: Ceph: Use user_match()
      KEYS: DNS: Use key preparsing
      KEYS: RxRPC: Use key preparsing
      KEYS: big_key: Use key preparsing
      KEYS: keyring: Provide key preparsing
      KEYS: request_key_auth: Provide key preparsing
      Merge tag 'keys-preparse-1-20140722' into keys-next
      Merge tag 'keys-pkcs7-20140708' into keys-next
      Merge tag 'keys-pefile-20140709' into keys-next
      Merge remote-tracking branch 'integrity/next-with-keys' into keys-next
      Merge branch 'keys-fixes' into keys-next

Dmitry Kasatkin (4):
      KEYS: make partial key id matching as a dedicated function
      KEYS: validate certificate trust only with selected key
      KEYS: validate certificate trust only with builtin keys
      digsig: make crypto builtin if digsig selected as builtin

Jean Delvare (1):
      RSA: Don't select non-existent symbol

Mimi Zohar (3):
      KEYS: special dot prefixed keyring name bug fix
      KEYS: verify a certificate is signed by a 'trusted' key
      ima: define '.ima' as a builtin 'trusted' keyring

Vivek Goyal (1):
      pefile: Handle pesign using the wrong OID

 Documentation/kernel-parameters.txt       |   5 +
 Documentation/security/keys.txt           |  14 +-
 crypto/asymmetric_keys/Kconfig            |  34 ++-
 crypto/asymmetric_keys/Makefile           |  37 +++
 crypto/asymmetric_keys/asymmetric_keys.h  |   2 +
 crypto/asymmetric_keys/asymmetric_type.c  |  78 +++--
 crypto/asymmetric_keys/mscode.asn1        |  28 ++
 crypto/asymmetric_keys/mscode_parser.c    | 126 ++++++++
 crypto/asymmetric_keys/pkcs7.asn1         | 127 +++++++++
 crypto/asymmetric_keys/pkcs7_key_type.c   |  99 +++++++
 crypto/asymmetric_keys/pkcs7_parser.c     | 396 ++++++++++++++++++++++++++
 crypto/asymmetric_keys/pkcs7_parser.h     |  61 ++++
 crypto/asymmetric_keys/pkcs7_trust.c      | 219 ++++++++++++++
 crypto/asymmetric_keys/pkcs7_verify.c     | 323 +++++++++++++++++++++
 crypto/asymmetric_keys/verify_pefile.c    | 457 ++++++++++++++++++++++++++++++
 crypto/asymmetric_keys/verify_pefile.h    |  42 +++
 crypto/asymmetric_keys/x509.asn1          |   2 +-
 crypto/asymmetric_keys/x509_cert_parser.c |  20 ++
 crypto/asymmetric_keys/x509_parser.h      |  13 +-
 crypto/asymmetric_keys/x509_public_key.c  | 111 +++++++-
 fs/nfs/idmap.c                            |  10 +-
 include/crypto/pkcs7.h                    |  36 +++
 include/keys/big_key-type.h               |   3 +-
 include/keys/system_keyring.h             |  10 +-
 include/keys/user-type.h                  |   3 +-
 include/linux/key-type.h                  |   5 +-
 include/linux/key.h                       |   2 +
 include/linux/oid_registry.h              |   8 +-
 include/linux/pe.h                        | 448 +++++++++++++++++++++++++++++
 include/linux/verify_pefile.h             |  18 ++
 kernel/system_keyring.c                   |   1 +
 lib/Kconfig                               |   3 +-
 net/ceph/crypto.c                         |  26 +-
 net/dns_resolver/dns_key.c                |  43 +--
 net/dns_resolver/dns_query.c              |   1 +
 net/rxrpc/ar-key.c                        | 165 ++++++-----
 security/integrity/digsig.c               |  28 ++
 security/integrity/ima/Kconfig            |  10 +
 security/integrity/ima/ima.h              |  12 +
 security/integrity/ima/ima_main.c         |  10 +-
 security/integrity/integrity.h            |   5 +
 security/keys/big_key.c                   |  41 +--
 security/keys/encrypted-keys/encrypted.c  |   2 +-
 security/keys/key.c                       |  49 +++-
 security/keys/keyctl.c                    |  21 +-
 security/keys/keyring.c                   |  34 ++-
 security/keys/request_key_auth.c          |  13 +
 security/keys/user_defined.c              |  41 +--
 48 files changed, 3025 insertions(+), 217 deletions(-)
 create mode 100644 crypto/asymmetric_keys/mscode.asn1
 create mode 100644 crypto/asymmetric_keys/mscode_parser.c
 create mode 100644 crypto/asymmetric_keys/pkcs7.asn1
 create mode 100644 crypto/asymmetric_keys/pkcs7_key_type.c
 create mode 100644 crypto/asymmetric_keys/pkcs7_parser.c
 create mode 100644 crypto/asymmetric_keys/pkcs7_parser.h
 create mode 100644 crypto/asymmetric_keys/pkcs7_trust.c
 create mode 100644 crypto/asymmetric_keys/pkcs7_verify.c
 create mode 100644 crypto/asymmetric_keys/verify_pefile.c
 create mode 100644 crypto/asymmetric_keys/verify_pefile.h
 create mode 100644 include/crypto/pkcs7.h
 create mode 100644 include/linux/pe.h
 create mode 100644 include/linux/verify_pefile.h
