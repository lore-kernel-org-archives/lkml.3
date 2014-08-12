Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbaHLH3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:29:46 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:45258 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaHLH3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:29:44 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Rafael Aquini <aquini@redhat.com>, Rik van Riel <riel@redhat.com>,
        1vier1@web.de, Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 0/3] ipc: Further updates to sysv/mqueue limits
Date: Tue, 12 Aug 2014 09:29:14 +0200
Message-Id: <1407828557-31995-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I got some positive and no negative feedback on my patches, thus:
Could you add the patches to -mm and push them towards Linus?

0001-ipc-msg-increase-MSGMNI-remove-scaling.patch
	- increase MSGMNI to 32000
	- as a bonus, this removes around 300 lines

0002-ipc-sem.c-increase-SEMMSL-SEMMNI-SEMOPM.patch
	- increase all limits
	- update the documentation, it was stale

   Note: Redhat/Oracle recommend values that exceed what I would recommend
   as safe upper limits.
 
https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/5/html/Tuning_and_Optimizing_Red_Hat_Enterprise_Linux_for_Oracle_9i_and_10g_Databases/sect-Oracle_9i_and_10g_Tuning_Guide-Setting_Semaphores-An_Example_of_Semaphore_Settings.html 

   Unfortunately I didn't get any replies, thus I don't know how to proceed.

   One option would be to switch from kmalloc to ipc_alloc, then the risk of
   failing due to memory fragmentation would be resolved.

0003-ipc-namespace-copy-settings-from-parent-namespace.patch
	Change the namespace code so that a new namespace inherits the values
	from it's parent instead of the boot time defaults.

	Serge Hallyn and Michael Kerrisk also consider the new approach as better.
	One thing that is a bit surprising is that clone(CLONE_NEWIPC)k

I've tested the changes both with unshare -i and with my own test apps.
Unfortunately I didn't manage to get lxc to run on my busybox test setup :-(

--
	Manfred
