Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab3KGAt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 19:49:29 -0500
Received: from tundra.namei.org ([65.99.196.166]:42500 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab3KGAt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 19:49:26 -0500
Date: Thu, 7 Nov 2013 11:51:31 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [GIT] Security subsystem updates for 3.13
Message-ID: <alpine.LRH.2.02.1311071146450.31522@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patchset, we finally get an SELinux update, with Paul Moore taking 
over as maintainer of that code.

Also a significant update for the Keys subsystem, as well as maintenance 
updates to Smack, IMA, TPM, and Apparmor.

Please pull.

The following changes since commit be408cd3e1fef73e9408b196a79b9934697fe3b1:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2013-11-04 06:40:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Anand Avati (1):
      selinux: consider filesystem subtype in policies

Antonio Alecrim Jr (1):
      X.509: remove possible code fragility: enumeration values not handled

Casey Schaufler (2):
      Smack: Implement lock security mode
      Smack: Ptrace access check mode

Chen Gang (1):
      kernel/system_certificate.S: use real contents instead of macro GLOBAL()

Chris PeBenito (1):
      Add SELinux policy capability for always checking packet and peer classes.

David Howells (29):
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
      KEYS: Fix a race between negating a key and reading the error set
      KEYS: Fix keyring quota misaccounting on key replacement and unlink

Dmitry Kasatkin (11):
      ima: fix script messages
      crypto: provide single place for hash algo information
      keys: change asymmetric keys to use common hash definitions
      ima: provide support for arbitrary hash algorithms
      ima: read and use signature hash algorithm
      ima: pass full xattr with the signature
      ima: use dynamically allocated hash storage
      ima: provide dedicated hash algo allocation function
      ima: support arbitrary hash algorithms in ima_calc_buffer_hash
      ima: ima_calc_boot_agregate must use SHA1
      ima: provide hash algo info in the xattr

Duan Jiong (1):
      selinux: Use kmemdup instead of kmalloc + memcpy

Eric Paris (13):
      SELinux: fix selinuxfs policy file on big endian systems
      SELinux: remove crazy contortions around proc
      SELinux: make it harder to get the number of mnt opts wrong
      SELinux: use define for number of bits in the mnt flags mask
      SELinux: rename SE_SBLABELSUPP to SBLABEL_MNT
      SELinux: do all flags twiddling in one place
      SELinux: renumber the superblock options
      SELinux: change sbsec->behavior to short
      SELinux: do not handle seclabel as a special flag
      SELinux: pass a superblock to security_fs_use
      SELinux: use a helper function to determine seclabel
      Revert "SELinux: do not handle seclabel as a special flag"
      security: remove erroneous comment about capabilities.o link ordering

James Morris (3):
      Merge branch 'master' of git://git.infradead.org/users/pcmoore/selinux into ra-next
      Merge branch 'smack-for-3.13' of git://git.gitorious.org/smack-next/kernel into ra-next
      Merge branch 'keys-devel' of git://git.kernel.org/.../dhowells/linux-fs into ra-next

Jason Gunthorpe (11):
      tpm: ibmvtpm: Use %zd formatting for size_t format arguments
      tpm atmel: Call request_region with the correct base
      tpm: Store devname in the tpm_chip
      tpm: Use container_of to locate the tpm_chip in tpm_open
      tpm: Remove redundant dev_set_drvdata
      tpm: st33: Remove chip->data_buffer access from this driver
      tpm: Remove tpm_show_caps_1_2
      tpm: Rename tpm.c to tpm-interface.c
      tpm: Merge the tpm-bios module with tpm.o
      tpm: Add support for the Nuvoton NPCT501 I2C TPM
      tpm: Add support for Atmel I2C TPMs

John Johansen (3):
      apparmor: fix capability to not use the current task, during reporting
      apparmor: remove tsk field from the apparmor_audit_struct
      apparmor: remove parent task info from audit logging

Josh Boyer (1):
      KEYS: Make BIG_KEYS boolean

Konstantin Khlebnikov (2):
      MPILIB: add module description and license
      X.509: add module description and license

Mimi Zohar (10):
      KEYS: Make the system 'trusted' keyring viewable by userspace
      KEYS: verify a certificate is signed by a 'trusted' key
      KEYS: initialize root uid and session keyrings early
      Revert "ima: policy for RAMFS"
      ima: differentiate between template hash and file data hash sizes
      ima: add audit log support for larger hashes
      ima: add Kconfig default measurement list template
      ima: enable support for larger default filedata hash algorithms
      ima: extend the measurement list to include the file signature
      ima: define '_ima' as a builtin 'trusted' keyring

Oleg Nesterov (1):
      apparmor: remove the "task" arg from may_change_ptraced_domain()

Paul Moore (13):
      lsm: split the xfrm_state_alloc_security() hook implementation
      selinux: cleanup and consolidate the XFRM alloc/clone/delete/free code
      selinux: cleanup selinux_xfrm_policy_lookup() and selinux_xfrm_state_pol_flow_match()
      selinux: cleanup selinux_xfrm_sock_rcv_skb() and selinux_xfrm_postroute_last()
      selinux: cleanup some comment and whitespace issues in the XFRM code
      selinux: cleanup selinux_xfrm_decode_session()
      selinux: cleanup the XFRM header
      selinux: remove the BUG_ON() from selinux_skb_xfrm_sid()
      selinux: fix problems in netnode when BUG() is compiled out
      Merge git://git.infradead.org/users/eparis/selinux
      selinux: add Paul Moore as a SELinux maintainer
      selinux: add Paul Moore as a SELinux maintainer
      selinux: correct locking in selinux_netlbl_socket_connect)

