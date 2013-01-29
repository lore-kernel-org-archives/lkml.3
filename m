Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab3A2BNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:13:44 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:8715 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3A2BNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:13:42 -0500
Message-ID: <5107220D.6000606@huawei.com>
Date: Tue, 29 Jan 2013 09:12:45 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Clark Williams <williams@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] sched: move scheduler sysctl bits into dedicated
 header file
References: <20130128143120.1b60bfb6@redhat.com>
In-Reply-To: <20130128143120.1b60bfb6@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -extern void sched_autogroup_create_attach(struct task_struct *p);
> -extern void sched_autogroup_detach(struct task_struct *p);
> -extern void sched_autogroup_fork(struct signal_struct *sig);
> -extern void sched_autogroup_exit(struct signal_struct *sig);
> -#ifdef CONFIG_PROC_FS
> -extern void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m);
> -extern int proc_sched_autogroup_set_nice(struct task_struct *p, int nice);
> -#endif
> -#else
> -static inline void sched_autogroup_create_attach(struct task_struct *p) { }
> -static inline void sched_autogroup_detach(struct task_struct *p) { }
> -static inline void sched_autogroup_fork(struct signal_struct *sig) { }
> -static inline void sched_autogroup_exit(struct signal_struct *sig) { }
> -#endif

but those function declarations have nothing to do with sysctl..

> -
> -#ifdef CONFIG_CFS_BANDWIDTH
> -extern unsigned int sysctl_sched_cfs_bandwidth_slice;
> -#endif
> -

