Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab3ANTyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 14:54:07 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:38024 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757009Ab3ANTyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 14:54:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=vZRiTuj/g1WDqCNmIeQ
	HlOOKcMHdB+w6spIL3x/6Bn4ojgh+39s17Z+7nc2584IjzHmdE8IKM6B1ArohMm/
	mXI/9P8vJWBP6LiGVbedRDUUJlkaxBc4qT+D6vfXusiGv3mTUPv/IIvUZy/cynrl
	9Zqp519LF+SZDr4nitlHQlDc=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v1.8.1.1
Date: Mon, 14 Jan 2013 11:54:00 -0800
Message-ID: <7vpq17a6cn.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 251FDA74-5E84-11E2-8845-F0CE2E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git v1.8.1.1 is now available at
the usual places.  This contains many bugfixes that have been
cooking on the 'master' branch since v1.8.1 was released.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

44b90aab937b0e0dbb0661eb5ec4ca6182e60854  git-1.8.1.1.tar.gz
952e0950d40bb141357be88a63f4cbb58258a4f5  git-htmldocs-1.8.1.1.tar.gz
5089613a434ba09c94f6694d546c246838377760  git-manpages-1.8.1.1.tar.gz

Also the following public repositories all have a copy of the v1.8.1.1
tag and the maint branch that the tag points at:

  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Git 1.8.1.1 Release Notes
=========================

Fixes since v1.8.1
------------------

 * The attribute mechanism didn't allow limiting attributes to be
   applied to only a single directory itself with "path/" like the
   exclude mechanism does.

 * When attempting to read the XDG-style $HOME/.config/git/config and
   finding that $HOME/.config/git is a file, we gave a wrong error
   message, instead of treating the case as "a custom config file does
   not exist there" and moving on.

 * After failing to create a temporary file using mkstemp(), failing
   pathname was not reported correctly on some platforms.

 * http transport was wrong to ask for the username when the
   authentication is done by certificate identity.

 * The behaviour visible to the end users was confusing, when they
   attempt to kill a process spawned in the editor that was in turn
   launched by Git with SIGINT (or SIGQUIT), as Git would catch that
   signal and die.  We ignore these signals now.

 * A child process that was killed by a signal (e.g. SIGINT) was
   reported in an inconsistent way depending on how the process was
   spawned by us, with or without a shell in between.

 * After "git add -N" and then writing a tree object out of the
   index, the cache-tree data structure got corrupted.

 * "git apply" misbehaved when fixing whitespace breakages by removing
   excess trailing blank lines in some corner cases.

 * A tar archive created by "git archive" recorded a directory in a
   way that made NetBSD's implementation of "tar" sometimes unhappy.

 * When "git clone --separate-git-dir=$over_there" is interrupted, it
   failed to remove the real location of the $GIT_DIR it created.
   This was most visible when interrupting a submodule update.

 * "git fetch --mirror" and fetch that uses other forms of refspec
   with wildcard used to attempt to update a symbolic ref that match
   the wildcard on the receiving end, which made little sense (the
   real ref that is pointed at by the symbolic ref would be updated
   anyway).  Symbolic refs no longer are affected by such a fetch.

 * The "log --graph" codepath fell into infinite loop in some
   corner cases.

 * "git merge" started calling prepare-commit-msg hook like "git
   commit" does some time ago, but forgot to pay attention to the exit
   status of the hook.

 * "git pack-refs" that ran in parallel to another process that
   created new refs had a race that can lose new ones.

 * When a line to be wrapped has a solid run of non space characters
   whose length exactly is the wrap width, "git shortlog -w" failed
   to add a newline after such a line.

 * The way "git svn" asked for password using SSH_ASKPASS and
   GIT_ASKPASS was not in line with the rest of the system.

 * "gitweb", when sorting by age to show repositories with new
   activities first, used to sort repositories with absolutely
   nothing in it early, which was not very useful.

 * "gitweb", when sorting by age to show repositories with new
   activities first, used to sort repositories with absolutely
   nothing in it early, which was not very useful.

 * When autoconf is used, any build on a different commit always ran
   "config.status --recheck" even when unnecessary.

 * Some scripted programs written in Python did not get updated when
   PYTHON_PATH changed.

 * We have been carrying a translated and long-unmaintained copy of an
   old version of the tutorial; removed.

 * Portability issues in many self-test scripts have been addressed.


Also contains other minor fixes and documentation updates.

----------------------------------------------------------------

Changes since v1.8.1 are as follows:

Aaron Schrab (1):
      Use longer alias names in subdirectory tests

