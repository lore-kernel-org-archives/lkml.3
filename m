Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab3AUEEI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 23:04:08 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:44817 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab3AUEEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 23:04:07 -0500
MIME-Version: 1.0
From: Mulyadi Santosa <mulyadi.santosa@gmail.com>
Date: Mon, 21 Jan 2013 11:03:26 +0700
Message-ID: <CAGdaadbrcY5QdCtE35Hce7igST_JP82_iPeLRR39Tx5TafB4XA@mail.gmail.com>
Subject: [RFC] kernel config template for running inside virtual machine
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody

With the significant usage of virtualization in recent years, I
personally think there might be a need to easily generate somewhat
more optimal kernel for running as VM guest.

As for the discussion context, let's use KVM.

So far I spot several tunables that can be altered:
- Default HZ --> CONFIG_HZ=100
Using low ticks frequency, timer handler will work less. This will
give more room for user space load inside VM guest.

- No dynamic ticks --> # CONFIG_NO_HZ is not set
theoritically, timer re-arming inside VM is more costly and gets
inside slow path due to different interval programmed based on current
running timers. With no dynamic tick, again we reduce CPU load.

- I/O scheduler --> No-op
It's a great speculation actually. There are people who use entire
partition or entire single logical volume as virtual hard drive, but
the rest is still using regular file (e.g created by dd or qemu-img).
For the latter case, they're still under the mercy of host I/O
scheduler.

The idea here is to push data toward host I/O sub system with less
sorting/merging and let the host do the big job

- Enabling CONFIG_KVM_GUEST. As the related help message says, it
helps with paravirtualized clock


So far, these are things that comes in mind. Any feedback?

PS: processor optimization, choosing slab allocator are next ...



-- 
regards,

Mulyadi Santosa
Freelance Linux trainer and consultant

blog: the-hydra.blogspot.com
training: mulyaditraining.blogspot.com
