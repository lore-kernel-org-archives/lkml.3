Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab3KOQKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 11:10:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab3KOQJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 11:09:57 -0500
Date: Fri, 15 Nov 2013 17:09:52 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ak@linux.intel.com, andi@firstfloor.org, bp@suse.de,
        fabio.estevam@freescale.com, jmario@redhat.com, josh@joshtriplett.org,
        keescook@chromium.org, mmarek@suse.cz, slyfox@gentoo.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild changes for v3.13-rc1
Message-ID: <20131115160952.GA19669@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these kbuild commits for v3.13-rc1:
- LTO fixes, but the kallsyms part had to be reverted
- -Werror=implicit-int and -Werror=strict-prototypes is passsed to the
  compiler by default
- snprintf fix in modpost
- GREP_OPTIONS is removed from the environment to be immune against
  exotic grep option settings

Thanks,
Michal


The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kbuild

for you to fetch changes up to 480f439c3db0d45d817d66caf3fa8e81a6fac01a:

  kallsyms: Revert back to 128 max symbol length (2013-11-13 15:58:19 +0100)

----------------------------------------------------------------
Andi Kleen (2):
      Kbuild: Handle longer symbols in kallsyms.c
      kbuild, bloat-o-meter: fix static detection

Borislav Petkov (1):
      Kbuild: Ignore GREP_OPTIONS env variable

Fabio Estevam (1):
      scripts: kallsyms: Use %zu to print 'size_t'

Joe Mario (1):
      kbuild: Increase kallsyms max symbol length

Josh Triplett (2):
      scripts/bloat-o-meter: ignore changes in the size of linux_banner
      scripts/bloat-o-meter: use .startswith rather than fragile slicing

Kees Cook (1):
      kbuild: replace unbounded sprintf call in modpost

Michal Marek (1):
      kallsyms: Revert back to 128 max symbol length

Sergei Trofimovich (1):
      Makefile: enable -Werror=implicit-int and -Werror=strict-prototypes by default

 Makefile                 | 9 +++++++++
 scripts/bloat-o-meter    | 7 ++++---
 scripts/kallsyms.c       | 6 ++++++
 scripts/mod/sumversion.c | 2 +-
 4 files changed, 20 insertions(+), 4 deletions(-)
