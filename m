Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035Ab3B0N2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 08:28:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36419 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626Ab3B0N2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 08:28:11 -0500
Date: Wed, 27 Feb 2013 14:28:09 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Julia.Lawall@lip6.fr, bernd.schubert@itwm.fraunhofer.de, drbild@umich.edu,
        peter.senna@gmail.com, schwab@linux-m68k.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild misc changes for v3.9-rc1
Message-ID: <20130227132809.GA32484@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

these are the non-critical kbuild changes for v3.9-rc1:

* Fix for make TAGS
* Fix for make rpm
* Some new coccinelle semantic patches

Please pull, thanks.
Michal


The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565:

  Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git misc

for you to fetch changes up to 24f0c2d6ff859fbca45fd765f0d241528bdb4365:

  scripts/coccinelle: find constant additions that could be bit ors (2013-02-22 14:26:00 +0100)

----------------------------------------------------------------
Andreas Schwab (1):
      scripts/tags.sh: Fix regex syntax for etags

Bernd Schubert (2):
      coccicheck: Allow the user to give a V= (verbose) argument
      coccicheck: Allow to show the executed command line

David R. Bild (1):
      kbuild: clear KBUILD_SRC when calling 'make' in RPM spec

Julia Lawall (1):
      scripts/coccinelle: find constant additions that could be bit ors

Peter Senna Tschudin (2):
      scripts/coccinelle/misc/semicolon.cocci: Add unneeded semicolon test
      scripts/coccinelle/misc/memcpy-assign.cocci: Replace memcpy with struct assignment

 Documentation/coccinelle.txt                |    4 ++
 scripts/coccicheck                          |   39 +++++++---
 scripts/coccinelle/misc/memcpy-assign.cocci |  103 +++++++++++++++++++++++++++
 scripts/coccinelle/misc/orplus.cocci        |   55 ++++++++++++++
 scripts/coccinelle/misc/semicolon.cocci     |   83 +++++++++++++++++++++
 scripts/package/mkspec                      |    2 +-
 scripts/tags.sh                             |   50 ++++++-------
 7 files changed, 302 insertions(+), 34 deletions(-)
 create mode 100644 scripts/coccinelle/misc/memcpy-assign.cocci
 create mode 100644 scripts/coccinelle/misc/orplus.cocci
 create mode 100644 scripts/coccinelle/misc/semicolon.cocci
