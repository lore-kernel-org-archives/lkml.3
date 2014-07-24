Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbaGXMKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:10:31 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36091 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758475AbaGXMK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:10:27 -0400
MIME-Version: 1.0
X-Originating-IP: [67.83.175.92]
Date: Thu, 24 Jul 2014 08:10:25 -0400
Message-ID: <CA+C-WL8FD7hwXPTHdhjbRZ5j0bg3HZ_jgVhX_KoX6GzpjsEmew@mail.gmail.com>
Subject: Requesting help in understanding commit 7cccd8, i.e. disabling
 preemption in slub.c:slab_alloc_node
From: Patrick Palka <patrick@parcs.ath.cx>
To: linux-mm@kvack.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

I am trying to figure out the race condition that commit 7cccd8 fixes.
The commit disables preemption in between the retrieval of the per-cpu
slab and the subsequent read of the slab's tid. According to the
commit message, this change helps avoid allocating from the wrong node
in slab_alloc. But try as I might, I can't see how allocating from the
wrong node, let alone the wrong cpu, could ever happen with or without
preemption. Isn't the globally-unique per-cpu tid the mechanism that's
supposed to guard against allocating from the wrong cpu or node? In
what way does this mechanism fail in slab_alloc_node, and how does
disabling preemption during the retrieval of the tid mitigate this
failure? Would really appreciate if somebody took the time to explain
this to a newbie like me.

Thanks,
Patrick
