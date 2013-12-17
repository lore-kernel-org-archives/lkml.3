Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab3LQX5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 18:57:19 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:42930 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab3LQX5R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 18:57:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=kEcBP7t/sqkw2K2515v
	QK9aWEChjDWtoc4AjfSll2AXWEO4rNdPKi1EaYHBqsMGdUVAFRI65mEQxuyRDiuK
	GpTs4hTzTcc7w5JybgySbm8ccYxtRrulxMoTHqe+0b47ylcrygIVI7lbix8SNyx+
	XDDEzMBxOR29XpzAIdHYIN3Y=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v1.8.5.2
Date: Tue, 17 Dec 2013 15:57:09 -0800
Message-ID: <xmqqd2kvkp4a.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: F31034D2-6776-11E3-8ADD-1B26802839F8-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git v1.8.5.2 is now available at
the usual places.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

3a09d6d5d4e31c702f17e664a527b4c2f6e84faf  git-1.8.5.2.tar.gz
eaf2e3cfd07c1b88eff688fc3ba79dd4f3f2bc43  git-htmldocs-1.8.5.2.tar.gz
54450c09138b8d65c5f9d2b19ca86fd63c645bb5  git-manpages-1.8.5.2.tar.gz

The following public repositories all have a copy of the v1.8.5.2
tag and the maint branch that the tag points at:

  url = https://kernel.googlesource.com/pub/scm/git/git
  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Also, http://www.kernel.org/pub/software/scm/git/ has copies of the
release tarballs (they are recompressed over there and they have
checksums different from the above list).


Git v1.8.5.2 Release Notes
==========================

Fixes since v1.8.5.1
--------------------

 * "git diff -- ':(icase)makefile'" was unnecessarily rejected at the
   command line parser.

 * "git cat-file --batch-check=ok" did not check the existence of
   the named object.

 * "git am --abort" sometimes complained about not being able to write
   a tree with an 0{40} object in it.

 * Two processes creating loose objects at the same time could have
   failed unnecessarily when the name of their new objects started
   with the same byte value, due to a race condition.

Also contains typofixes, documentation updates and trivial code clean-ups.

----------------------------------------------------------------

Changes since v1.8.5.1 are as follows:

Jason St. John (6):
      Documentation/git-log: update "--log-size" description
      Documentation/git-log.txt: mark-up fix and minor rephasing
      State correct usage of literal examples in man pages in the coding standards
      Documentation/rev-list-options.txt: fix mark-up
      Documentation/rev-list-options.txt: fix some grammatical issues and typos
      Documentation/gitcli.txt: fix double quotes

Jeff King (1):
      unpack-trees: fix "read-tree -u --reset A B" with conflicted index

Johan Herland (1):
      sha1_file.c:create_tmpfile(): Fix race when creating loose object dirs

Junio C Hamano (4):
      t1005: reindent
      t1005: add test for "read-tree --reset -u A B"
      sha1_loose_object_info(): do not return success on missing object
      Git 1.8.5.2

Masanari Iida (3):
      typofixes: fix misspelt comments
      Documentation/technical/http-protocol.txt: typofixes
      contrib: typofixes

Michael Haggerty (1):
      cmd_repack(): remove redundant local variable "nr_packs"

Nguyễn Thái Ngọc Duy (2):
      diff: restrict pathspec limitations to diff b/f case only
      glossary-content.txt: fix documentation of "**" patterns

René Scharfe (1):
      SubmittingPatches: document how to handle multiple patches

Thomas Rast (1):
      Documentation: revamp git-cherry(1)

Torsten Bögershausen (1):
      git-fetch-pack uses URLs like git-fetch

