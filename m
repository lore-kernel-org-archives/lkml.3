Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab3KZI5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 03:57:19 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:43476 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab3KZI5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 03:57:17 -0500
Message-ID: <52946261.8020408@hitachi.com>
Date: Tue, 26 Nov 2013 17:57:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [BUG] 3.13-rc1 kernel crash when enable all tracepoints
References: <CAGdX0WFeEuy+DtpsJzyzn0343qEEjLX97+o1VREFkUEhndC+5Q@mail.gmail.com> <5294409F.70508@hitachi.com> <CAGdX0WGVDX9FzBL2tJUTx3oHBPopK74OOrFzThR_7m3GxQUs3Q@mail.gmail.com>
In-Reply-To: <CAGdX0WGVDX9FzBL2tJUTx3oHBPopK74OOrFzThR_7m3GxQUs3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/26 16:20), Jovi Zhangwei wrote:
> I'm not sure this relate with ftrace:function event, from the
> crash log, it seems more like caused by lock events.
> 
> Now I only enable lock events (lockdep compiled in my box), below
> two commands both can crash system.

That is not the lockdep, but the lockstat. :)

> 
> #echo 1 > /sys/kernel/debug/tracing/events/lock/lock_acquire/enable
> or.
> #echo 1 > /sys/kernel/debug/tracing/events/lock/lock_release/enable
> 
> According to the log, it seems like a recursion tracing bug.
> 
> register lock event -> jump_label_update -> text_poke_bp ->
> on_each_cpu -> local_apic_timer_interrupt -> ktime_get_update_offsets
> -> lock_release

OK, the problem is in the lock_acquire/release events.

> (Perhaps the crash you reproduced is another crash? similar crash log?)

Right, that was my mistake. Now I got same error log on kvm too.
This should be fixed.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


