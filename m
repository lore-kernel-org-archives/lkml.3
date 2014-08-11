Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaHKLgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:36:11 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:44440 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaHKLgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:36:10 -0400
MIME-Version: 1.0
From: Manuel Lauss <manuel.lauss@gmail.com>
Date: Mon, 11 Aug 2014 13:35:28 +0200
Message-ID: <CAOLZvyFuDqi4+pEae=n7+ZJoAx-vca-pRS8ZAQqvTk-tSyPiwg@mail.gmail.com>
Subject: MIPS: hang in kmalloc with seccomp writer locks
To: Kees Cook <keescook@chromium.org>
Cc: Linux-MIPS <linux-mips@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

My MIPS32 toys hang early during bootup at the first kmalloc() with
seccomp enabled.
I've bisected it to commit dbd952127d11bb44a4ea30b08cc60531b6a23d71
("seccomp: introduce writer locking").  And indeed, reverting this
commit fixes the hang.

I'm not sure if seccomp is even working on MIPS, but I've never had
problems with
it before so I thought I let you know.

Thanks, and have a nice day!
      Manuel
