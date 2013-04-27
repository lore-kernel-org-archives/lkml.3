Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab3D0AVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 20:21:19 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:55070 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab3D0AVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 20:21:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=ZZGJ0R3mild0jdCQ5D9
	DCCGx4E9zF9tVCqs/66Z2DerdKL+nDnLlbx4Bd3sMSzeoyNeTfbem7Dkt2v5xY8f
	PWQbVZIciUOg0vOmER+ySgPNDBWbIvdfDtpaKVWe428IDaqMD9jEPAmVETvaHdSv
	tnzQMylZhoeslJOnGLsPW6fs=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v1.8.2.2
Date: Fri, 26 Apr 2013 17:21:08 -0700
Message-ID: <7vzjwku8ln.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 5FEC4B1E-AED0-11E2-B23B-BCFF4146488D-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git v1.8.2.2 is now available at
the usual places.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

47a86a0a4f92998f21ada77be146676ecfd2e4af  git-1.8.2.2.tar.gz
8f334c0f5433ad7513680ffd0bf0f29dd5821450  git-htmldocs-1.8.2.2.tar.gz
ffde312471c4b391a47426948be25629582a77ab  git-manpages-1.8.2.2.tar.gz

Also the following public repositories all have a copy of the v1.8.2.2
tag and the maint branch that the tag points at:

  url = https://kernel.googlesource.com/pub/scm/git/git
  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Git v1.8.2.2 Release Notes
==========================

Fixes since v1.8.2.1
--------------------

 * Zsh completion forgot that '%' character used to signal untracked
   files needs to be escaped with another '%'.

 * A commit object whose author or committer ident are malformed
   crashed some code that trusted that a name, an email and an
   timestamp can always be found in it.

 * The new core.commentchar configuration was not applied to a few
   places.

 * "git pull --rebase" did not pass "-v/-q" options to underlying
   "git rebase".

 * When receive-pack detects error in the pack header it received in
   order to decide which of unpack-objects or index-pack to run, it
   returned without closing the error stream, which led to a hang
   sideband thread.

 * "git diff --diff-algorithm=algo" was understood by the command line
   parser, but "git diff --diff-algorithm algo" was not.

 * "git log -S/-G" started paying attention to textconv filter, but
   there was no way to disable this.  Make it honor --no-textconv
   option.

 * "git merge $(git rev-parse v1.8.2)" behaved quite differently from
   "git merge v1.8.2", as if v1.8.2 were written as v1.8.2^0 and did
   not pay much attention to the annotated tag payload.  Make the code
   notice the type of the tag object, in addition to the dwim_ref()
   based classification the current code uses (i.e. the name appears
   in refs/tags/) to decide when to special case merging of tags.

 * "git cherry-pick" and "git revert" can take more than one commit
   on the command line these days, but it was not mentioned on the usage
   text.

 * Perl scripts like "git-svn" closed (not redirecting to /dev/null)
   the standard error stream, which is not a very smart thing to do.
   Later open may return file descriptor #2 for unrelated purpose, and
   error reporting code may write into them.

 * "git apply --whitespace=fix" was not prepared to see a line getting
   longer after fixing whitespaces (e.g. tab-in-indent aka Python).

 * "git diff/log --cc" did not work well with options that ignore
   whitespace changes.

 * Documentation on setting up a http server that requires
   authentication only on the push but not fetch has been clarified.

 * A few bugfixes to "git rerere" working on corner case merge
   conflicts have been applied.

 * "git bundle" did not like a bundle created using a commit without
   any message as its one of the prerequistes.

----------------------------------------------------------------

Changes since v1.8.2.1 are as follows:

Adam Spiers (1):
      t: make PIPE a standard test prerequisite

Antoine Pelisse (2):
      fix clang -Wtautological-compare with unsigned enum
      Allow combined diff to ignore white-spaces

Benoit Bourbie (1):
      Typo fix: replacing it's -> its

Carlos Martín Nieto (1):
      Documentation/git-commit: reword the --amend explanation

David Aguilar (1):
      help.c: add a compatibility comment to cmd_version()

Felipe Contreras (2):
      remote-hg: fix commit messages
      prompt: fix untracked files for zsh

Jakub Narębski (1):
      gitweb/INSTALL: Simplify description of GITWEB_CONFIG_SYSTEM

