Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab3HWIju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 04:39:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743Ab3HWIjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 04:39:48 -0400
From: Frantisek Hrbata <fhrbata@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jstancek@redhat.com, keescook@chromium.org, peter.oberparleiter@de.ibm.com,
        rusty@rustcorp.com.au, linux-arch@vger.kernel.org, arnd@arndb.de,
        mgahagan@redhat.com, agospoda@redhat.com
Subject: [RFC PATCH 0/4] add support for gcov format introduced in gcc 4.7
Date: Fri, 23 Aug 2013 10:39:32 +0200
Message-Id: <1377247176-13537-1-git-send-email-fhrbata@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an attempt to bring support for modified gcov format in gcc 4.7 to
the kernel. It tries to leverage the existing layout/abstraction, which was
designed keeping in mind that the gcov format could change, but some changes had
to be make. Mostly because the current model does not take into account that
even the core gcov structures, like gcov_info, could change. One part that could
be problematic is the addition of the .init_array section for constructors.

Tested with lcov and seems to be working fine, giving similar results as for the
older format.

Frantisek Hrbata (4):
  gcov: move gcov structs definitions to a gcc version specific file
  gcov: add support for gcc 4.7 gcov format
  gcov: compile specific gcov implementation based on gcc version
  kernel: add support for init_array constructors

 include/asm-generic/vmlinux.lds.h |   1 +
 include/linux/module.h            |   2 +
 kernel/gcov/Makefile              |   5 +-
 kernel/gcov/base.c                |  32 +-
 kernel/gcov/fs.c                  |  27 +-
 kernel/gcov/gcc_3_4.c             | 115 +++++++
 kernel/gcov/gcc_4_7.c             | 612 ++++++++++++++++++++++++++++++++++++++
 kernel/gcov/gcov.h                |  65 +---
 kernel/module.c                   |   6 +
 9 files changed, 784 insertions(+), 81 deletions(-)
 create mode 100644 kernel/gcov/gcc_4_7.c

-- 
1.8.3.1

