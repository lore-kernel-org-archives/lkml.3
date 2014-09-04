Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaIDFUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 01:20:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37196 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaIDFUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 01:20:40 -0400
Date: Thu, 4 Sep 2014 07:20:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: hpa@zytor.com, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org, Zhang Yang <yang.z.zhang@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v4] x86, hotplug: fix llc shared map unreleased during
 cpu hotplug
Message-ID: <20140904052034.GA29146@gmail.com>
References: <1406625883-4972-1-git-send-email-wanpeng.li@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406625883-4972-1-git-send-email-wanpeng.li@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wanpeng Li <wanpeng.li@linux.intel.com> wrote:

> BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
> IP: [..] find_busiest_group
> PGD 5a9d5067 PUD 13067 PMD 0
> Oops: 0000 [#3] SMP
> [...]
> Call Trace:
> load_balance
> ? _raw_spin_unlock_irqrestore
> idle_balance
> __schedule
> schedule
> schedule_timeout
> ? lock_timer_base
> schedule_timeout_uninterruptible
> msleep
> lock_device_hotplug_sysfs
> online_store
> dev_attr_store
> sysfs_write_file
> vfs_write
> SyS_write
> system_call_fastpath
> 
> Last level cache shared map is built during cpu up and build sched domain 
> routine takes advantage of it to setup sched domain cpu topology, however, 
> llc shared map is unreleased during cpu disable which lead to invalid sched 
> domain cpu topology. This patch fix it by release llc shared map correctly
> during cpu disable.

Very little is said in this changelog about how the bug was 
found, how likely it is to occur for others, what systems are 
affected, etc.

Thanks,

	Ingo
