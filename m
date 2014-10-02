Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaJBMiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:38:54 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:46568 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751219AbaJBMiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:38:52 -0400
Message-ID: <542D4756.4030100@hurleysoftware.com>
Date: Thu, 02 Oct 2014 08:38:46 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Fengguang Wu <fengguang.wu@intel.com>
CC: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [rfcomm_run] WARNING: CPU: 1 PID: 79 at kernel/sched/core.c:7156
 __might_sleep()
References: <20140930080228.GD9561@wfg-t540p.sh.intel.com> <20141002110927.GE2849@worktop.programming.kicks-ass.net> <20141002123150.GC6324@worktop.programming.kicks-ass.net>
In-Reply-To: <20141002123150.GC6324@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 08:31 AM, Peter Zijlstra wrote:
> On Thu, Oct 02, 2014 at 01:09:27PM +0200, Peter Zijlstra wrote:
>> On Tue, Sep 30, 2014 at 04:02:28PM +0800, Fengguang Wu wrote:
>>> Hi Peter,
>>>
>>> We possibly find a rfcomm bug (maintainers CCed) exposed by your debug patch
>>>
>>> [    1.861895] NET: Registered protocol family 5
>>> [    1.862978] Bluetooth: RFCOMM TTY layer initialized
>>> [    1.863099] ------------[ cut here ]------------
>>> [    1.863105] WARNING: CPU: 1 PID: 79 at kernel/sched/core.c:7156 __might_sleep+0x17d/0x1a1()
>>> [    1.863112] do not call blocking ops when !TASK_RUNNING; state=1 set at [<c14dc381>] rfcomm_run+0xdf/0x130e
>>> [    1.863591]  [<c1058b73>] ? kthread_stop+0x53/0x53
>>> [    1.864906]  [<c155a411>] dump_stack+0x48/0x60
>>> [    1.866298]  [<c14dc381>] ? rfcomm_run+0xdf/0x130e
>>
>> Ha yes, rfcomm_run is a complete buggy mess indeed. Lemme go see what I
>> can make of it.
> 
> ---
> Subject: rfcomm: Fix broken wait construct
> 
> rfcomm_run() is a tad broken in that is has a nested wait loop. One
> cannot rely on p->state for the outer wait because the inner wait will
> overwrite it.
> 
> While at it, rename rfcomm_schedule to rfcomm_wake, since that is what
> it actually does.

rfcomm_schedule() as in schedule_work(), which is how it's used.

Regards,
Peter Hurley

