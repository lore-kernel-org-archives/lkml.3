Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab3I0SwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 14:52:08 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:39597 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab3I0SwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 14:52:06 -0400
Date: Fri, 27 Sep 2013 11:52:00 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v1.8.4.1
Message-ID: <20130927185200.GL9464@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git v1.8.4.1 is now available.

The release tarballs are found at:

    http://alioth.debian.org/~jrnieder-guest/git/

and their SHA-1 checksums are:

49004a8dfcbb7c0848147737d9877fd7313a42ec  git-1.8.4.1.tar.gz
1f0e5c5934ec333b5630a8c93a0fb0b1895dfcb8  git-htmldocs-1.8.4.1.tar.gz
dc0f9de1cacc8912f131b67dc5a19a96768ecc95  git-manpages-1.8.4.1.tar.gz

The following public repositories all have a copy of the v1.8.4.1
tag and the maint branch that the tag points at:

  url = https://googlers.googlesource.com/jrn/git
  url = git://repo.or.cz/git/jrn.git
  url = git://gitorious.org/git/jrn.git
  url = https://github.com/jrn/git

Git v1.8.4.1 Release Notes
========================

Fixes since v1.8.4
------------------

 * Some old versions of bash do not grok some constructs like
   'printf -v varname' which the prompt and completion code started
   to use recently.  The completion and prompt scripts have been
   adjusted to work better with these old versions of bash.

 * In FreeBSD's and NetBSD's "sh", a return in a dot script in a
   function returns from the function, not only in the dot script,
   breaking "git rebase" on these platforms (regression introduced
   in 1.8.4-rc1).

 * "git rebase -i" and other scripted commands were feeding a
   random, data dependant error message to 'echo' and expecting it
   to come out literally.

 * Setting the "submodule.<name>.path" variable to the empty
   "true" caused the configuration parser to segfault.

 * Output from "git log --full-diff -- <pathspec>" looked strange
   because comparison was done with the previous ancestor that
   touched the specified <pathspec>, causing the patches for paths
   outside the pathspec to show more than the single commit has
   changed.

 * The auto-tag-following code in "git fetch" tries to reuse the
   same transport twice when the serving end does not cooperate and
   does not give tags that point to commits that are asked for as
   part of the primary transfer.  Unfortunately, Git-aware transport
   helper interface is not designed to be used more than once, hence
   this did not work over smart-http transfer.  Fixed.

 * Send a large request to read(2)/write(2) as a smaller but still
   reasonably large chunks, which would improve the latency when the
   operation needs to be killed and incidentally works around broken
   64-bit systems that cannot take a 2GB write or read in one go.

 * A ".mailmap" file that ends with an incomplete line, when read
   from a blob, was not handled properly.

 * The recent "short-cut clone connectivity check" topic broke a
   shallow repository when a fetch operation tries to auto-follow
   tags.

 * When send-email comes up with an error message to die with upon
   failure to start an SSL session, it tried to read the error
   string from a wrong place.

 * A call to xread() was used without a loop to cope with short
   read in the codepath to stream large blobs to a pack.

 * On platforms with fgetc() and friends defined as macros, the
   configuration parser did not compile.

 * New versions of MediaWiki introduced a new API for returning
   more than 500 results in response to a query, which would cause
   the MediaWiki remote helper to go into an infinite loop.

 * Subversion's serf access method (the only one available in
   Subversion 1.8) for http and https URLs in skelta mode tells its
   caller to open multiple files at a time, which made "git svn
   fetch" complain that "Temp file with moniker 'svn_delta' already
   in use" instead of fetching.


Also contains a handful of trivial code clean-ups, documentation
updates, updates to the test suite, etc.

----------------------------------------------------------------

Changes since v1.8.4 are as follows:

Andreas Schwab (1):
      Documentation/git-merge.txt: fix formatting of example block

Benoit Person (1):
      git-remote-mediawiki: bugfix for pages w/ >500 revisions

Brandon Casey (3):
      git-completion.bash: use correct Bash/Zsh array length syntax
      t9902-completion.sh: old Bash still does not support array+=('') notation
      contrib/git-prompt.sh: handle missing 'printf -v' more gracefully

Jeff King (2):
      config: do not use C function names as struct members
      mailmap: handle mailmap blobs without trailing newlines

Jharrod LaFon (1):
      avoid segfault on submodule.*.path set to an empty "true"

Johannes Sixt (1):
      stream_to_pack: xread does not guarantee to read all requested bytes

Jonathan Nieder (1):
      Git 1.8.4.1

Junio C Hamano (6):
      t5802: add test for connect helper
      fetch: rename file-scope global "transport" to "gtransport"
      fetch: refactor code that prepares a transport
      fetch: refactor code that fetches leftover tags
      fetch: work around "transport-take-over" hack
      Start preparing for 1.8.4.1

Kyle J. McKay (3):
      Git.pm: add new temp_is_locked function
      git-svn: allow git-svn fetching to work using serf
      Git.pm: revert _temp_cache use of temp_is_locked

Matthieu Moy (2):
      die_with_status: use "printf '%s\n'", not "echo"
      rebase: fix run_specific_rebase's use of "return" on FreeBSD

Nguyễn Thái Ngọc Duy (1):
      fetch-pack: do not remove .git/shallow file when --depth is not specified

Ralf Thielow (1):
      l10n: de.po: use "das Tag" instead of "der Tag"

Ramsay Allan Jones (1):
      builtin/fetch.c: Fix a sparse warning

Sebastien Helleu (1):
      l10n: fr.po: hotfix for commit 6b388fc

Steffen Prohaska (2):
      xread, xwrite: limit size of IO to 8MB
      Revert "compat/clipped-write.c: large write(2) fails on Mac OS X/XNU"

Tay Ray Chuan (1):
      t7406-submodule-update: add missing &&

Thomas Rast (2):
      log: use true parents for diff even when rewriting
      log: use true parents for diff when walking reflogs

Thorsten Glaser (1):
      fix shell syntax error in template

brian m. carlson (1):
      send-email: don't call methods on undefined values

