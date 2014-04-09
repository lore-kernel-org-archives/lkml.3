Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934121AbaDIP7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:59:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933683AbaDIP7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:59:36 -0400
Date: Wed, 9 Apr 2014 17:59:34 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: fabf@skynet.be, jason@lakedaemon.net, peter.senna@gmail.com,
        prarit@redhat.com, sachin.kamat@linaro.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild misc changes for v3.15-rc1
Message-ID: <20140409155934.GA27116@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is the non-critical part of kbuild:
- One bogus coccinelle check removed, one check fixed not to suggest
  the obsolete PTR_RET macro
- scripts/tags.sh does not index the generated *.mod.c files
- new objdiff tool to list differences between two versions of an object
  file
- A fix for scripts/bootgraph.pl

Thanks,
Michal

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git misc

for you to fetch changes up to f23a9fa7e81f7df65e0bcf586e028a2db736b9e6:

  scripts/coccinelle: Use PTR_ERR_OR_ZERO (2014-04-08 17:27:01 +0200)

----------------------------------------------------------------
Fabian Frederick (1):
      scripts/bootgraph.pl: Add graphic header

Jason Cooper (1):
      scripts: objdiff: detect object code changes between two commits

Peter Senna Tschudin (1):
      Coccicheck: Remove memcpy to struct assignment test

Prarit Bhargava (1):
      scripts/tags.sh: Ignore *.mod.c

Sachin Kamat (1):
      scripts/coccinelle: Use PTR_ERR_OR_ZERO

 Makefile                                    |   7 +-
 scripts/bootgraph.pl                        |  42 ++++++++-
 scripts/coccinelle/api/ptr_ret.cocci        |  14 +--
 scripts/coccinelle/misc/memcpy-assign.cocci | 103 --------------------
 scripts/objdiff                             | 141 ++++++++++++++++++++++++++++
 scripts/tags.sh                             |   9 +-
 6 files changed, 196 insertions(+), 120 deletions(-)
 delete mode 100644 scripts/coccinelle/misc/memcpy-assign.cocci
 create mode 100755 scripts/objdiff
