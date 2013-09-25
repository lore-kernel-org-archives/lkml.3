Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3IYVVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:21:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133Ab3IYVVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:21:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org
cc: dhowells@redhat.com, simo@redhat.com, zohar@linux.vnet.ibm.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Keyrings patches
Date: Wed, 25 Sep 2013 22:21:32 +0100
Message-ID: <2825.1380144092@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi James,

Could you pull these patches into the security tree?  They're based on your
next branch.

The patches can be viewed as a number of sets:

 (1) KEYS: Skip key state checks when checking for possession

     This is a fix for determining the possessed status of keys that have been
     invalidated or revoked or that have expired.  If nothing else, can you
     please pick this and pass it upstream.

 (2) KEYS: Expand the capacity of a keyring
     Add a generic associative array implementation
     KEYS: Drop the permissions argument from __keyring_search_one()
     KEYS: Define a __key_get() wrapper to use rather than atomic_inc()
     KEYS: Search for auth-key by name rather than target key ID
     KEYS: Introduce a search context structure
     KEYS: Consolidate the concept of an 'index key' for key access
     KEYS: key_is_dead() should take a const key pointer argument
     KEYS: Use bool in make_key_ref() and is_key_possessed()

     Patches to to expand the capacity of a keyring by using an associative
     array rather than a flat list and patches to do some preparatory cleanups
     for those.

 (3) KEYS: Add per-user_namespace registers for persistent per-UID kerberos caches
     KEYS: Implement a big key type that can save to tmpfs

     Patches to add better support for libkrb5 to save its tokens in a kernel
     keyring rather than in files.  It already has this ability to some
     extent, but that has two problems: your tokens get deleted when you log
     out (so your cron jobs can't use them) and the capacity of a user type
     key is not sufficient for some of the huge Kerberos tickets one can get.
     These patches address that.

 (4) KEYS: Rename public key parameter name arrays
     KEYS: Move the algorithm pointer array from x509 to public_key.c
     KEYS: Store public key algo ID in public_key struct
     KEYS: Split public_key_verify_signature() and make available
     KEYS: Store public key algo ID in public_key_signature struct
     X.509: struct x509_certificate needs struct tm declaring
     X.509: Embed public_key_signature struct and create filler function
     X.509: Check the algorithm IDs obtained from parsing an X.509 certificate
     X.509: Handle certificates that lack an authorityKeyIdentifier field
     X.509: Remove certificate date checks

     Patches to improve the asymmetric key type in various ways, including an
     important bugfix to prevent an unset system clock from preventing modules
     from being loaded.

 (5) KEYS: Load *.x509 files into kernel keyring
     KEYS: Have make canonicalise the paths of the X.509 certs better to deduplicate
     KEYS: Separate the kernel signature checking keyring from module signing
     KEYS: Add a 'trusted' flag and a 'trusted only' flag
     KEYS: Set the asymmetric-key type default search method
     KEYS: Make the system 'trusted' keyring viewable by userspace
     KEYS: verify a certificate is signed by a 'trusted' key
     KEYS: initialize root uid and session keyrings early

     Patches to provide better support for loading a generic system keyring of
     crypto keys which may then be used for other things besides module
     signing (such as kexec).

There are additional patches from others also.

David
---
The following changes since commit 5a5f2acfd04269e2e0958067216b68ff461c285c:

  selinux: add Paul Moore as a SELinux maintainer (2013-09-24 11:50:46 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git keys-devel

for you to fetch changes up to eb8948a03704f3dbbfc7e83090e20e93c6c476d2:

  X.509: remove possible code fragility: enumeration values not handled (2013-09-25 17:17:01 +0100)

----------------------------------------------------------------
(from the branch description for keys-devel local branch)

clone of "master"
----------------------------------------------------------------
Antonio Alecrim Jr (1):
      X.509: remove possible code fragility: enumeration values not handled

David Howells (27):
      KEYS: Skip key state checks when checking for possession
      KEYS: Use bool in make_key_ref() and is_key_possessed()
      KEYS: key_is_dead() should take a const key pointer argument
      KEYS: Consolidate the concept of an 'index key' for key access
      KEYS: Introduce a search context structure
      KEYS: Search for auth-key by name rather than target key ID
      KEYS: Define a __key_get() wrapper to use rather than atomic_inc()
      KEYS: Drop the permissions argument from __keyring_search_one()
      Add a generic associative array implementation.
      KEYS: Expand the capacity of a keyring
      KEYS: Implement a big key type that can save to tmpfs
      KEYS: Add per-user_namespace registers for persistent per-UID kerberos caches
      KEYS: Rename public key parameter name arrays
      KEYS: Move the algorithm pointer array from x509 to public_key.c
      KEYS: Store public key algo ID in public_key struct
      KEYS: Split public_key_verify_signature() and make available
      KEYS: Store public key algo ID in public_key_signature struct
      X.509: struct x509_certificate needs struct tm declaring
      X.509: Embed public_key_signature struct and create filler function
      X.509: Check the algorithm IDs obtained from parsing an X.509 certificate
      X.509: Handle certificates that lack an authorityKeyIdentifier field
      X.509: Remove certificate date checks
      KEYS: Load *.x509 files into kernel keyring
      KEYS: Have make canonicalise the paths of the X.509 certs better to deduplicate
      KEYS: Separate the kernel signature checking keyring from module signing
      KEYS: Add a 'trusted' flag and a 'trusted only' flag
      KEYS: Set the asymmetric-key type default search method

Konstantin Khlebnikov (2):
      MPILIB: add module description and license
      X.509: add module description and license

Mimi Zohar (3):
      KEYS: Make the system 'trusted' keyring viewable by userspace
      KEYS: verify a certificate is signed by a 'trusted' key
      KEYS: initialize root uid and session keyrings early

 Documentation/assoc_array.txt             |  574 ++++++++++
 Documentation/security/keys.txt           |   20 +-
 crypto/asymmetric_keys/Kconfig            |    2 +-
 crypto/asymmetric_keys/asymmetric_type.c  |    1 +
 crypto/asymmetric_keys/public_key.c       |   60 +-
 crypto/asymmetric_keys/public_key.h       |    6 +
 crypto/asymmetric_keys/x509_cert_parser.c |   35 +-
 crypto/asymmetric_keys/x509_parser.h      |   18 +-
 crypto/asymmetric_keys/x509_public_key.c  |  232 ++--
 include/crypto/public_key.h               |    9 +-
 include/keys/big_key-type.h               |   25 +
 include/keys/keyring-type.h               |   17 +-
 include/keys/system_keyring.h             |   23 +
 include/linux/assoc_array.h               |   92 ++
 include/linux/assoc_array_priv.h          |  182 +++
 include/linux/key-type.h                  |    6 +
 include/linux/key.h                       |   52 +-
 include/linux/user_namespace.h            |    6 +
 include/uapi/linux/keyctl.h               |    1 +
 init/Kconfig                              |   13 +
 kernel/Makefile                           |   50 +-
 kernel/modsign_certificate.S              |   12 -
 kernel/modsign_pubkey.c                   |  104 --
 kernel/module-internal.h                  |    2 -
 kernel/module_signing.c                   |    7 +-
 kernel/system_certificates.S              |   12 +
 kernel/system_keyring.c                   |  105 ++
 kernel/user.c                             |    4 +
 kernel/user_namespace.c                   |    6 +
 lib/Kconfig                               |   14 +
 lib/Makefile                              |    1 +
 lib/assoc_array.c                         | 1746 +++++++++++++++++++++++++++++
 lib/mpi/mpiutil.c                         |    3 +
 scripts/asn1_compiler.c                   |    2 +
 security/keys/Kconfig                     |   29 +
 security/keys/Makefile                    |    2 +
 security/keys/big_key.c                   |  204 ++++
 security/keys/compat.c                    |    3 +
 security/keys/gc.c                        |   33 +-
 security/keys/internal.h                  |   74 +-
 security/keys/key.c                       |   99 +-
 security/keys/keyctl.c                    |    3 +
 security/keys/keyring.c                   | 1485 ++++++++++++------------
 security/keys/persistent.c                |  169 +++
 security/keys/proc.c                      |   17 +-
 security/keys/process_keys.c              |  141 +--
 security/keys/request_key.c               |   56 +-
 security/keys/request_key_auth.c          |   31 +-
 security/keys/sysctl.c                    |   11 +
 security/keys/user_defined.c              |   18 +-
 50 files changed, 4593 insertions(+), 1224 deletions(-)
 create mode 100644 Documentation/assoc_array.txt
 create mode 100644 include/keys/big_key-type.h
 create mode 100644 include/keys/system_keyring.h
 create mode 100644 include/linux/assoc_array.h
 create mode 100644 include/linux/assoc_array_priv.h
 delete mode 100644 kernel/modsign_certificate.S
 delete mode 100644 kernel/modsign_pubkey.c
 create mode 100644 kernel/system_certificates.S
 create mode 100644 kernel/system_keyring.c
 create mode 100644 lib/assoc_array.c
 create mode 100644 security/keys/big_key.c
 create mode 100644 security/keys/persistent.c
