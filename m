Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbbALX5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:57:36 -0500
Received: from pb-smtp1.int.icgroup.com ([208.72.237.35]:53341 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751489AbbALX5d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:57:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=DIV3+8bB6LppFiUy1io
	3nd6vwIGU6iZ7MSx/WI5t7/h9JElP/T75uix0srqsdA9kmDG6TjZuECJXCD2bJLw
	1Vz2b9S+V6CGhMMCnfQ9Bqb/TgNlNTiXREiVOAvpEALcSA2i9vbrt5hTufrHMmfC
	PZGJBxuca1HaPIjwpYMui3t4=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v2.2.2
Date: Mon, 12 Jan 2015 15:57:31 -0800
Message-ID: <xmqqlhl75z84.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: C61E30AE-9AB6-11E4-91DD-42529F42C9D4-77302942!pb-smtp1.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git v2.2.2 is now available at
the usual places.

This backports many fixes that were not in 2.2.1 that have been used
on 'master' for the past few weeks.

The tarballs are found at:

    https://www.kernel.org/pub/software/scm/git/

The following public repositories all have a copy of the 'v2.2.2'
tag and the 'maint' branch that the tag points at:

  url = https://kernel.googlesource.com/pub/scm/git/git
  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Git v2.2.2 Release Notes
========================

Fixes since v2.2.1
------------------

 * "git checkout $treeish $path", when $path in the index and the
   working tree already matched what is in $treeish at the $path,
   still overwrote the $path unnecessarily.

 * "git config --get-color" did not parse its command line arguments
   carefully.

 * open() emulated on Windows platforms did not give EISDIR upon
   an attempt to open a directory for writing.

 * A few code paths used abs() when they should have used labs() on
   long integers.

 * "gitweb" used to depend on a behaviour recent CGI.pm deprecated.

 * "git init" (hence "git clone") initialized the per-repository
   configuration file .git/config with x-bit by mistake.

 * Git 2.0 was supposed to make the "simple" mode for the default of
   "git push", but it didn't.

 * "Everyday" document had a broken link.

 * The build procedure did not bother fixing perl and python scripts
   when NO_PERL and NO_PYTHON build-time configuration changed.

 * The code that reads the reflog from the newer to the older entries
   did not handle an entry that crosses a boundary of block it uses to
   read them correctly.

 * "git apply" was described in the documentation to take --ignore-date
   option, which it does not.

 * Traditionally we tried to avoid interpreting date strings given by
   the user as future dates, e.g. GIT_COMMITTER_DATE=2014-12-10 when
   used early November 2014 was taken as "October 12, 2014" because it
   is likely that a date in the future, December 10, is a mistake.
   This heuristics has been loosened to allow people to express future
   dates (most notably, --until=<date> may want to be far in the
   future) and we no longer tiebreak by future-ness of the date when

    (1) ISO-like format is used, and
    (2) the string can make sense interpreted as both y-m-d and y-d-m.

   Git may still have to use the heuristics to tiebreak between dd/mm/yy
   and mm/dd/yy, though.

 * The code to abbreviate an object name to its short unique prefix
   has been optimized when no abbreviation was requested.

 * "git add --ignore-errors ..." did not ignore an error to
   give a file that did not exist.

 * Git did not correctly read an overlong refname from a packed refs
   file.

Also contains typofixes, documentation updates and trivial code clean-ups.

----------------------------------------------------------------

Changes since v2.2.1 are as follows:

Alexander Kuleshov (1):
      clean: typofix

Jeff King (17):
      pass TIME_DATE_NOW to approxidate future-check
      checkout $tree: do not throw away unchanged index entries
      approxidate: allow ISO-like dates far in the future
      Makefile: have perl scripts depend on NO_PERL setting
      t0090: mark add-interactive test with PERL prerequisite
      t960[34]: mark cvsimport tests as requiring perl
      gitweb: hack around CGI's list-context param() handling
      docs: describe ANSI 256-color mode
      config: fix parsing of "git config --get-color some.key -1"
      t4026: test "normal" color
      push: truly use "simple" as default, not "upstream"
      for_each_reflog_ent_reverse: fix newlines on block boundaries
      for_each_reflog_ent_reverse: turn leftover check into assertion
      read_packed_refs: use a strbuf for reading lines
      read_packed_refs: pass strbuf to parse_ref_line
      read_packed_refs: use skip_prefix instead of static array
      is_hfs_dotgit: loosen over-eager match of \u{..47}

Johannes Sixt (1):
      Windows: correct detection of EISDIR in mingw_open()

Jonathan Nieder (2):
      Makefile: simplify by using SCRIPT_{PERL,SH}_GEN macros
      Makefile: have python scripts depend on NO_PYTHON setting

Junio C Hamano (2):
      Prepare for 2.2.2
      Git 2.2.2

Michael Haggerty (1):
      create_default_files(): don't set u+x bit on $GIT_DIR/config

Michael J Gruber (1):
      add: ignore only ignored files

Mike Hommey (1):
      sha1_name: avoid unnecessary sha1 lookup in find_unique_abbrev

René Scharfe (2):
      use labs() for variables of type long instead of abs()
      use labs() for variables of type long instead of abs()

Ronald Wampler (1):
      git-am.txt: --ignore-date flag is not passed to git-apply

brian m. carlson (1):
      Documentation: change "gitlink" typo in git-push

