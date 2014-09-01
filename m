Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaIAVTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 17:19:10 -0400
Received: from message.mylangara.bc.ca ([142.35.159.25]:47035 "EHLO
	message.langara.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaIAVTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 17:19:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
To: linux-kernel@vger.kernel.org
Message-id: <fc0cb509956.5404e2cc@langara.bc.ca>
Date: Mon, 01 Sep 2014 21:19:08 +0000 (GMT)
X-Mailer: Sun Java(tm) System Messenger Express 6.3-6.03 (built Mar 14 2008;
 32bit)
Content-language: en
Subject: How is pivot_root intended to be used?
X-Accept-Language: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am not confused about how I can currently use pivot_root for
containers on my kernel (version 3.13). Currently a sequence like:

    if (-1 == syscall(__NR_pivot_root, ".", ".")) {
        perror("pivot_root");
        return EXIT_FAILURE;
    }

    if (-1 == umount2(".", MNT_DETACH)) {
        perror("umount");
        return EXIT_FAILURE;
    }

    /* pivot_root() may or may not affect its current working
     * directory.  It is therefore recommended to call chdir("/")
     * immediately after pivot_root().
     *
     * - http://man7.org/linux/man-pages/man2/pivot_root.2.html
     */
    if (-1 == chdir("/")) {
        perror("chdir");
        return EXIT_FAILURE;
    }

works. However, I am completely and totally confused about how the
pivot_root system call is intended to be used here and have absolutely
no idea if this will work in the future. This concerns me because I
don't want my program to potentially develop silent security bugs on
future versions of the Linux kernel.

Some information about the context. I am sandboxing a program just
after it has done a fork, unshared the mount namespace, setup a
sandbox directory and changed into it. If you just want to look at the
code, the actual code is avaliable at
https://gitorious.org/linted/linted/source/b25685ba4762bfb794c8f36ae74276d32d2b0ca8:src/spawn/spawn.c.

Thank you,
Steven Stewart-Gallus
