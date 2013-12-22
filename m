Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab3LVVug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 16:50:36 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:61869 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab3LVVuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 16:50:22 -0500
MIME-Version: 1.0
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Sun, 22 Dec 2013 19:50:00 -0200
Message-ID: <CAKi4VAKfaMwe6kiP0mqcRwZ5Y_sL858q0ue85VAbcsNAEx=VYA@mail.gmail.com>
Subject: [ANNOUNCE] kmod 16
To: linux-modules <linux-modules@vger.kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmod 16 is out:

ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-16.tar.xz
ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-16.tar.sign

Most important change besides the bug fixes are:

 * we don't have an option in rmmod to wait module removal anymore.
This is gone from kernel and now is gone from kmod too. The constant
KMOD_REMOVE_NOWAIT in libkmod is still there for backward
compatibility but it's always enforced, passing O_NONBLOCK to
delete_module(2).

 * warn on wrong devname specification in depmod to help kernel
developers catch the bug earlier.

Shortlog is below.


Lucas De Marchi

---

Anders Olofsson (1):
      build: Allow disabling maintainer mode

John Spencer (1):
      testsuite: fix usage of reserved names

Lucas De Marchi (19):
      Fix usage of readdir_r()
      build: remove check for typeof
      util: Add ALIGN_POWER2
      libkmod-hash: always align n_buckets to power of 2
      libkmod: always pass O_NONBLOCK to kernel
      rmmod: remove --wait option
      NEWS: add entries
      build-sys: enable colored diagnostics if available
      testsuite: Move test-alias to test-util
      util: Add cleanup attribute
      config: Use _cleanup_free_
      util: use _cleanup_free_ on path_make_absolute_cwd()
      testsuite: add basic test for getline_wrapped
      util: Be OOM-safe and use _cleanup_free_
      array: avoid duplicate code to reallocate
      file: use _cleanup_free_
      module: use _cleanup_free and remove useless call to free()
      Use C11's noreturn
      kmod 16

Saul Wold (2):
      Makefile.am: Add target to all cross-compilation of testsuite
      Makefile.am: add mkdir testsuite

Thomas Petazzoni (1):
      Add configure check for _Static_assert()

Tom Gundersen (1):
      depmod: warn on invalid devname specification
