Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab3GUMOj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 08:14:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542Ab3GUMOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 08:14:38 -0400
Date: Sun, 21 Jul 2013 15:14:29 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: module unloading hangs after using ftrace with 3.11.0-rc1
Message-ID: <20130721121428.GH20379@redhat.com>
References: <20130721115215.GG20379@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130721115215.GG20379@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 21, 2013 at 02:52:16PM +0300, Gleb Natapov wrote:
> Hi Steven,
> 
> After tracing KVM using trace-cmd with kvm trace points enables I tried
> to unload kvm modules and rmmod hanged in tracing_reset_all_online_cpus:
> 
> [ 1234.665038] rmmod           D 00000000ffffffff     0  7819   7664 0x00000000
> [ 1234.665038]  ffff880129661d38 0000000000000086 ffff880374c7b4d0 ffff880129661fd8
> [ 1234.665038]  0000000000004000 0000000000012a40 ffff88017af63180 ffff880179fe3180
> [ 1234.665038]  ffff880129661c78 ffffffff810ad4f9 0000000000000008 0000000000000002
> [ 1234.665038] Call Trace:
> [ 1234.665038]  [<ffffffff810ad4f9>] ? rcu_is_cpu_idle+0x38/0x57
> [ 1234.665038]  [<ffffffff81139e51>] ? d_set_d_op+0xb5/0xb5
> [ 1234.665038]  [<ffffffff813afbcc>] schedule+0x64/0x66
> [ 1234.665038]  [<ffffffff813afe9a>] schedule_preempt_disabled+0x18/0x24
> [ 1234.665038]  [<ffffffff813ae900>] __mutex_lock_slowpath+0x156/0x1c2
> [ 1234.665038]  [<ffffffff813adbad>] mutex_lock+0x18/0x29
> [ 1234.665038]  [<ffffffff810bfaad>] tracing_reset_all_online_cpus+0x12/0x49
> [ 1234.665038]  [<ffffffff810cd105>] trace_module_notify+0x27b/0x2a2
> [ 1234.665038]  [<ffffffff81060aab>] notifier_call_chain+0x37/0x63
> [ 1234.665038]  [<ffffffff81060be9>] __blocking_notifier_call_chain+0x4b/0x60
> [ 1234.665038]  [<ffffffff81060c12>] blocking_notifier_call_chain+0x14/0x16
> [ 1234.665038]  [<ffffffff8108cf62>] SyS_delete_module+0x228/0x274
> [ 1234.665038]  [<ffffffff813b1d82>] system_call_fastpath+0x16/0x1b
> 
> I haven't verified how reproducible this is yet.
> 
Happens every time.

--
			Gleb.
