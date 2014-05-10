Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaEJKDm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 06:03:42 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:60565 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaEJKDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 06:03:40 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, 1vier1@web.de,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 0/6] ipc/sem.c: Fix semctl(,,{GETNCNT,GETZCNT})
Date: Sat, 10 May 2014 12:03:13 +0200
Message-Id: <1399716199-26776-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

According to the man page of semop(), semzcnt or semncnt are increased
exactly for the operation that couldn't proceed.

The Linux implementation always tried to be clever and to increase the counters
for all operations that might be the reason why a task sleeps.

The following patches fix that and make the code conform to the 
documentation.

The series got fairly long, because I also noticed that semzcnt was calculated
incorrectly.

What do you think?
I ran a few test cases, and the semncnt and semzcnt counts now match
the expectation.

Is anyone aware of an application that uses GETNCNT or GETZCNT?

--
	Manfred
