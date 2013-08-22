Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab3HVOG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:06:26 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:38449 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab3HVOGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:06:24 -0400
MIME-Version: 1.0
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Thu, 22 Aug 2013 11:05:58 -0300
Message-ID: <CAKi4VALBexGi3-Tpy=iPywV5RvX1PjyLTst6t4c0pHLwrkcuGg@mail.gmail.com>
Subject: [ANNOUNCE] kmod 15
To: linux-modules <linux-modules@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "systemd-devel@lists.freedesktop.org" 
	<systemd-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-15.tar.xz
ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-15.tar.sign

Hey!

kmod 15 is out.

2 important fixes: one to parse the kernel command line correctly when
there are boolean values and another to static-nodes tool not fail if
modules.devname isn't present (for example inside containers)

The kmod tool (an thus modprobe, lsmod, depmod and all compat tools)
links statically to libkmod now. In kmod 14 we disabled building the
static library because it was causing problems to some projects.
Linking our tool statically to the library is kind of an workaround
for people doing initrd needing their tools to be statically linked.

As usual, shortlog is below.

Cheers
Lucas De Marchi

---

Jan Engelhardt (1):
      depmod: add missing "else" clause

Lucas De Marchi (15):
      tools: Do not link dynamically with libkmod
      Use "-internal" suffix instead of "-private"
      testsuite: Fix mkdir_p corner cases
      util: Add mkdir_p implementation from testsuite
      util: Add len arg to mkdir_p()
      util: Add mkdir_parents()
      README: Move items from TODO
      NEWS: Add entries
      shell-completion: Add initial completion for kmod
      shell-completion: Add kmod static-nodes
      build: Install bash completion data
      shell-completion: Make options accept '=' as last char
      testsuite: Add test for parameter with no value in kcmdline
      libkmod: Fix getting param with no value from kcmdline
      kmod 15

Tom Gundersen (2):
      static-nodes: don't fail if modules.devname not found
      static-nodes: create parent directories of output file
