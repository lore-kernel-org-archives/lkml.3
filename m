Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab3KQMv2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 07:51:28 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751520Ab3KQMvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 07:51:20 -0500
Message-ID: <5288BBC2.1040101@nod.at>
Date: Sun, 17 Nov 2013 13:51:14 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [GIT PULL] UML changes for 3.13-rc1
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus,

The following changes since commit 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52:

  Linux 3.12 (2013-11-03 15:41:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git for-linus

for you to fetch changes up to 33a7d42999b1857d4494f6ad6367e3aef0ae8137:

  um: Remove unused declarations from <as-layout.h> (2013-11-17 11:39:22 +0100)

- ----------------------------------------------------------------
This pile contains a nice defconfig cleanup,
a rewritten stack unwinder and various cleanups.

- ----------------------------------------------------------------
Geert Uytterhoeven (1):
      um: Remove unused declarations from <as-layout.h>

Michael Opdenacker (1):
      um: remove used STDIO_CONSOLE Kconfig param

Ramkumar Ramachandra (2):
      arch/um: make it work with defconfig and x86_64
      um/vdso: add .gitignore for a couple of targets

Richard Weinberger (4):
      um: Rewrite show_stack()
      um: Make stack trace reliable against kernel mode faults
      um: Get rid of thread_struct->saved_task
      um: Make kstack_depth_to_print conform to arch/x86

 arch/um/Kconfig.char                    |   4 -
 arch/um/Kconfig.common                  |   5 -
 arch/um/Makefile                        |  11 +
 arch/um/configs/i386_defconfig          |  76 +++
 arch/um/configs/x86_64_defconfig        |  75 +++
 arch/um/defconfig                       | 899 --------------------------------
 arch/um/drivers/mconsole_kern.c         |   6 +-
 arch/um/include/asm/processor-generic.h |   2 +-
 arch/um/include/shared/as-layout.h      |   3 -
 arch/um/include/shared/os.h             |   1 +
 arch/um/kernel/process.c                |  15 +-
 arch/um/kernel/sysrq.c                  | 102 ++--
 arch/um/kernel/trap.c                   |  14 +-
 arch/um/kernel/um_arch.c                |   2 +-
 arch/um/os-Linux/signal.c               |   8 +
 arch/x86/um/Kconfig                     |   5 +
 arch/x86/um/asm/processor_32.h          |   5 +
 arch/x86/um/asm/processor_64.h          |   5 +
 arch/x86/um/sysrq_32.c                  |  66 ---
 arch/x86/um/sysrq_64.c                  |   8 +-
 arch/x86/um/vdso/.gitignore             |   2 +
 21 files changed, 273 insertions(+), 1041 deletions(-)
 create mode 100644 arch/um/configs/i386_defconfig
 create mode 100644 arch/um/configs/x86_64_defconfig
 delete mode 100644 arch/um/defconfig
 create mode 100644 arch/x86/um/vdso/.gitignore

Thanks,
//richard
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSiLvCAAoJEN9758yqZn9eSnwH/3/0e+3VcWl5+yxUhD+j/xJi
dmcO2LLONpHye1KIWn75AlNt91fkc2dauphhg/SRBqi6mVB0NWUUCtFRvWr4Wzht
5F1aYlPzBmZvChN/1S2QYnldg/EJw7okQEjnFFbWgs1Bh47m3zXU98arbI34JYQA
WisaUsApY1hejTUPtZM5ixF2+cJtXe0vkXDfdrn188pMxcqfD0hRuWBjmsIHFZC3
h65exYi3NQUG9kwRNKYYhPMc8ACQ0OEePt5CBDeJytH4LVodhpGd0i55ljWQhhHo
JQnBnU3eekUcAetLixUTAsRKsCX1xY+xrqFk/MKK/EXzOAfw4F1/90bLtal7OkA=
=Q9AM
-----END PGP SIGNATURE-----
