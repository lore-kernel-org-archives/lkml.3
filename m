Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbaIDHfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 03:35:11 -0400
Received: from message.langara.bc.ca ([142.35.159.25]:53916 "EHLO
	message.langara.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaIDHfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 03:35:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org
Message-id: <faeccadf18ff.5408162c@langara.bc.ca>
Date: Thu, 04 Sep 2014 07:35:08 +0000 (GMT)
X-Mailer: Sun Java(tm) System Messenger Express 6.3-6.03 (built Mar 14 2008;
 32bit)
Content-language: en
Subject: Re: How is pivot_root intended to be used?
X-Accept-Language: en
In-reply-to: <5406202A.30401@amacapital.net>
References: <fc0cb509956.5404e2cc@langara.bc.ca> <5406202A.30401@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you, I think I will change the code to be like:

    int old_root = open("/", O_DIRECTORY);
    if (-1 == old_root) {
        perror("open");
        return EXIT_FAILURE;
    }

    if (-1 == syscall(__NR_pivot_root, ".", ".")) {
        perror("pivot_root");
        return EXIT_FAILURE;
    }

    if (-1 == fchdir(old_root)) {
        perror("fchdir");
        return EXIT_FAILURE;
    }

    if (-1 == umount2(".", MNT_DETACH)) {
        perror("umount");
        return EXIT_FAILURE;
    }

    if (-1 == close(old_root)) {
        perror("close");
        return EXIT_FAILURE;
    }

    if (-1 == chdir("/")) {
        perror("chdir");
        return EXIT_FAILURE;
    }

This seems more understandable to me and less likely to have bugs later on.
