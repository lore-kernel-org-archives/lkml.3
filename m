Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaE2Wt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 18:49:57 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:43563 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaE2Wt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 18:49:56 -0400
MIME-Version: 1.0
Date: Fri, 30 May 2014 00:49:56 +0200
Message-ID: <CA+jWvaKyLPfFb6b-aGCz8RhCCcsSZ+kz5Co3xSKwPOhsguHFMA@mail.gmail.com>
Subject: BUG?: super.c:sget spin_lock not released?
From: Kai <wildex999@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have recently been playing around with writing a custom filesystem
for Linux, and have been reading the source of other filesystems, and
the functions they call into the linux kernel.
While looking at the function sget in super.c I found something strange.

before if(test) it takes a spinlock, however there seems to be two
cases where it does not unlock it.
(Kernel 3.14, super.c line 441)

One:
if(!grab_super(old)) goto retry;
Will jump to before spin_lock(), without releasing it first.

Two:
And if it finds an old sb, it will return without releasing the lock.


This code seems to be the same in 3.14 and in 2.6
I might just be missing how the spin_lock works, and if so I'm sorry.
But this seems really strange to me. Would this not potentially cause
a deadlock on sb_lock?
