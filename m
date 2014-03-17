Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaCQUd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 16:33:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51405 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaCQUdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 16:33:55 -0400
MIME-Version: 1.0
Date: Mon, 17 Mar 2014 20:33:54 +0000
Message-ID: <CACoUkn4muyjm6LyWYjSyZuxVVqk7qnWr3h=+Xdx-mLWxHdLoBw@mail.gmail.com>
Subject: execve and /proc/PID/environ
From: Paul Jolly <paul@myitcv.org.uk>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi - this is my first post here so I hope I'm duly abiding by the
etiquette outlined in [1]. Indeed I am not subscribed to the list and
so would be very grateful to be copied on any replies, per ADB's
comment in [2]

I am trying to build a fuse-based file system that implements a
version of variant symlinks [3]

Ignoring the expense of such a file system (for now at least), I've
hit upon an issue that I think relates to [4]

My fuse-based file system works by examining the environment of the
calling process in order to resolve the 'symlink'. If however that
process is performing an execve [5] with a filename argument that
corresponds to a file within my file system, I essentially hit
deadlock because I can't perform an open [6] on the /proc/PID/environ
of the calling process.

Perhaps someone can confirm the behaviour I am seeing is as expected?

In this instance (where an execve is in progress), is there any way to
get the environ of the calling process?

For reference:

$ uname -s -r -v -m -p -i -o
Linux 3.11.0-18-generic #32-Ubuntu SMP Tue Feb 18 21:11:14 UTC 2014
x86_64 x86_64 x86_64 GNU/Linux

Many thanks


[1] http://www.tux.org/lkml/#s3-1
[2] http://www.tux.org/lkml/#s3-3
[3] https://wiki.freebsd.org/200808DevSummit?action=AttachFile&do=get&target=variant-symlinks-for-freebsd.pdf
[4] https://lkml.org/lkml/2012/3/10/174
[5] http://man7.org/linux/man-pages/man2/execve.2.html
[6] http://man7.org/linux/man-pages/man2/open.2.html
