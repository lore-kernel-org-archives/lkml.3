Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaJFSda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 14:33:30 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:58957 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaJFSd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 14:33:28 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Rafael Aquini <aquini@redhat.com>, Rik van Riel <riel@redhat.com>,
        1vier1@web.de, Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 0/3] Misc updates to sysv ipc
Date: Mon,  6 Oct 2014 20:32:40 +0200
Message-Id: <1412620363-2759-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I've updated the patches based on the feedback I got.
Could you include them in your tree and forward them to Linus?
I consider them as ready for merging.

0001-ipc-sem.c-Chance-memory-barrier-in-sem_lock-to-smp_r.patch
	When I rewrote sem_lock(), I was more conservative than
	necessary: smp_rmb() is sufficient.

0002-ipc-sem.c-increase-SEMMSL-SEMMNI-SEMOPM.patch
	- increase all limits
	- update the documentation, it was stale

0003-ipc-msg-increase-MSGMNI-remove-scaling.patch
	- increase MSGMNI to 32000
	- as a bonus, this removes around 300 lines
	- keep auto_msgmni, but document it as deprecated.

I've dropped:
	ipc-namespace-copy-settings-from-parent-namespace.patch

	- user space must handle the old logic anyway.
	- it could break userspace

--
	Manfred
