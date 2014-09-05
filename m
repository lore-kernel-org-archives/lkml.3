Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaIEXqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 19:46:05 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:63732 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaIEXqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 19:46:04 -0400
MIME-Version: 1.0
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Fri, 5 Sep 2014 19:45:31 -0400
Message-ID: <CAJhHMCCDPe_GGDWUF3OHQieCKLty2+TaYZwnKjK9ZF3z0auo8A@mail.gmail.com>
Subject: Question reg. asm/qrwlock.h
To: Waiman.Long@hp.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Waiman,

I see that in arch/x86/include/asm/qrwlock.h, there is this snippet within

#ifndef CONFIG_X86_PPRO_FENCE
#define queue_write_unlock queue_write_unlock
static inline void queue_write_unlock(struct qrwlock *lock)
{
        barrier();
        ACCESS_ONCE(*(u8 *)&lock->cnts) = 0;
}
#endif


I've been trying to understand why this special case is necessary for
PPRO. Could you please explain?

Thanks!
-- 
Pranith
