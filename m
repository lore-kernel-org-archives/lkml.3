Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab3GJNzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 09:55:18 -0400
Received: from ip-78-102-49-28.net.upcbroadband.cz ([78.102.49.28]:62051 "EHLO
	emu.suse.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754442Ab3GJNzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 09:55:12 -0400
Date: Wed, 10 Jul 2013 15:37:42 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: JBeulich@suse.com, dt.tangr@gmail.com, geert@linux-m68k.org,
        james.hogan@imgtec.com, lists@nerdbynature.de,
        mike.marciniszyn@intel.com, nicolas.dichtel@6wind.com,
        robert.richter@calxeda.com, yselkowitz@users.sourceforge.net,
        zzs0213@gmail.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild changes for v3.11-rc1
Message-ID: <20130710133742.GA29368@emu.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the kbuild bits for v3.11-rc1:

- fix for make headers_install argv explosion with too long path
- scripts/setlocalversion does not call git update-index needlessly
- fix for the src.rpm produced by make rpm-pkg. The new make image_name
  can be useful also for other packaging tools.
- scripts/mod/devicetable-offsets.o is not rebuilt during each make run
- make modules_install dependency fix
- scripts/sortextable portability fix
- fix for kbuild to generate the output directory for all object files
  in subdirs.
- a couple of minor fixes

Michal


The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kbuild

for you to fetch changes up to 4d47dde47f7dd95042fa56283d948f50dd4b509c:

  kbuild: create directory for dir/file.o (2013-07-03 22:47:08 +0200)

----------------------------------------------------------------
Christian Kujau (1):
      scripts/setlocalversion on write-protected source tree

Daniel Tang (1):
      Fix a build warning in scripts/mod/file2alias.c

Geert Uytterhoeven (1):
      scripts/mod: Spelling s/DEVICEVTABLE/DEVICETABLE/

James Hogan (1):
      Makefile.lib: align DTB quiet_cmd

Jan Beulich (1):
      improve modalias building

Mike Marciniszyn (1):
      kbuild: fix error when building from src rpm

Nicolas Dichtel (1):
      kbuild: fix make headers_install when path is too long

Robert Richter (1):
      Makefile: Fix install error with make -j option

Yaakov Selkowitz (1):
      tools/include: use stdint types for user-space byteshift headers

张忠山 (1):
      kbuild: create directory for dir/file.o

 Makefile                           |  8 ++++++--
 scripts/Makefile.headersinst       | 20 ++++++++++++++------
 scripts/Makefile.lib               |  4 ++--
 scripts/headers_install.sh         |  7 +++++--
 scripts/mod/Makefile               | 15 +++++----------
 scripts/mod/file2alias.c           | 10 ++++++----
 scripts/package/mkspec             |  1 +
 scripts/setlocalversion            |  3 ---
 tools/include/tools/be_byteshift.h | 34 +++++++++++++++++-----------------
 tools/include/tools/le_byteshift.h | 34 +++++++++++++++++-----------------
 10 files changed, 73 insertions(+), 63 deletions(-)
