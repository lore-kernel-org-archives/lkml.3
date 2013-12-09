Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481Ab3LIE1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 23:27:53 -0500
Received: from qmta06.westchester.pa.mail.comcast.net ([76.96.62.56]:41145
	"EHLO qmta06.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760402Ab3LIE1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 23:27:50 -0500
To: mpatocka@redhat.com, peter@hurleysoftware.com, gregkh@linuxfoundation.org,
        jslaby@suse.cz
CC: linux-kernel@vger.kernel.org
From: Karl Dahlke <eklhad@comcast.net>
Reply-to: Karl Dahlke <eklhad@comcast.net>
References: <alpine.LRH.2.02.1312082127020.19329@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: edbrowse/3.4.9
Subject: [PATCH 3.12] Broken terminal due to echo bufferring
Date: Sun, 08 Dec 2013 23:26:14 -0500
Message-ID: <20131108232614.eklhad@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I discovered that kernel 3.12 has broken terminal handling.
> I created this program to show the problem:
> ...

This is very likely the same bug I reported, with subject:

Bug in tty cooked mode kernel 3.12.3

You don't have to write a program for it, just put bash into cooked mode.
I demonstrated the bug by switching consoles and hitting return,
assuming bash has been placed in cooked mode.
It's very repeatable this way, not so random.
Switch console,hit return, the prompt is on the same line as the previous prompt.
It affects every cooked mode program, and of course your compiled program 
comes up in cooked mode.
It is cooked echo crlf that is the issue.
Programs in raw mode, like ash default in readline mode,
vi, emacs, etc,are ok.
So you don't see it right away.

See the thread with the aforementioned subject line.

I have applied two separate patches hoping to fix this problem,
but it remains.

Karl Dahlke
