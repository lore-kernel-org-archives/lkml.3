Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437Ab3FMWWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:22:24 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:33467 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757899Ab3FMWWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:22:22 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@linaro.org>
Date: Thu, 13 Jun 2013 23:22:02 +0100
X-Google-Sender-Auth: hWZADzKT9x9SBcHhbedrTk6s0-Y
Message-ID: <CACxGe6sE5qm5CmGxO8p1dR9v7bbqipm5pYRz8F6pQdWVHetCgA@mail.gmail.com>
Subject: [GIT PULL] devicetree bugfixes for v3.10
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Stephen Warren <SWarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 317ddd256b9c24b0d78fa8018f80f1e495481a10:

  Linux 3.10-rc5 (2013-06-08 17:41:04 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux tags/devicetree-for-linus

for you to fetch changes up to 706b78f37fbed8d81b6061359f28a315fb9b1d73:

  dtc: ensure #line directives don't consume data from the next line
(2013-06-13 22:12:15 +0100)

----------------------------------------------------------------
Device tree bug fixes to v3.10-rc5

This branch contains the following bug fixes:
- Fix locking vs. interrupts. Bug caught by lockdep checks
- Fix parsing of cpp #line directive output by dtc
- Fix 'make clean' for dtc temporary files.

There is also a commit that regenerates the dtc lexer and parser files
with Bison 2.5. The only purpose of this commit is to separate the
functional change in the dtc bug fix from the code generation change
caused by a different Bison version.

----------------------------------------------------------------
Benjamin Herrenschmidt (1):
      of: Fix locking vs. interrupts

Grant Likely (2):
      dtc: Update generated files to output from Bison 2.5
      dtc: ensure #line directives don't consume data from the next line

Ian Campbell (1):
      kbuild: make sure we clean up DTB temporary files

 arch/sparc/kernel/prom_common.c      |   5 +-
 drivers/of/base.c                    |  15 +-
 scripts/Makefile.lib                 |   8 +-
 scripts/dtc/dtc-lexer.l              |   2 +-
 scripts/dtc/dtc-lexer.lex.c_shipped  | 232 ++++++------
 scripts/dtc/dtc-parser.tab.c_shipped | 715 +++++++++++++++++++----------------
 scripts/dtc/dtc-parser.tab.h_shipped |  14 +-
 7 files changed, 521 insertions(+), 470 deletions(-)