Adam Spiers (1):
      api-allocation-growing.txt: encourage better variable naming

Antoine Pelisse (1):
      merge: Honor prepare-commit-msg return code

Christian Couder (1):
      Makefile: detect when PYTHON_PATH changes

Jean-Noël AVILA (1):
      Add directory pattern matching to attributes

Jeff King (9):
      run-command: drop silent_exec_failure arg from wait_or_whine
      launch_editor: refactor to use start/finish_command
      run-command: do not warn about child death from terminal
      launch_editor: propagate signals from editor to git
      completion: complete refs for "git commit -c"
      refs: do not use cached refs in repack_without_ref
      tests: turn on test-lint by default
      fix compilation with NO_PTHREADS
      run-command: encode signal death as a positive integer

Jens Lehmann (1):
      clone: support atomic operation with --separate-git-dir

John Keeping (4):
      git-fast-import(1): remove duplicate '--done' option
      git-shortlog(1): document behaviour of zero-width wrap
      git-fast-import(1): combine documentation of --[no-]relative-marks
      git-fast-import(1): reorganise options

Jonathan Nieder (6):
      config, gitignore: failure to access with ENOTDIR is ok
      config: treat user and xdg config permission problems as errors
      doc: advertise GIT_CONFIG_NOSYSTEM
      config: exit on error accessing any config file
      build: do not automatically reconfigure unless configure.ac changed
      docs: manpage XML depends on asciidoc.conf

Junio C Hamano (20):
      apply.c:update_pre_post_images(): the preimage can be truncated
      format_commit_message(): simplify calls to logmsg_reencode()
      sh-setup: work around "unset IFS" bug in some shells
      fetch: ignore wildcarded refspecs that update local symbolic refs
      xmkstemp(): avoid showing truncated template more carefully
      t0200: "locale" may not exist
      t9502: do not assume GNU tar
      t4014: fix arguments to grep
      t3600: Avoid "cp -a", which is a GNUism
      t9020: use configured Python to run the test helper
      compat/fnmatch: update old-style definition to ANSI
      t9200: let "cvs init" create the test repository
      merge --no-edit: do not credit people involved in the side branch
      SubmittingPatches: who am I and who cares?
      SubmittingPatches: mention subsystems with dedicated repositories
      Documentation: full-ness of a bundle is significant for cloning
      SubmittingPatches: remove overlong checklist
      SubmittingPatches: give list and maintainer addresses
      Prepare for 1.8.1.1
      Git 1.8.1.1

Kirill Brilliantov (1):
      Documentation: correct example restore from bundle

Mark Levedahl (1):
      Makefile: add comment on CYGWIN_V15_WIN32API

Matthew Daley (1):
      gitweb: Sort projects with undefined ages last

Max Horn (1):
      configure.ac: fix pthreads detection on Mac OS X

Michael Schubert (2):
      git-subtree: ignore git-subtree executable
      git-subtree: fix typo in manpage

Michał Kiedrowicz (1):
      graph.c: infinite loop in git whatchanged --graph -m

Nguyễn Thái Ngọc Duy (4):
      cache-tree: remove dead i-t-a code in verify_cache()
      cache-tree: replace "for" loops in update_one with "while" loops
      cache-tree: fix writing cache-tree when CE_REMOVE is present
      cache-tree: invalidate i-t-a paths after generating trees

Orgad Shaneh (1):
      gitweb: fix error in sanitize when highlight is enabled

Paul Fox (1):
      launch_editor: ignore terminal signals while editor has control

Rene Bredlau (1):
      http.c: Avoid username prompt for certifcate credentials

René Scharfe (2):
      archive-tar: split long paths more carefully
      t1402: work around shell quoting issue on NetBSD

Sebastian Schuberth (1):
      nedmalloc: Fix a compile warning (exposed as error) with GCC 4.7.2

Steffen Prohaska (2):
      shortlog: fix wrapping lines of wraplen
      strbuf_add_wrapped*(): Remove unused return value

Sven Strickroth (3):
      git-svn, perl/Git.pm: add central method for prompting passwords
      perl/Git.pm: Honor SSH_ASKPASS as fallback if GIT_ASKPASS is not set
      git-svn, perl/Git.pm: extend and use Git->prompt method for querying users

Thomas Ackermann (1):
      Remove Documentation/pt_BR/gittutorial.txt

Torsten Bögershausen (2):
      t9810: Do not use sed -i
      t9020: which is not portable

W. Trevor King (1):
      remote-hg: Fix biridectionality -> bidirectionality typos

