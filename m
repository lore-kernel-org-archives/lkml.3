Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbaHEPbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:31:35 -0400
Received: from tundra.namei.org ([65.99.196.166]:34215 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140AbaHEPbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:31:33 -0400
Date: Wed, 6 Aug 2014 01:31:28 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Security subsystem updates for 3.17
Message-ID: <alpine.LRH.2.11.1408060104200.789@namei.org>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this release:

- PKCS#7 parser for the key management subsystem from David Howells
- Appoint Kees Cook as seccomp maintainer
- Bugfixes and general maintenance across the subsystem


Please pull.

---

The following changes since commit 8e099d1e8be3f598dcefd04d3cd5eb3673d4e098:

  Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2014-08-04 20:46:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next

Andy Shevchenko (1):
      tpm: simplify code by using %*phN specifier

Dave Jones (2):
      selinux: conditionally reschedule in mls_convert_context while loading selinux policy
      selinux: conditionally reschedule in hashtab_insert while loading selinux policy

David Howells (39):
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
      PKCS#7: Missing inclusion of linux/err.h
      X.509: x509_request_asymmetric_keys() doesn't need string length arguments
      PKCS#7: Use x509_request_asymmetric_key()
      PKCS#7: X.509 certificate issuer and subject are mandatory fields in the ASN.1
      X.509: Need to export x509_request_asymmetric_key()

Dmitry Kasatkin (9):
      ima: remove unnecessary i_mutex locking from ima_rdwr_violation_check()
      ima: delay template descriptor lookup until use
      ima: use ahash API for file hash calculation
      ima: introduce multi-page collect buffers
      ima: provide double buffering for hash calculation
      KEYS: make partial key id matching as a dedicated function
      KEYS: validate certificate trust only with selected key
      KEYS: validate certificate trust only with builtin keys
      digsig: make crypto builtin if digsig selected as builtin

Eric Paris (1):
      CAPABILITIES: remove undefined caps from all processes

Gideon Israel Dsouza (1):
      security: Used macros from compiler.h instead of __attribute__((...))

Himangi Saraogi (1):
      SELinux: use ARRAY_SIZE

James Morris (12):
      Merge branch 'next' of git://git.infradead.org/users/pcmoore/selinux into next
      Merge commit 'v3.15' into next
      Sync with the changes pushed by Serge in the last merge window.
      Merge branch 'stable-3.16' of git://git.infradead.org/users/pcmoore/selinux into next
      Merge branch 'next' of git://git.infradead.org/users/pcmoore/selinux into next
      Merge tag 'seccomp-3.17' of git://git.kernel.org/.../kees/linux into next
      Merge tag 'keys-next-20140722' of git://git.kernel.org/.../dhowells/linux-fs into next
      Merge tag 'keys-next-20140725' of git://git.kernel.org/.../dhowells/linux-fs into next
      Merge tag 'fw-restrict-3.17' of git://git.kernel.org/.../kees/linux into next
      Merge branch 'stable-3.16' of git://git.infradead.org/users/pcmoore/selinux into next
      Merge branch 'next' of git://git.infradead.org/users/pcmoore/selinux into next
      Merge tag 'keys-next-20140805' of git://git.kernel.org/.../dhowells/linux-fs into next

Jarkko Sakkinen (1):
      tpm: missing tpm_chip_put in tpm_get_random()

Jason Gunthorpe (2):
      tpm: Add missing tpm_do_selftest to ST33 I2C driver
      tpm: Provide a generic means to override the chip returned timeouts

Jean Delvare (1):
      RSA: Don't select non-existent symbol

Kees Cook (14):
      MAINTAINERS: create seccomp entry
      seccomp: create internal mode-setting function
      seccomp: extract check/assign mode helpers
      seccomp: split mode setting routines
      seccomp: add "seccomp" syscall
      ARM: add seccomp syscall
      MIPS: add seccomp syscall
      sched: move no_new_privs into new atomic flags
      seccomp: split filter prep from check and apply
      seccomp: introduce writer locking
      seccomp: allow mode setting across threads
      seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
      security: introduce kernel_fw_from_file hook
      firmware_class: perform new LSM checks

Masahiro Yamada (1):
      selinux, kbuild: remove unnecessary $(hostprogs-y) from clean-files

Mimi Zohar (5):
      KEYS: special dot prefixed keyring name bug fix
      KEYS: verify a certificate is signed by a 'trusted' key
      ima: define '.ima' as a builtin 'trusted' keyring
      ima: add support for measuring and appraising firmware
      KEYS: revert encrypted key change

Namhyung Kim (3):
      selinux: introduce str_read() helper
      selinux: simple cleanup for cond_read_node()
      selinux: fix a possible memory leak in cond_read_node()

Paul Moore (14):
      Merge tag 'v3.13' into next
      selinux: fix the output of ./scripts/get_maintainer.pl for SELinux
      selinux: put the mmap() DAC controls before the MAC controls
      selinux: correctly label /proc inodes in use before the policy is loaded
      Merge tag 'v3.14' into next
      selinux: reject setexeccon() on MNT_NOSUID applications with -EACCES
      Merge tag 'v3.15' into next
      selinux: reduce the number of calls to synchronize_net() when flushing caches
      selinux: fix the default socket labeling in sock_graft()
      Revert "selinux: fix the default socket labeling in sock_graft()"
      netlabel: fix a problem when setting bits below the previously lowest bit
      netlabel: fix the horribly broken catmap functions
      netlabel: fix the catmap walking functions
      netlabel: shorter names for the NetLabel catmap funcs/structs

Richard Guy Briggs (1):
      audit: fix dangling keywords in integrity ima message output

Stefan Berger (1):
      tpm: Properly clean sysfs entries in error path

Stephen Smalley (1):
      selinux:  Report permissive mode in avc: denied messages.

Tetsuo Handa (1):
      commoncap: don't alloc the credential unless needed in cap_task_prctl

Vivek Goyal (1):
      pefile: Handle pesign using the wrong OID

Waiman Long (1):
      selinux: no recursive read_lock of policy_rwlock in security_genfs_sid()

Wei Yongjun (1):
      PKCS#7: fix sparse non static symbol warning

 Documentation/ABI/testing/ima_policy      |    4 +-
 Documentation/kernel-parameters.txt       |   22 ++
 Documentation/security/keys.txt           |   14 +-
 MAINTAINERS                               |   10 +
 arch/Kconfig                              |    1 +
 arch/arm/include/uapi/asm/unistd.h        |    1 +
 arch/arm/kernel/calls.S                   |    1 +
 arch/mips/include/uapi/asm/unistd.h       |   15 +-
 arch/mips/kernel/scall32-o32.S            |    1 +
 arch/mips/kernel/scall64-64.S             |    1 +
 arch/mips/kernel/scall64-n32.S            |    1 +
 arch/mips/kernel/scall64-o32.S            |    1 +
 arch/x86/syscalls/syscall_32.tbl          |    1 +
 arch/x86/syscalls/syscall_64.tbl          |    1 +
 crypto/asymmetric_keys/Kconfig            |   34 ++-
 crypto/asymmetric_keys/Makefile           |   37 +++
 crypto/asymmetric_keys/asymmetric_keys.h  |    2 +
 crypto/asymmetric_keys/asymmetric_type.c  |   78 +++---
 crypto/asymmetric_keys/mscode.asn1        |   28 ++
 crypto/asymmetric_keys/mscode_parser.c    |  126 ++++++++
 crypto/asymmetric_keys/pkcs7.asn1         |  127 ++++++++
 crypto/asymmetric_keys/pkcs7_key_type.c   |  100 +++++++
 crypto/asymmetric_keys/pkcs7_parser.c     |  396 +++++++++++++++++++++++++
 crypto/asymmetric_keys/pkcs7_parser.h     |   61 ++++
 crypto/asymmetric_keys/pkcs7_trust.c      |  166 +++++++++++
 crypto/asymmetric_keys/pkcs7_verify.c     |  321 ++++++++++++++++++++
 crypto/asymmetric_keys/verify_pefile.c    |  457 +++++++++++++++++++++++++++++
 crypto/asymmetric_keys/verify_pefile.h    |   42 +++
 crypto/asymmetric_keys/x509.asn1          |    2 +-
 crypto/asymmetric_keys/x509_cert_parser.c |   20 ++
 crypto/asymmetric_keys/x509_parser.h      |   13 +-
 crypto/asymmetric_keys/x509_public_key.c  |  115 +++++++-
 drivers/base/firmware_class.c             |   30 ++-
 drivers/char/tpm/tpm-interface.c          |   73 +++--
 drivers/char/tpm/tpm_eventlog.c           |    4 +-
 drivers/char/tpm/tpm_i2c_stm_st33.c       |    1 +
 drivers/char/tpm/tpm_tis.c                |   31 ++
 fs/exec.c                                 |    6 +-
 fs/nfs/idmap.c                            |   10 +-
 fs/proc/array.c                           |   11 +-
 include/crypto/pkcs7.h                    |   36 +++
 include/crypto/public_key.h               |    4 +
 include/keys/big_key-type.h               |    3 +-
 include/keys/system_keyring.h             |   10 +-
 include/keys/user-type.h                  |    3 +-
 include/linux/capability.h                |    5 +-
 include/linux/ima.h                       |    6 +
 include/linux/key-type.h                  |    5 +-
 include/linux/key.h                       |    2 +
 include/linux/oid_registry.h              |    8 +-
 include/linux/pe.h                        |  448 ++++++++++++++++++++++++++++
 include/linux/sched.h                     |   18 +-
 include/linux/seccomp.h                   |    8 +-
 include/linux/security.h                  |   17 +
 include/linux/syscalls.h                  |    2 +
 include/linux/tpm.h                       |    3 +
 include/linux/verify_pefile.h             |   18 ++
 include/net/netlabel.h                    |   94 ++++---
 include/uapi/asm-generic/unistd.h         |    4 +-
 include/uapi/linux/seccomp.h              |    7 +
 kernel/audit.c                            |    2 +-
 kernel/capability.c                       |    4 +
 kernel/fork.c                             |   49 +++-
 kernel/seccomp.c                          |  412 ++++++++++++++++++++++----
 kernel/sys.c                              |    4 +-
 kernel/sys_ni.c                           |    3 +
 kernel/system_keyring.c                   |    1 +
 lib/Kconfig                               |    3 +-
 net/ceph/crypto.c                         |   26 +-
 net/dns_resolver/dns_key.c                |   43 ++--
 net/dns_resolver/dns_query.c              |    1 +
 net/ipv4/cipso_ipv4.c                     |   47 +--
 net/netlabel/netlabel_kapi.c              |  327 ++++++++++++++-------
 net/rxrpc/ar-key.c                        |  165 ++++++-----
 scripts/selinux/genheaders/Makefile       |    1 -
 scripts/selinux/mdp/Makefile              |    2 +-
 security/apparmor/domain.c                |    4 +-
 security/capability.c                     |    6 +
 security/commoncap.c                      |   75 ++---
 security/integrity/digsig.c               |   28 ++
 security/integrity/ima/Kconfig            |   10 +
 security/integrity/ima/ima.h              |   15 +-
 security/integrity/ima/ima_appraise.c     |   10 +-
 security/integrity/ima/ima_crypto.c       |  312 +++++++++++++++++++-
 security/integrity/ima/ima_main.c         |   28 ++-
 security/integrity/ima/ima_policy.c       |   13 +-
 security/integrity/integrity.h            |   14 +-
 security/keys/big_key.c                   |   41 ++-
 security/keys/key.c                       |   49 +++-
 security/keys/keyctl.c                    |   21 ++-
 security/keys/keyring.c                   |   34 ++-
 security/keys/request_key_auth.c          |   13 +
 security/keys/user_defined.c              |   41 ++--
 security/security.c                       |   11 +
 security/selinux/hooks.c                  |   14 +
 security/selinux/include/netif.h          |    2 +
 security/selinux/include/netnode.h        |    2 +
 security/selinux/include/netport.h        |    2 +
 security/selinux/include/security.h       |    3 +-
 security/selinux/netif.c                  |   15 +-
 security/selinux/netnode.c                |   15 +-
 security/selinux/netport.c                |   15 +-
 security/selinux/ss/conditional.c         |   11 +-
 security/selinux/ss/ebitmap.c             |  135 ++++-----
 security/selinux/ss/ebitmap.h             |    8 +-
 security/selinux/ss/policydb.c            |  141 +++-------
 security/selinux/ss/services.c            |   41 ++-
 security/smack/smack_access.c             |   11 +-
 security/smack/smack_lsm.c                |    6 +-
 security/smack/smackfs.c                  |   14 +-
 110 files changed, 4481 insertions(+), 835 deletions(-)
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
