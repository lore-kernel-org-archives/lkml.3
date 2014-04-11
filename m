Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbaDKS5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:57:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:57996 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbaDKS5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:57:42 -0400
Date: Fri, 11 Apr 2014 20:57:40 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.14-rt1
Message-ID: <20140411185739.GA6644@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT folks!

I'm pleased to announce the v3.14-rt1 patch set.

Changes since v3.12.15-rt25
- I dropped the sparc64 patches I had in the queue. They did not apply
  cleanly, the code in v3.14 changed in the MMU area. Here is where I
  remembered that it was not working perfectly either.

- Scott Wood pointed out that I forgot a return value in the latest
  gianfar fixup for RT. Return value added, thanks Scott.

This -RT series didn't crashed within ~4h testing on my ARM and
x86-32.
x86-64 crashed after I started hackbench. I figured out that the crash
does not happen with lazy-preempt disabled. Therefore the last but one
patch in the queue disables lazy preempt on x86-64. With this change the
test box survived ~2h without a crash. I look at this later but it looks
good now.

I decided to release it now because otherwise it would be lying around
probably the next two weeks or so. So here it is, enjoy.

Known issues:

      - bcache is disabled.

The RT patch against 3.14 can be found here:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.14/patch-3.14.0-rt1.patch.xz

The split quilt queue is available at:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.14/patches-3.14.0-rt1.tar.xz

Sebastian
