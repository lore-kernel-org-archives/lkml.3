Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbaBEXBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 18:01:21 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:60788 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbaBEXBH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 18:01:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=vetlL4ovlEyxWoa+OmV
	k1bbB/LJHTQqTCHaaBWonQ/r0oltzFXzl5YUNHY/wTQvVfUCYmp6PGDFklEDlAV9
	gt35yDKe1CPxZulKbJeh0/+R8v7Fb80wiuqYERCgRWheMGmCw4dl9F18b+xVrivV
	gQ6dpOM+4HdkPiibLdWSAZP4=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v1.8.5.4
Date: Wed, 05 Feb 2014 15:01:02 -0800
Message-ID: <xmqqeh3h17wx.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 639FD9FA-8EB9-11E3-9B72-1B26802839F8-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git v1.8.5.4 is now available at
the usual places.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

cbf14318ee9652232489982bb2da15d2e5ebb580  git-1.8.5.4.tar.gz
6cfb7f23d2a3493d5b7657cc4558ff791294beb0  git-htmldocs-1.8.5.4.tar.gz
4ee26cf0d2db87b0be21192c4433359b6f38b217  git-manpages-1.8.5.4.tar.gz

The following public repositories all have a copy of the v1.8.5.4
tag and the maint branch that the tag points at:

  url = https://kernel.googlesource.com/pub/scm/git/git
  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Also, http://www.kernel.org/pub/software/scm/git/ has copies of the
release tarballs.

Git v1.8.5.4 Release Notes
==========================

Fixes since v1.8.5.4
--------------------

 * "git fetch --depth=0" was a no-op, and was silently ignored.
   Diagnose it as an error.

 * Remote repository URL expressed in scp-style host:path notation are
   parsed more carefully (e.g. "foo/bar:baz" is local, "[::1]:/~user" asks
   to connect to user's home directory on host at address ::1.

 * SSL-related options were not passed correctly to underlying socket
   layer in "git send-email".

 * "git commit -v" appends the patch to the log message before
   editing, and then removes the patch when the editor returned
   control. However, the patch was not stripped correctly when the
   first modified path was a submodule.

 * "git mv A B/", when B does not exist as a directory, should error
   out, but it didn't.

 * When we figure out how many file descriptors to allocate for
   keeping packfiles open, a system with non-working getrlimit() could
   cause us to die(), but because we make this call only to get a
   rough estimate of how many is available and we do not even attempt
   to use up all file descriptors available ourselves, it is nicer to
   fall back to a reasonable low value rather than dying.

 * "git log --decorate" did not handle a tag pointed by another tag
   nicely.

 * "git add -A" (no other arguments) in a totally empty working tree
   used to emit an error.

 * There is no reason to have a hardcoded upper limit of the number of
   parents for an octopus merge, created via the graft mechanism, but
   there was.

 * The implementation of 'git stash $cmd "stash@{...}"' did not quote
   the stash argument properly and left it split at IFS whitespace.

 * The documentation to "git pull" hinted there is an "-m" option
   because it incorrectly shared the documentation with "git merge".

Also contains typofixes, documentation updates and trivial code clean-ups.

----------------------------------------------------------------

Changes since v1.8.5.3 are as follows:

Jens Lehmann (1):
      commit -v: strip diffs and submodule shortlogs from the commit message

Johannes Schindelin (1):
      Remove the line length limit for graft files

Johannes Sixt (2):
      git_connect: remove artificial limit of a remote command
      git_connect: factor out discovery of the protocol and its parts

Junio C Hamano (4):
      get_max_fd_limit(): fall back to OPEN_MAX upon getrlimit/sysconf failure
      Documentation: exclude irrelevant options from "git pull"
      Documentation: "git pull" does not have the "-m" option
      Git 1.8.5.4

Nguyễn Thái Ngọc Duy (2):
      clone,fetch: catch non positive --depth option value
      add: don't complain when adding empty project root

Roman Kagan (1):
      git-svn: workaround for a bug in svn serf backend

Thomas Rast (3):
      send-email: pass Debug to Net::SMTP::SSL::new
      send-email: --smtp-ssl-cert-path takes an argument
      send-email: set SSL options through IO::Socket::SSL::set_client_defaults

Torsten Bögershausen (8):
      t5601: remove clear_ssh, refactor setup_ssh_wrapper
      t5601: add tests for ssh
      git fetch-pack: add --diag-url
      t5500: add test cases for diag-url
      git fetch: support host:/~repo
      git_connect(): refactor the port handling for ssh
      connect.c: refactor url parsing
      git_connect(): use common return point

brian m. carlson (1):
      log: properly handle decorations with chained tags

Øystein Walle (1):
      stash: handle specifying stashes with $IFS

