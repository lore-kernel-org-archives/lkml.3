Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbaFYVaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 17:30:17 -0400
Received: from smtp.pobox.com ([208.72.237.35]:62980 "EHLO smtp.pobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866AbaFYVaN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 17:30:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=SuQLrjn3JitNkx8xVbQ
	mIKysGlKsQoT+Od95C5ElYQh0iY9BQ9KnlDqAzgip68Ikx8O1GBAuLfa1oVsqiOA
	Y24NBO00ysVL0uZUB4cscloFoA1TAwmL4lyAy79Nj4vVo3aOBA6aDTpZegQnB4y0
	59NTUS5MbqkHgBle1EgPbT/k=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v2.0.1
Date: Wed, 25 Jun 2014 14:19:34 -0700
Message-ID: <xmqqegyc7k4j.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: DC7810EA-FCAF-11E3-BAD9-9903E9FBB39C-77302942!pb-smtp0.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Git v2.0.1, the first maintenance release for Git v2.0, is now
available at the usual places.  This contains most of the fixes
already merged on the 'master' front in preparation for the v2.1
release.

The tarballs are found at:

    https://www.kernel.org/pub/software/scm/git/

The following public repositories all have a copy of the 'v2.0.1'
tag and the 'maint' branch that the tag points at:

  url = https://kernel.googlesource.com/pub/scm/git/git
  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Git v2.0.1 Release Notes
========================

 * We used to unconditionally disable the pager in the pager process
   we spawn to feed out output, but that prevented people who want to
   run "less" within "less" from doing so.

 * Tools that read diagnostic output in our standard error stream do
   not want to see terminal control sequence (e.g. erase-to-eol).
   Detect them by checking if the standard error stream is connected
   to a tty.
 * Reworded the error message given upon a failure to open an existing
   loose object file due to e.g. permission issues; it was reported as
   the object being corrupt, but that is not quite true.

 * "git log -2master" is a common typo that shows two commits starting
   from whichever random branch that is not 'master' that happens to
   be checked out currently.

 * The "%<(10,trunc)%s" pretty format specifier in the log family of
   commands is used to truncate the string to a given length (e.g. 10
   in the example) with padding to column-align the output, but did
   not take into account that number of bytes and number of display
   columns are different.

 * The "mailmap.file" configuration option did not support the tilde
   expansion (i.e. ~user/path and ~/path).

 * The completion scripts (in contrib/) did not know about quite a few
   options that are common between "git merge" and "git pull", and a
   couple of options unique to "git merge".

 * "--ignore-space-change" option of "git apply" ignored the spaces
   at the beginning of line too aggressively, which is inconsistent
   with the option of the same name "diff" and "git diff" have.

 * "git blame" miscounted number of columns needed to show localized
   timestamps, resulting in jaggy left-side-edge of the source code
   lines in its output.

 * "git blame" assigned the blame to the copy in the working-tree if
   the repository is set to core.autocrlf=input and the file used CRLF
   line endings.

 * "git commit --allow-empty-message -C $commit" did not work when the
   commit did not have any log message.

 * "git diff --find-copies-harder" sometimes pretended as if the mode
   bits have changed for paths that are marked with assume-unchanged
   bit.

 * "git format-patch" did not enforce the rule that the "--follow"
   option from the log/diff family of commands must be used with
   exactly one pathspec.

 * "git gc --auto" was recently changed to run in the background to
   give control back early to the end-user sitting in front of the
   terminal, but it forgot that housekeeping involving reflogs should
   be done without other processes competing for accesses to the refs.

 * "git grep -O" to show the lines that hit in the pager did not work
   well with case insensitive search.  We now spawn "less" with its
   "-I" option when it is used as the pager (which is the default).

 * We used to disable threaded "git index-pack" on platforms without
   thread-safe pread(); use a different workaround for such
   platforms to allow threaded "git index-pack".

 * The error reporting from "git index-pack" has been improved to
   distinguish missing objects from type errors.

 * "git mailinfo" used to read beyond the end of header string while
   parsing an incoming e-mail message to extract the patch.

 * On a case insensitive filesystem, merge-recursive incorrectly
   deleted the file that is to be renamed to a name that is the same
   except for case differences.

 * "git pack-objects" unnecessarily copied the previous contents when
   extending the hashtable, even though it will populate the table
   from scratch anyway.

 * "git rerere forget" did not work well when merge.conflictstyle
   was set to a non-default value.

 * "git remote rm" and "git remote prune" can involve removing many
   refs at once, which is not a very efficient thing to do when very
   many refs exist in the packed-refs file.

 * "git log --exclude=<glob> --all | git shortlog" worked as expected,
   but "git shortlog --exclude=<glob> --all", which is supposed to be
   identical to the above pipeline, was not accepted at the command
   line argument parser level.

 * The autostash mode of "git rebase -i" did not restore the dirty
   working tree state if the user aborted the interactive rebase by
   emptying the insn sheet.

 * "git show -s" (i.e. show log message only) used to incorrectly emit
   an extra blank line after a merge commit.

 * "git status", even though it is a read-only operation, tries to
   update the index with refreshed lstat(2) info to optimize future
   accesses to the working tree opportunistically, but this could
   race with a "read-write" operation that modify the index while it
   is running.  Detect such a race and avoid overwriting the index.

 * "git status" (and "git commit") behaved as if changes in a modified
   submodule are not there if submodule.*.ignore configuration is set,
   which was misleading.  The configuration is only to unclutter diff
   output during the course of development, and should not to hide
   changes in the "status" output to cause the users forget to commit
   them.

 * The mode to run tests with HTTP server tests disabled was broken.

----------------------------------------------------------------

Changes since v2.0.0 are as follows:

Alexey Shumkin (5):
      t4205 (log-pretty-formats): don't hardcode SHA-1 in expected outputs
      t4041, t4205, t6006, t7102: don't hardcode tested encoding value
      t4205 (log-pretty-format): use `tformat` rather than `format`
      t4205, t6006: add tests that fail with i18n.logOutputEncoding set
      pretty.c: format string with truncate respects logOutputEncoding

David Turner (2):
      merge-recursive.c: fix case-changing merge bug
      mv: allow renaming to fix case on case insensitive filesystems

Felipe Contreras (1):
      rerere: fix for merge.conflictstyle

Jacek Konieczny (1):
      pull: do not abuse 'break' inside a shell 'case'

Jeff King (7):
      commit: do not complain of empty messages from -C
      index-pack: distinguish missing objects from type errors
      run_diff_files: do not look at uninitialized stat data
      open_sha1_file: report "most interesting" errno
      move "--follow needs one pathspec" rule to diff_setup_done
      t5537: re-drop http tests
      update-index: fix segfault with missing --cacheinfo argument

Jens Lehmann (2):
      status/commit: show staged submodules regardless of ignore config
      commit -m: commit staged submodules regardless of ignore config

Jens Lindström (3):
      remote rm: delete remote configuration as the last
      remote: repack packed-refs once when deleting multiple refs
      remote prune: optimize "dangling symref" check/warning

Jiang Xin (2):
      blame: fix broken time_buf paddings in relative timestamp
      blame: dynamic blame_date_width for different locales

Johannes Schindelin (1):
      git grep -O -i: if the pager is 'less', pass the '-I' option

John Keeping (2):
      completion: add a note that merge options are shared
      completion: add missing options for git-merge

Junio C Hamano (5):
      apply --ignore-space-change: lines with and without leading whitespaces do not match
      Git 1.9.4
      shortlog: allow --exclude=<glob> to be passed
      revision: parse "git log -<count>" more carefully
      Git 2.0.1

Jörn Engel (1):
      pager: do allow spawning pager recursively

Matthieu Moy (1):
      rebase -i: test "Nothing to do" case with autostash

Max Kirillov (1):
      git-show: fix 'git show -s' to not add extra terminator after merge commit

Michael Naumov (1):
      sideband.c: do not use ANSI control sequence on non-terminal

Nguyễn Thái Ngọc Duy (2):
      index-pack: work around thread-unsafe pread()
      gc --auto: do not lock refs in the background

Nick Alcock (1):
      t5538: move http push tests out to t5542

Ramkumar Ramachandra (1):
      rebase -i: handle "Nothing to do" case with autostash

René Scharfe (2):
      mailinfo: use strcmp() for string comparison
      pack-objects: use free()+xcalloc() instead of xrealloc()+memset()

Yiannis Marangos (2):
      wrapper.c: add xpread() similar to xread()
      read-cache.c: verify index file before we opportunistically update it

brian m. carlson (1):
      blame: correctly handle files regardless of autocrlf

Øystein Walle (1):
      config: respect '~' and '~user' in mailmap.file

