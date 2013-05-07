Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472Ab3EGM6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:58:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076Ab3EGM6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:58:07 -0400
Date: Tue, 7 May 2013 14:58:03 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: bp@suse.de, mmarek@suse.cz, nicolas.palix@imag.fr, pebolle@tiscali.nl,
        tkhai@yandex.ru, wbin00@gmail.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild misc change for v3.10-rc1
Message-ID: <20130507125803.GA13389@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these non-critical kbuild changes for v3.10-rc1:

* make coccicheck improvements, but no new semantic patches this time
* make rpm improvements
* make tar-pkg change to include the architecture in the filename. This
  is a deliberate incompatibility, but nobody has complained so far and
  it is useful if you build for different architectures. It also matches
  what the deb-pkg and rpm-pkg targets produce.
* kbuild documentation fix

Michal


The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git misc

Bin Wang (1):
      scripts/package/Makefile: compare objtree with srctree instead of test KBUILD_OUTPUT

Borislav Petkov (1):
      buildtar: Add ARCH to the archive name

Kirill Tkhai (1):
      scripts/tags.sh: Add magic for OFFSET and DEFINE

Michal Marek (4):
      rpm-pkg: Do not package the whole source directory
      rpm-pkg: Do not write to the parent directory
      rpm-pkg: Always regenerate the specfile
      rpm-pkg: Remove pointless set -e statements

Nicolas Palix (4):
      Coccinelle: Restore coccicheck verbosity in ONLINE mode (C=1 or C=2)
      Coccinelle: Cleanup the setting of the FLAGS and OPTIONS variables
      Coccinelle: Add support to the SPFLAGS variable
      Coccinelle: Fix patch output when coccicheck is used with M= and C=

Paul Bolle (1):
      doc: change example to existing Makefile fragment

 Documentation/coccinelle.txt       |   11 +++++++++-
 Documentation/kbuild/makefiles.txt |    5 ++-
 Makefile                           |    2 +
 scripts/coccicheck                 |   31 ++++++++++++++++------------
 scripts/package/Makefile           |   39 +++++++++++++----------------------
 scripts/package/buildtar           |    2 +-
 scripts/tags.sh                    |    4 ++-
 7 files changed, 52 insertions(+), 42 deletions(-)
