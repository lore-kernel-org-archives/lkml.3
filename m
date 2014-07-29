Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaG2R2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 13:28:46 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:53458 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaG2R2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 13:28:45 -0400
Message-ID: <1406654295.2053.0.camel@misato.fc.hp.com>
Subject: Re: [PATCH v4] x86, hotplug: fix llc shared map unreleased during
 cpu hotplug
From: Toshi Kani <toshi.kani@hp.com>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: hpa@zytor.com, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, linux-kernel@vger.kernel.org,
        Zhang Yang <yang.z.zhang@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Tue, 29 Jul 2014 11:18:15 -0600
In-Reply-To: <1406625883-4972-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1406625883-4972-1-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-29 at 17:24 +0800, Wanpeng Li wrote:
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
> 
> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>

The change looks good to me.

Reviewed-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi

