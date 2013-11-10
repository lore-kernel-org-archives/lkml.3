Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab3KJTbK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 14:31:10 -0500
Received: from www.linutronix.de ([62.245.132.108]:38307 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab3KJTbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 14:31:02 -0500
Date: Sun, 10 Nov 2013 20:30:59 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.12.0-rt1
Message-ID: <20131110193059.GA7537@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT folks!

I'm pleased to announce the v3.12.0-rt1 patch set.

Changes since v3.10.18-rt14
- updated to v3.12
- dropped SLAB support. It was broken in v3.10 and therefore not available
  for RT. Nobody complained except that it did not compile on !RT. Since
  SLUB performs a little better compared to SLAB and is the default
  allocator I think it is okay to drop SLAB support.
- the PREEMPT_RT Kconfig patches are now very early in the queue.

This is the first release of the v3.12 kernel. It run a couple of days on
powerpc and x86 without an accident :)

Known issues:

      - bcache is disabled.

      - an ancient race (since we got sleeping spinlocks) where the
        TASK_TRACED state is temporary replaced while waiting on a rw
        lock and the task can't be traced.

The RT patch against 3.12 can be found here:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.10/3.12/patch-3.12.0-rt1.patch.xz

The split quilt queue is available at:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.10/3.12/patches-3.12.0-rt1.tar.xz

and it will be moved to the usual location once I able to do so.

Sebastian
