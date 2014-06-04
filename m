Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbaFDTIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:08:36 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:20283 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaFDTIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:08:35 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        tim.c.chen@linux.intel.com, peter@hurleysoftware.com, riel@redhat.com,
        hpa@zytor.com, walken@google.com, davidlohr@hp.com, Waiman.Long@hp.com,
        aswin@hp.com, scott.norton@hp.com, chegu_vinod@hp.com,
        jason.low2@hp.com
Subject: [RFC PATCH 0/3] locking/mutex: Modifications to mutex
Date: Wed,  4 Jun 2014 12:08:28 -0700
Message-Id: <1401908911-8947-1-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains modifications to mutex.

Patch 1 further reduces unnecessary atomic xchg() operations upon entering
the mutex slowpath in mutex_lock().

Patch 2 corrects/updates the documentation on mutex optimistic spinning.

Patch 3 optimizes mutex trylock slowpath.

Jason Low (3):
  mutex: Try to acquire mutex only if it is unlocked
  mutex: Correct documentation on mutex optimistic spinning
  mutex: Optimize mutex trylock slowpath

 kernel/locking/mutex.c |   47 ++++++++++++++++++++++++++---------------------
 1 files changed, 26 insertions(+), 21 deletions(-)

