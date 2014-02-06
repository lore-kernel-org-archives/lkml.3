Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbaBFKDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 05:03:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:14129 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755695AbaBFKDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 05:03:00 -0500
X-IronPort-AV: E=Sophos;i="4.95,792,1384272000"; 
   d="scan'208";a="9476703"
Message-ID: <52F35E71.3030105@cn.fujitsu.com>
Date: Thu, 06 Feb 2014 18:05:37 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Wen Congyang <wency@cn.fujitsu.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Tang Chen <imtangchen@gmail.com>,
        Tang Chen <tangchen@cn.fujitsu.com>
Subject: Re: WARNING: at arch/x86/kernel/smpboot.c:324 topology_sane()
References: <20140206094428.GC17971@localhost>
In-Reply-To: <20140206094428.GC17971@localhost>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/06 18:01:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/06 18:01:10,
	Serialize complete at 2014/02/06 18:01:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 05:44 PM, Fengguang Wu wrote:
> Hi Tang,
>
> We noticed the below warning and the first bad commit is
>
> commit e8d1955258091e4c92d5a975ebd7fd8a98f5d30f
> Author:     Tang Chen<tangchen@cn.fujitsu.com>
> AuthorDate: Fri Feb 22 16:33:44 2013 -0800
> Commit:     Linus Torvalds<torvalds@linux-foundation.org>
> CommitDate: Sat Feb 23 17:50:14 2013 -0800
>
>      acpi, memory-hotplug: parse SRAT before memblock is ready

Hi Wu,

This patch has been droped a long time ago. It is not in the latest kernel.

Now the memory hotplug implementation is done in a different way.

Thanks.


>
>   arch/x86/kernel/setup.c | 13 +++++++++----
>   arch/x86/mm/numa.c      |  6 ++++--
>   drivers/acpi/numa.c     | 23 +++++++++++++----------
>   include/linux/acpi.h    |  8 ++++++++
>   4 files changed, 34 insertions(+), 16 deletions(-)
>
> [    0.845092] smpboot: Booting Node   1, Processors  #1
> [    0.864812] masked ExtINT on CPU#1
> [    0.868706] CPU1: Thermal LVT vector (0xfa) already installed
> [    0.875158] ------------[ cut here ]------------
> [    0.880330] WARNING: at arch/x86/kernel/smpboot.c:324 topology_sane.isra.2+0x6b/0x7c()
> [    0.891505] Hardware name: S2600CP
> [    0.895314] sched: CPU #1's llc-sibling CPU #0 is not on the same node! [node: 1 != 0]. Ignoring dependency.
>
> [    0.906295] Modules linked in:
> [    0.909927] Pid: 0, comm: swapper/1 Not tainted 3.8.0-06530-ge8d1955 #1
> [    0.917314] Call Trace:
> [    0.920055]  [<ffffffff81970409>] ? topology_sane.isra.2+0x6b/0x7c
> [    0.926963]  [<ffffffff810bcd5d>] warn_slowpath_common+0x81/0x99
> [    0.933667]  [<ffffffff810bcdc1>] warn_slowpath_fmt+0x4c/0x4e
> [    0.940092]  [<ffffffff8196b565>] ? calibrate_delay+0xae/0x4ba
> [    0.946612]  [<ffffffff810508ea>] ? __mcheck_cpu_init_timer+0x4a/0x4f
> [    0.953799]  [<ffffffff81970409>] topology_sane.isra.2+0x6b/0x7c
> [    0.960509]  [<ffffffff819706e0>] set_cpu_sibling_map+0x28c/0x43a
> [    0.967308]  [<ffffffff81970a3c>] start_secondary+0x1ae/0x276
> [    0.973742] ---[ end trace db722b2086ba6d20 ]---
> [    0.999234]  OK
> [    1.001655] smpboot: Booting Node   0, Processors  #2
>
> Full dmesg and kconfig are attached.
>
> Thanks,
> Fengguang
