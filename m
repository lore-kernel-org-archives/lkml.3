Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbaKPMjk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:39:40 -0500
Received: from mail-oi0-f42.google.com ([209.85.218.42]:37012 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbaKPMji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:39:38 -0500
MIME-Version: 1.0
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Sun, 16 Nov 2014 10:39:17 -0200
Message-ID: <CAKi4VA+awT3PRzyb_c9dx0i2+1=ud1boH_nNVBZJAMCrDKkFWg@mail.gmail.com>
Subject: [ANNOUNCE] kmod 19
To: linux-modules <linux-modules@vger.kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmod 19 is out:

        ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-19.tar.xz
        ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-19.tar.sign

This release includes small fixes and moving code to make it more
reliable and smaller. It's particularly important for use with systemd
217 since it adds a feature to static-nodes that is required by this
version of systemd.

- Bug fixes:
        - Fix missing CLOEXEC in library
        - Fix error message while opening kmod's index

- New features:
        - Add kmod(8) man page
        - Allow to build with libc's without be32toh()
        - Move code around separating common code and data structures into a
          shared directory. This allows to share more code between library and
          tools, making the binary size of tools smaller.
        - Clarify tools vs library licenses
        - static-nodes: when writing in tmpfiles format, indicate that
          creation of static nodes should only happen at boot. This is used and
          required by systemd-217+.

- Improvements to testsuite:
        - Add tests for newly created shared/ code
        - Improve how tests are declared so there's less boilerplate code for
          each test.


Shortlog is below:

Cristian Rodríguez (1):
      Add missing O_CLOEXEC in kmod_module_get_size()

Holger Obermaier (1):
      libkmod-index.c: Fix error message

Lucas De Marchi (35):
      Update TODO
      Move macro.h to shared directory
      Move missing.h to shared directory
      Move generic util functions to shared directory
      build-sys: normalize line breaks
      Move array implementation to shared directory
      Move hash implementation to shared directory
      Reorder and reorganize header files
      Prefer inttypes.h over stdint.h
      Rename getline_wrapped() to freadline_wrapped()
      Clarify what licences apply where
      testsuite: add tests for array implementation
      Do not export array of kmod extensions
      Do not rely on prio_to_str() being always inline
      Move alias_normalize() to shared
      depmod: use alias_normalize() from shared
      Move remaining functions from libkmod-util to shared
      build-sys: rename libkmod-util convenience library
      Log error on failed underscores(), moving it to shared/
      Change parameter from int to char
      libkmod: remove unused inline functions
      Move static keyword to DEFINE_TEST macro
      testsuite: use a section to put tests in instead of array
      testsuite: remove now unused array of tests
      Move strbuf implementation to shared/
      shared: rename prefixes of strbuf functions
      testsuite: add tests for strbuf
      strbuf: reduce default buffer size
      strbuf: do not calculate next step in size on all calls
      strbuf: make strbuf_pushchars() a little less dumb
      libkmod-index: keep index and comments in .c
      depmod: point to documentation in libkmod
      libkmod-index: remove invalid comment
      libkmod-index: move comment to include the includes
      kmod 19

Marco d'Itri (2):
      Document depmod --show in depmod(8)
      Add the man page for kmod(8)

Randy MacLeod (1):
      Add back-up implementation of be32toh()

Tom Gundersen (1):
      static-nodes: indicate that creation of static nodes should only
happen at boot

-- 
Lucas De Marchi
