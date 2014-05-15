Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbaEOO2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:28:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbaEOO17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:27:59 -0400
Date: Thu, 15 May 2014 16:27:24 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: WARN in do_rt_tgsigqueueinfo()
Message-ID: <20140515142723.GB22041@mguzik.redhat.com>
References: <20140515133834.GN13658@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140515133834.GN13658@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 03:38:34PM +0200, Peter Zijlstra wrote:
> Hi Thomas, Oleg,
> 
> 
> trinity$ MALLOC_CHECK_=0 ./trinity -xinit_module -xreboot -xshutdown -xunshare -xnfsservctl -xclock_nanosleep -xuselib -xumount -xmount -m --quiet -C 400 -l off -xmremap
> 
> [watchdog] kernel became tainted! (512/0) Last seed was 4072360471
> 
> [15908.562512] ------------[ cut here ]------------
> [15908.567245] WARNING: CPU: 22 PID: 3312 at /usr/src/linux-2.6/kernel/signal.c:3060 do_rt_tgsigqueueinfo+0xb4/0xc0()
> [15908.577715] Modules linked in:
> [15908.580857] CPU: 22 PID: 3312 Comm: trinity-c198 Not tainted 3.15.0-rc5-01700-g505011124ad0-dirty #1070
> [15908.590412] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/08/2010
> [15908.597228]  0000000000000009 ffff880428715e40 ffffffff81682052 0000000000000000
> [15908.604834]  ffff880428715e78 ffffffff8109808c 0000000000000001 000000000000ffff
> [15908.612402]  00000000efdcefbf 00000000efdcefbf 0000000000000129 ffff880428715e88
> [15908.619941] Call Trace:
> [15908.622423]  [<ffffffff81682052>] dump_stack+0x4e/0x7a
> [15908.627600]  [<ffffffff8109808c>] warn_slowpath_common+0x8c/0xc0
> [15908.633658]  [<ffffffff810980da>] warn_slowpath_null+0x1a/0x20
> [15908.639535]  [<ffffffff810a9914>] do_rt_tgsigqueueinfo+0xb4/0xc0
> [15908.645591]  [<ffffffff810a99f1>] SYSC_rt_tgsigqueueinfo+0x61/0x80
> [15908.651851]  [<ffffffff810abb2e>] SyS_rt_tgsigqueueinfo+0xe/0x10
> [15908.657946]  [<ffffffff8168a842>] system_call_fastpath+0x16/0x1b
> [15908.664036] ---[ end trace 02450728e2526283 ]---
> 
> 
> This is apparently a very common thing to hit according to google.

Well, it warns about an argument received from userland, so nothing fishy
going on as far as kernel consistency is concerned if that's what you mean.

-- 
Mateusz Guzik
