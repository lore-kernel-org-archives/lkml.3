Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaGPWC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 18:02:29 -0400
Received: from smtp.pobox.com ([208.72.237.35]:62721 "EHLO smtp.pobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbaGPWC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 18:02:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=S4Y1244ec6iXXCRiAlO
	TsW+iDn5hPzyYz3WAbDW2OL60fuDBiq0O/1ic3vL67RTBu3ZpIWzNriV2cXP8/3O
	YajThPw1hphlXiCOmP1/a2geDSO77LbY9K5Sy9btP+GxaWCVu05T9nemV51yB/dT
	PavjazbQ0W+8UUYWc6inxyug=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v2.0.2
Date: Wed, 16 Jul 2014 15:02:16 -0700
Message-ID: <xmqqsim1q7x3.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: DB0A319E-0D34-11E4-AD0D-9903E9FBB39C-77302942!pb-smtp0.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git v2.0.2 is now available at
the usual places.

The tarballs are found at:

    https://www.kernel.org/pub/software/scm/git/

The following public repositories all have a copy of the 'v2.0.2'
tag and the 'maint' branch that the tag points at:

  url = https://kernel.googlesource.com/pub/scm/git/git
  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Git v2.0.2 Release Notes
========================

 * Documentation for "git submodule sync" forgot to say that the subcommand
   can take the "--recursive" option.

 * Mishandling of patterns in .gitignore that has trailing SPs quoted
   with backslashes (e.g. ones that end with "\ ") have been
   corrected.

 * Recent updates to "git repack" started to duplicate objects that
   are in packfiles marked with .keep flag into the new packfile by
   mistake.

 * "git clone -b brefs/tags/bar" would have mistakenly thought we were
   following a single tag, even though it was a name of the branch,
   because it incorrectly used strstr().

 * "%G" (nothing after G) is an invalid pretty format specifier, but
   the parser did not notice it as garbage.

 * Code to avoid adding the same alternate object store twice was
   subtly broken for a long time, but nobody seems to have noticed.

 * A handful of code paths had to read the commit object more than
   once when showing header fields that are usually not parsed.  The
   internal data structure to keep track of the contents of the commit
   object has been updated to reduce the need for this double-reading,
   and to allow the caller find the length of the object.

 * During "git rebase --merge", a conflicted patch could not be
   skipped with "--skip" if the next one also conflicted.

----------------------------------------------------------------

Changes since v2.0.1 are as follows:

Jeff King (27):
      repack: do not accidentally pack kept objects by default
      repack: respect pack.writebitmaps
      repack: s/write_bitmap/&s/ in code
      commit_tree: take a pointer/len pair rather than a const strbuf
      replace dangerous uses of strbuf_attach
      alloc: include any-object allocations in alloc_report
      commit: push commit_index update into alloc_commit_node
      do not create "struct commit" with xcalloc
      logmsg_reencode: return const buffer
      sequencer: use logmsg_reencode in get_message
      provide a helper to free commit buffer
      provide a helper to set the commit buffer
      provide helpers to access the commit buffer
      use get_cached_commit_buffer where appropriate
      use get_commit_buffer to avoid duplicate code
      convert logmsg_reencode to get_commit_buffer
      use get_commit_buffer everywhere
      commit-slab: provide a static initializer
      commit: convert commit->buffer to a slab
      commit: record buffer length in cache
      reuse cached commit buffer when parsing signatures
      t7510: stop referring to master in later tests
      t7510: test a commit signed by an unknown key
      t7510: check %G* pretty-format output
      pretty: avoid reading past end-of-string with "%G"
      move "%G" format test from t7510 to t6006
      t7300: repair filesystem permissions with test_when_finished

Junio C Hamano (4):
      t0008: do not depend on 'echo' handling backslashes specially
      builtin/clone.c: detect a clone starting at a tag correctly
      Start preparing for 2.0.2
      Git 2.0.2

Matthew Chen (1):
      submodule: document "sync --recursive"

Michael J Gruber (1):
      t7510: use consistent &&-chains in loop

Pasha Bolokhov (1):
      dir.c:trim_trailing_spaces(): fix for " \ " sequence

René Scharfe (2):
      sha1_file: avoid overrunning alternate object base string
      annotate: use argv_array

Ronnie Sahlberg (1):
      enums: remove trailing ',' after last item in enum

brian m. carlson (1):
      rebase--merge: fix --skip with two conflicts in a row