Peter Huewe (4):
      tpm: MAINTAINERS: Add myself as tpm maintainer
      tpm: cleanup checkpatch warnings
      tpm: Fix module name description in Kconfig for tpm_i2c_infineon
      tpm: use tabs instead of whitespaces in Kconfig

Roberto Sassu (9):
      ima: pass the file descriptor to ima_add_violation()
      ima: pass the filename argument up to ima_add_template_entry()
      ima: define new function ima_alloc_init_template() to API
      ima: new templates management mechanism
      ima: define template fields library and new helpers
      ima: define new template ima-ng and template fields d-ng and n-ng
      ima: switch to new template management mechanism
      ima: defer determining the appraisal hash algorithm for 'ima' template
      ima: define kernel parameter 'ima_template=' to change configured default

Stephen Smalley (1):
      SELinux: Enable setting security contexts on rootfs inodes.

Waiman Long (2):
      SELinux: Reduce overhead of mls_level_isvalid() function call
      SELinux: Increase ebitmap_node size for 64-bit configuration

Wei Yongjun (1):
      KEYS: fix error return code in big_key_instantiate()

 Documentation/assoc_array.txt                      |  574 +++++++
 .../devicetree/bindings/i2c/trivial-devices.txt    |    3 +
 Documentation/kernel-parameters.txt                |   11 +-
 Documentation/security/00-INDEX                    |    2 +
 Documentation/security/IMA-templates.txt           |   87 +
 Documentation/security/keys.txt                    |   20 +-
 MAINTAINERS                                        |    4 +-
 crypto/Kconfig                                     |    3 +
 crypto/Makefile                                    |    1 +
 crypto/asymmetric_keys/Kconfig                     |    3 +-
 crypto/asymmetric_keys/asymmetric_type.c           |    1 +
 crypto/asymmetric_keys/public_key.c                |   66 +-
 crypto/asymmetric_keys/public_key.h                |    6 +
 crypto/asymmetric_keys/rsa.c                       |   14 +-
 crypto/asymmetric_keys/x509_cert_parser.c          |   35 +-
 crypto/asymmetric_keys/x509_parser.h               |   18 +-
 crypto/asymmetric_keys/x509_public_key.c           |  232 ++-
 crypto/hash_info.c                                 |   56 +
 drivers/char/tpm/Kconfig                           |   37 +-
 drivers/char/tpm/Makefile                          |   11 +-
 drivers/char/tpm/{tpm.c => tpm-interface.c}        |  138 +-
 drivers/char/tpm/tpm.h                             |    3 +-
 drivers/char/tpm/tpm_atmel.c                       |    2 +-
 drivers/char/tpm/tpm_eventlog.c                    |    3 -
 drivers/char/tpm/tpm_i2c_atmel.c                   |  284 ++++
 drivers/char/tpm/tpm_i2c_infineon.c                |    4 +-
 drivers/char/tpm/tpm_i2c_nuvoton.c                 |  710 ++++++++
 drivers/char/tpm/tpm_i2c_stm_st33.c                |   12 +-
 drivers/char/tpm/tpm_ibmvtpm.c                     |    6 +-
 drivers/char/tpm/tpm_ppi.c                         |    4 -
 drivers/char/tpm/tpm_tis.c                         |    2 +-
 drivers/char/tpm/xen-tpmfront.c                    |    2 -
 include/crypto/hash_info.h                         |   40 +
 include/crypto/public_key.h                        |   25 +-
 include/keys/big_key-type.h                        |   25 +
 include/keys/keyring-type.h                        |   17 +-
 include/keys/system_keyring.h                      |   23 +
 include/linux/assoc_array.h                        |   92 +
 include/linux/assoc_array_priv.h                   |  182 ++
 include/linux/key-type.h                           |    6 +
 include/linux/key.h                                |   52 +-
 include/linux/security.h                           |   26 +-
 include/linux/user_namespace.h                     |    6 +
 include/uapi/linux/hash_info.h                     |   37 +
 include/uapi/linux/keyctl.h                        |    1 +
 init/Kconfig                                       |   13 +
 kernel/Makefile                                    |   50 +-
 kernel/modsign_certificate.S                       |   12 -
 kernel/modsign_pubkey.c                            |  104 --
 kernel/module-internal.h                           |    2 -
 kernel/module_signing.c                            |   11 +-
 kernel/system_certificates.S                       |   10 +
 kernel/system_keyring.c                            |  105 ++
 kernel/user.c                                      |    4 +
 kernel/user_namespace.c                            |    6 +
 lib/Kconfig                                        |   14 +
 lib/Makefile                                       |    1 +
 lib/assoc_array.c                                  | 1746 ++++++++++++++++++++
 lib/mpi/mpiutil.c                                  |    3 +
 scripts/asn1_compiler.c                            |    2 +
 security/Makefile                                  |    1 -
 security/apparmor/audit.c                          |   14 +-
 security/apparmor/capability.c                     |   15 +-
 security/apparmor/domain.c                         |   16 +-
 security/apparmor/include/audit.h                  |    1 -
 security/apparmor/include/capability.h             |    5 +-
 security/apparmor/include/ipc.h                    |    4 +-
 security/apparmor/ipc.c                            |    9 +-
 security/apparmor/lsm.c                            |    2 +-
 security/capability.c                              |   15 +-
 security/integrity/digsig.c                        |   37 +-
 security/integrity/digsig_asymmetric.c             |   11 -
 security/integrity/evm/evm_main.c                  |    4 +-
 security/integrity/evm/evm_posix_acl.c             |    3 +-
 security/integrity/iint.c                          |    2 +
 security/integrity/ima/Kconfig                     |   72 +
 security/integrity/ima/Makefile                    |    2 +-
 security/integrity/ima/ima.h                       |  101 +-
 security/integrity/ima/ima_api.c                   |  136 ++-
 security/integrity/ima/ima_appraise.c              |  117 ++-
 security/integrity/ima/ima_crypto.c                |  134 ++-
 security/integrity/ima/ima_fs.c                    |   67 +-
 security/integrity/ima/ima_init.c                  |   37 +-
 security/integrity/ima/ima_main.c                  |   63 +-
 security/integrity/ima/ima_policy.c                |    1 -
 security/integrity/ima/ima_queue.c                 |   10 +-
 security/integrity/ima/ima_template.c              |  178 ++
 security/integrity/ima/ima_template_lib.c          |  347 ++++
 security/integrity/ima/ima_template_lib.h          |   49 +
 security/integrity/integrity.h                     |   47 +-
 security/keys/Kconfig                              |   29 +
 security/keys/Makefile                             |    2 +
 security/keys/big_key.c                            |  206 +++
 security/keys/compat.c                             |    3 +
 security/keys/gc.c                                 |   33 +-
 security/keys/internal.h                           |   74 +-
 security/keys/key.c                                |  102 +-
 security/keys/keyctl.c                             |    3 +
 security/keys/keyring.c                            | 1505 +++++++++--------
 security/keys/persistent.c                         |  169 ++
 security/keys/proc.c                               |   17 +-
 security/keys/process_keys.c                       |  141 +-
 security/keys/request_key.c                        |   60 +-
 security/keys/request_key_auth.c                   |   31 +-
 security/keys/sysctl.c                             |   11 +
 security/keys/user_defined.c                       |   18 +-
 security/security.c                                |   13 +-
 security/selinux/hooks.c                           |  146 ++-
 security/selinux/include/objsec.h                  |    4 +-
 security/selinux/include/security.h                |   13 +-
 security/selinux/include/xfrm.h                    |   45 +-
 security/selinux/netlabel.c                        |    6 +-
 security/selinux/netnode.c                         |    2 +
 security/selinux/selinuxfs.c                       |    4 +-
 security/selinux/ss/ebitmap.c                      |   20 +-
 security/selinux/ss/ebitmap.h                      |   10 +-
 security/selinux/ss/mls.c                          |   22 +-
 security/selinux/ss/mls_types.h                    |    2 +-
 security/selinux/ss/policydb.c                     |    3 +-
 security/selinux/ss/services.c                     |   66 +-
 security/selinux/xfrm.c                            |  453 +++---
 security/smack/smack.h                             |   12 +-
 security/smack/smack_access.c                      |   10 +
 security/smack/smack_lsm.c                         |   11 +-
 security/smack/smackfs.c                           |   10 +-
 125 files changed, 7697 insertions(+), 2028 deletions(-)
 create mode 100644 Documentation/assoc_array.txt
 create mode 100644 Documentation/security/IMA-templates.txt
 create mode 100644 crypto/hash_info.c
 rename drivers/char/tpm/{tpm.c => tpm-interface.c} (93%)
 create mode 100644 drivers/char/tpm/tpm_i2c_atmel.c
 create mode 100644 drivers/char/tpm/tpm_i2c_nuvoton.c
 create mode 100644 include/crypto/hash_info.h
 create mode 100644 include/keys/big_key-type.h
 create mode 100644 include/keys/system_keyring.h
 create mode 100644 include/linux/assoc_array.h
 create mode 100644 include/linux/assoc_array_priv.h
 create mode 100644 include/uapi/linux/hash_info.h
 delete mode 100644 kernel/modsign_certificate.S
 delete mode 100644 kernel/modsign_pubkey.c
 create mode 100644 kernel/system_certificates.S
 create mode 100644 kernel/system_keyring.c
 create mode 100644 lib/assoc_array.c
 create mode 100644 security/integrity/ima/ima_template.c
 create mode 100644 security/integrity/ima/ima_template_lib.c
 create mode 100644 security/integrity/ima/ima_template_lib.h
 create mode 100644 security/keys/big_key.c
 create mode 100644 security/keys/persistent.c
