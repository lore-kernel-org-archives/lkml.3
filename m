Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934655Ab3DGXz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:55:58 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:60856 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934511Ab3DGXz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:55:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=SAoEcQrt/ZWO2tHuejO
	U9tSYerfvf+jo1wnkUuLsu4RqeREqt5xn/oAywtkZPSr0ejDfZ/UH6/XSDVc0Etd
	l8v2ui0EPnG/rEv6P4p0nkz9Q8OFVknteYhvs64g1tjMJnhNymNM/kbt9DzkbP9E
	yDYX61b0flf4hV3F+9Hj98SM=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v1.8.1.6
Date: Sun, 07 Apr 2013 16:55:53 -0700
Message-ID: <7vehel3ng6.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: AF7660A8-9FDE-11E2-8E28-8341C8FBB9E7-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A maintenance release Git v1.8.1.6 is now available at the
usual places.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

135a4fd6c025ab16560694da110a1476a9b83de2  git-1.8.1.6.tar.gz
a9b004bf1b1922f09cb45a7a388bd452399db30c  git-htmldocs-1.8.1.6.tar.gz
41822cdd469fde30d419819e43ed57f3e73a404b  git-manpages-1.8.1.6.tar.gz

Also the following public repositories all have a copy of the v1.8.1.6
tag and the maint-1.8.1 branch that the tag points at:

  url = https://kernel.googlesource.com/pub/scm/git/git
  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Git 1.8.1.6 Release Notes
=========================

Fixes since v1.8.1.5
--------------------

 * An earlier change to the attribute system introduced at v1.8.1.2 by
   mistake stopped a pattern "dir" (without trailing slash) from
   matching a directory "dir" (it only wanted to allow pattern "dir/"
   to also match).

 * The code to keep track of what directory names are known to Git on
   platforms with case insensitive filesystems can get confused upon a
   hash collision between these pathnames and looped forever.

 * When the "--prefix" option is used to "checkout-index", the code
   did not pick the correct output filter based on the attribute
   setting.

 * Annotated tags outside refs/tags/ hierarchy were not advertised
   correctly to the ls-remote and fetch with recent version of Git.

 * The logic used by "git diff -M --stat" to shorten the names of
   files before and after a rename did not work correctly when the
   common prefix and suffix between the two filenames overlapped.

 * "git update-index -h" did not do the usual "-h(elp)" thing.

 * perl/Git.pm::cat_blob slurped everything in core only to write it
   out to a file descriptor, which was not a very smart thing to do.

 * The SSL peer verification done by "git imap-send" did not ask for
   Server Name Indication (RFC 4366), failing to connect SSL/TLS
   sites that serve multiple hostnames on a single IP.

 * "git bundle verify" did not say "records a complete history" for a
   bundle that does not have any prerequisites.

Also contains various documentation fixes.

----------------------------------------------------------------

Changes since v1.8.1.5 are as follows:

Antoine Pelisse (4):
      update-index: allow "-h" to also display options
      diff: Fix rename pretty-print when suffix and prefix overlap
      tests: make sure rename pretty print works
      perf: update documentation of GIT_PERF_REPEAT_COUNT

Christian Helmuth (1):
      git-commit doc: describe use of multiple `-m` options

Dan Bornstein (1):
      Correct the docs about GIT_SSH.

David Michael (1):
      git-compat-util.h: Provide missing netdb.h definitions

Fredrik Gustafsson (1):
      gitweb/README: remove reference to git.kernel.org

Greg Price (1):
      describe: Document --match pattern format

Jeff King (6):
      avoid segfaults on parse_object failure
      use parse_object_or_die instead of die("bad object")
      pack-refs: write peeled entry for non-tags
      dir.c::match_pathname(): adjust patternlen when shifting pattern
      dir.c::match_pathname(): pay attention to the length of string parameters
      t: check that a pattern without trailing slash matches a directory

Johannes Sixt (1):
      t2003: work around path mangling issue on Windows

John Keeping (3):
      t2003: modernize style
      entry: fix filter lookup
      merge-tree: fix typo in merge-tree.c::unresolved

Joshua Clayton (1):
      Git.pm: fix cat_blob crashes on large files

Junio C Hamano (8):
      imap-send: support Server Name Indication (RFC4366)
      diff-options: unconfuse description of --color
      Documentation: merging a tag is a special case
      attr.c::path_matches(): the basename is part of the pathname
      attr.c::path_matches(): special case paths that end with a slash
      dir.c::match_basename(): pay attention to the length of string parameters
      Start preparing for 1.8.1.6
      Git 1.8.1.6

Kacper Kornet (3):
      rev-parse: clarify documentation of $name@{upstream} syntax
      t1507: Test that branchname@{upstream} is interpreted as branch
      Fix revision walk for commits with the same dates

Karsten Blees (1):
      name-hash.c: fix endless loop with core.ignorecase=true

Kevin Bracey (2):
      Translate git_more_info_string consistently
      git.c: make usage match manual page

Lukas Fleischer (2):
      bundle: Fix "verify" output if history is complete
      bundle: Add colons to list headings in "verify"

Matthias Krüger (1):
      git help config: s/insn/instruction/

Michael Haggerty (2):
      Provide a mechanism to turn off symlink resolution in ceiling paths
      pack-refs: add fully-peeled trait

Mihai Capotă (1):
      git-pull doc: fix grammo ("conflicts" is plural)

Nguyễn Thái Ngọc Duy (4):
      index-format.txt: mention of v4 is missing in some places
      read-cache.c: use INDEX_FORMAT_{LB,UB} in verify_hdr()
      update-index: list supported idx versions and their features
      index-pack: fix buffer overflow caused by translations

René Scharfe (2):
      Makefile: keep LIB_H entries together and sorted
      sha1_name: pass object name length to diagnose_invalid_sha1_path()

Tadeusz Andrzej Kadłubowski (2):
      git-filter-branch.txt: clarify ident variables usage
      Documentation: filter-branch env-filter example

Thomas Rast (2):
      diff: prevent pprint_rename from underrunning input
      git-tag(1): we tag HEAD by default

Torsten Bögershausen (1):
      remote-helpers/test-bzr.sh: do not use "grep '\s'"

W. Trevor King (1):
      Documentation/githooks: Explain pre-rebase parameters



