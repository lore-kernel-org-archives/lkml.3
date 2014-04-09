Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965024AbaDIV7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 17:59:46 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:35257 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934367AbaDIV7n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 17:59:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=lF6qCAksB1Css0H9bWG
	OTQ98xB3W5ghoy/Gyas6cJN/6PvWm289pCkaRf1RZqKivTh2biSdodHjuJJsXQOb
	Xz9I+8i5oEJ9HPAsHVWO8qxN5sPpLQeFDqlmwzzztUXoIdpj7lXRhyLQeC9EP0LK
	VbGh5ZfrDIAtSF3tpFm3gVQA=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v1.9.2
Date: Wed, 09 Apr 2014 14:59:12 -0700
Message-ID: <xmqqd2gqyxjj.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 3020A820-C032-11E3-84CA-8D19802839F8-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git v1.9.2 is now available at
the usual places.

The release tarballs are found at:

    http://www.kernel.org/pub/software/scm/git/

The following public repositories all have a copy of the v1.9.2
tag and the maint branch that the tag points at:

  url = https://kernel.googlesource.com/pub/scm/git/git
  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

The http://code.google.com/p/git-core/downloads/ site no longer
accepts new tarballs for download; while the older release tarballs
are still there, this one (and future ones) will not be.


Git v1.9.2 Release Notes
========================

Fixes since v1.9.1
------------------

 * Documentation and in-code comments had many instances of mistaken
   use of "nor", which have been corrected.

 * "git fetch --prune", when the right-hand-side of multiple fetch
   refspecs overlap (e.g. storing "refs/heads/*" to
   "refs/remotes/origin/*", while storing "refs/frotz/*" to
   "refs/remotes/origin/fr/*"), aggressively thought that lack of
   "refs/heads/fr/otz" on the origin site meant we should remove
   "refs/remotes/origin/fr/otz" from us, without checking their
   "refs/frotz/otz" first.

   Note that such a configuration is inherently unsafe (think what
   should happen when "refs/heads/fr/otz" does appear on the origin
   site), but that is not a reason not to be extra careful.

 * "git update-ref --stdin" did not fail a request to create a ref
   when the ref already existed.

 * "git diff --no-index -Mq a b" fell into an infinite loop.

 * When it is not necessary to edit a commit log message (e.g. "git
   commit -m" is given a message without specifying "-e"), we used to
   disable the spawning of the editor by overriding GIT_EDITOR, but
   this means all the uses of the editor, other than to edit the
   commit log message, are also affected.

 * "git status --porcelain --branch" showed its output with labels
   "ahead/behind/gone" translated to the user's locale.

 * "git mv" that moves a submodule forgot to adjust the array that
   uses to keep track of which submodules were to be moved to update
   its configuration.

 * Length limit for the pathname used when removing a path in a deep
   subdirectory has been removed to avoid buffer overflows.

 * The test helper lib-terminal always run an actual test_expect_*
   when included, which screwed up with the use of skil-all that may
   have to be done later.

 * "git index-pack" used a wrong variable to name the keep-file in an
   error message when the file cannot be written or closed.

 * "rebase -i" produced a broken insn sheet when the title of a commit
   happened to contain '\n' (or ended with '\c') due to a careless use
   of 'echo'.

 * There were a few instances of 'git-foo' remaining in the
   documentation that should have been spelled 'git foo'.

 * Serving objects from a shallow repository needs to write a
   new file to hold the temporary shallow boundaries but it was not
   cleaned when we exit due to die() or a signal.

 * When "git stash pop" stops after failing to apply the stash
   (e.g. due to conflicting changes), the stash is not dropped. State
   that explicitly in the output to let the users know.

 * The labels in "git status" output that describe the nature of
   conflicts (e.g. "both deleted") were limited to 20 bytes, which was
   too short for some l10n (e.g. fr).

----------------------------------------------------------------

Changes since v1.9.1 are as follows:

Aman Gupta (1):
      update-ref: fail create operation over stdin if ref already exists

Benoit Pierre (7):
      merge hook tests: fix missing '&&' in test
      merge hook tests: use 'test_must_fail' instead of '!'
      test patch hunk editing with "commit -p -m"
      commit: fix patch hunk editing with "commit -p -m"
      merge: fix GIT_EDITOR override for commit hook
      merge hook tests: fix and update tests
      run-command: mark run_hook_with_custom_index as deprecated

Carlos Martín Nieto (2):
      fetch: add a failing test for prunning with overlapping refspecs
      fetch: handle overlaping refspecs on --prune

Jeff King (6):
      shallow: use stat_validity to check for up-to-date file
      shallow: automatically clean up shallow tempfiles
      t/lib-terminal: make TTY a lazy prerequisite
      shallow: verify shallow file after taking lock
      date: recognize bogus FreeBSD gmtime output
      t4212: loosen far-in-future test for AIX

John Keeping (1):
      builtin/mv: fix out of bounds write

Jonathan Nieder (2):
      wt-status: extract the code to compute width for labels
      wt-status: i18n of section labels

Junio C Hamano (8):
      stash pop: mention we did not drop the stash upon failing to apply
      wt-status: make full label string to be subject to l10n
      wt-status: lift the artificual "at least 20 columns" floor
      index-pack: report error using the correct variable
      diff-no-index: correctly diagnose error return from diff_opt_parse()
      Start preparing for 1.9.1
      Update draft release notes to 1.9.2
      Git 1.9.2

Justin Lebar (4):
      Documentation: fix misuses of "nor"
      contrib: fix misuses of "nor"
      comments: fix misuses of "nor"
      code and test: fix misuses of "nor"

Matthieu Moy (1):
      status: disable translation when --porcelain is used

Michael Haggerty (2):
      checkout_entry(): use the strbuf throughout the function
      entry.c: fix possible buffer overflow in remove_subtree()

Ramkumar Ramachandra (1):
      Documentation/merge-strategies: avoid hyphenated commands

Thomas Ackermann (1):
      doc/http-backend: missing accent grave in literal mark-up

Uwe Storbeck (2):
      rebase -i: do not "echo" random user-supplied strings
      test-lib.sh: do not "echo" caller-supplied strings

brian m. carlson (1):
      mv: prevent mismatched data when ignoring errors.

