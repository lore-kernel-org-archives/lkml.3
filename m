Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaERH6v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 03:58:51 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:34526 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaERH6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 03:58:50 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, 1vier1@web.de,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 0/6] ipc/sem.c: Fix semctl(,,{GETNCNT,GETZCNT})
Date: Sun, 18 May 2014 09:58:31 +0200
Message-Id: <1400399917-17583-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I've applied the changes recommended by Michael and Davidlohr - and I don't 
have any open points on my list, either.

Therefore: Could you add the series to -mm and move it towards mainline?

Background:

SUSv4 and the man page of semop() clearly define how semncnt or semzcnt must
be updated: Exactly for the single sop that cannot proceed.

The Linux implementation always tried to be clever and to increase the counters
for all operations that might be the reason why a task sleeps.

The following patches fix that and make the code conform to the standard and
the documentation.

The series got fairly long, because I also noticed that semzcnt was calculated
incorrectly.

--
	Manfred
