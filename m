Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaCXVT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 17:19:58 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:63714 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaCXVTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 17:19:54 -0400
MIME-Version: 1.0
Date: Mon, 24 Mar 2014 17:19:53 -0400
Message-ID: <CAPuLQKxoc3Gk3_xKetSOzFLg5s36P3MJ7Jy=15_JmwYp2J_v+g@mail.gmail.com>
Subject: Futex Question (64 bits?)
From: Ryan Nicholl <r.p.nicholl@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ryan Nicholl <r.p.nicholl@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to know if it would be possible to use a 64 bit futex
call? If not, I would like to request it be added. (It is acknowledged
in the manpages that it must be added eventually anyway.)

I am programming a C++11+ library. One of the constructed features is
a "locking pointer". Unfortunately, pointers are usually 64 bits,
while the futex call supports only 32 bits. I could not discover any
documented way to invoke a 64 bit futex call.

It's unfortunate in that the futex call must have a timeout set
because of the possible deadlock condition where only the half of the
pointer not futexed is modified between the time the system call is
entered and executed.

This creates a situation that prevents the locking_ptr from being
realtime safe unless the timeout is set at a very low value.
Furthermore, this causes excess CPU usage due to spurious wakeups.

Thank you,
Ryan Nicholl
