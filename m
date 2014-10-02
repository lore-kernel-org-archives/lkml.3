Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaJBLJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 07:09:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:55883 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaJBLJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 07:09:32 -0400
Date: Thu, 2 Oct 2014 13:09:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [rfcomm_run] WARNING: CPU: 1 PID: 79 at kernel/sched/core.c:7156
 __might_sleep()
Message-ID: <20141002110927.GE2849@worktop.programming.kicks-ass.net>
References: <20140930080228.GD9561@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930080228.GD9561@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 04:02:28PM +0800, Fengguang Wu wrote:
> Hi Peter,
> 
> We possibly find a rfcomm bug (maintainers CCed) exposed by your debug patch
> 
> [    1.861895] NET: Registered protocol family 5
> [    1.862978] Bluetooth: RFCOMM TTY layer initialized
> [    1.863099] ------------[ cut here ]------------
> [    1.863105] WARNING: CPU: 1 PID: 79 at kernel/sched/core.c:7156 __might_sleep+0x17d/0x1a1()
> [    1.863112] do not call blocking ops when !TASK_RUNNING; state=1 set at [<c14dc381>] rfcomm_run+0xdf/0x130e
> [    1.863591]  [<c1058b73>] ? kthread_stop+0x53/0x53
> [    1.864906]  [<c155a411>] dump_stack+0x48/0x60
> [    1.866298]  [<c14dc381>] ? rfcomm_run+0xdf/0x130e

Ha yes, rfcomm_run is a complete buggy mess indeed. Lemme go see what I
can make of it.