Jeff King (13):
      submodule: clarify logic in show_submodule_summary
      filter-branch: return to original dir after filtering
      diffcore-pickaxe: remove fill_one()
      diffcore-pickaxe: unify code for log -S/-G
      show-branch: use strbuf instead of static buffer
      doc/http-backend: clarify "half-auth" repo configuration
      doc/http-backend: give some lighttpd config examples
      doc/http-backend: match query-string in apache half-auth example
      t/test-lib.sh: drop "$test" variable
      usage: allow pluggable die-recursion checks
      run-command: use thread-aware die_is_recursing routine
      cat-file: print tags raw for "cat-file -p"
      receive-pack: close sideband fd on early pack errors

Jiang Xin (1):
      i18n: make the translation of -u advice in one go

Johannes Sixt (3):
      rerere forget: grok files containing NUL
      rerere forget: do not segfault if not all stages are present
      t6200: avoid path mangling issue on Windows

John Keeping (5):
      diffcore-break: don't divide by zero
      bisect: avoid signed integer overflow
      git-merge(1): document diff-algorithm option to merge-recursive
      diff: allow unstuck arguments with --diff-algorithm
      t/test-lib.sh: fix TRASH_DIRECTORY handling

Jonathan Nieder (1):
      gitweb/INSTALL: GITWEB_CONFIG_SYSTEM is for backward compatibility

Junio C Hamano (13):
      merge: a random object may not necssarily be a commit
      apply --whitespace=fix: avoid running over the postimage buffer
      t5516: test interaction between pushURL and pushInsteadOf correctly
      test: resurrect q_to_tab
      t6200: use test_config/test_unconfig
      t6200: test message for merging of an annotated tag
      diffcore-pickaxe: port optimization from has_changes() to diff_grep()
      diffcore-pickaxe: fix leaks in "log -S<block>" and "log -G<pattern>"
      glossary: extend "detached HEAD" description
      doc: clarify that "git daemon --user=<user>" option does not export HOME=~user
      Start preparing for 1.8.2.2
      Update draft release notes to 1.8.2.2
      Git 1.8.2.2

Kevin Bracey (1):
      cherry-pick/revert: make usage say '<commit-ish>...'

Lukas Fleischer (1):
      bundle: Accept prerequisites without commit messages

Martin von Gagern (1):
      Documentation: Strip texinfo anchors to avoid duplicates

Mårten Kongstad (1):
      completion: remove duplicate block for "git commit -c"

Paul Price (1):
      fast-export: fix argument name in error messages

Peter Eisentraut (1):
      pull: Apply -q and -v options to rebase mode as well

Ralf Thielow (2):
      fmt-merge-msg: respect core.commentchar in people credits
      fmt-merge-msg: use core.commentchar in tag signatures completely

Ramkumar Ramachandra (4):
      t3200 (branch): modernize style
      send-email: use "return;" not "return undef;" on error codepaths
      send-email: drop misleading function prototype
      send-email: use the three-arg form of open in recipients_cmd

René Scharfe (5):
      match-trees: simplify score_trees() using tree_entry()
      t5004: fix issue with empty archive test and bsdtar
      archive: clarify explanation of --worktree-attributes
      pretty: handle broken commit headers gracefully
      blame: handle broken commit headers gracefully

Robin Rosenberg (1):
      bash: teach __git_ps1 about REVERT_HEAD

Simon Ruderich (3):
      diffcore-pickaxe: remove unnecessary call to get_textconv()
      diffcore-pickaxe: respect --no-textconv
      t/README: --immediate skips cleanup commands for failed tests

Stefan Saasen (1):
      Documentation: distinguish between ref and offset deltas in pack-format

Stefano Lattarini (9):
      doc: various spelling fixes
      git-remote-mediawiki: spelling fixes
      contrib/subtree: fix spelling of accidentally
      obstack: fix spelling of similar
      compat/regex: fix spelling and grammar in comments
      compat/nedmalloc: fix spelling in comments
      precompose-utf8: fix spelling of "want" in error message
      kwset: fix spelling in comments
      Correct common spelling mistakes in comments and tests

Thomas Ackermann (4):
      glossary: remove outdated/misleading/irrelevant entries
      glossary: improve description of SHA-1 related topics
      The name of the hash function is "SHA-1", not "SHA1"
      glossary: improve definitions of refspec and pathspec

Thomas Rast (2):
      perl: redirect stderr to /dev/null instead of closing
      t9700: do not close STDERR

Torsten Bögershausen (5):
      t9020: do not use export X=Y
      t9501: do not use export X=Y
      test-hg-bidi.sh: do not use export X=Y
      test-hg-hg-git.sh: do not use export X=Y
      t7409: do not use export X=Y

