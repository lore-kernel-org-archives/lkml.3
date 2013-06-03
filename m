Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab3FCJl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:41:57 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:46695 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab3FCJlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:41:55 -0400
MIME-Version: 1.0
In-Reply-To: <51AC5827.4040801@st.com>
References: <1369993439-24216-1-git-send-email-srinivas.kandagatla@st.com>
 <1369993501-24309-1-git-send-email-srinivas.kandagatla@st.com>
 <CAGsJ_4xqGZVL7ZsYx1gpeUVoQan4hn=05_v51Kar78Vdkz0hig@mail.gmail.com> <51AC5827.4040801@st.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 3 Jun 2013 17:41:34 +0800
Message-ID: <CAGsJ_4wEvAeUy3gLkBCoYPAMmbQEsxT0wLDcA4-aELnRx0ivag@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] ARM:prima2: move sirfsoc_of_rstc_init to .init_early
To: srinivas.kandagatla@st.com
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Barry Song <baohua.song@csr.com>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Srinivas,

2013/6/3 Srinivas KANDAGATLA <srinivas.kandagatla@st.com>:
> Hi Barry,
> Thanks for testing,
> I think this patch introduced a sequencing issue.
>
> Just re-looking at the code, is there any reason for this to be
> init_earlycall? And do a ioremap at that early stage?
>
> Can't we move it to device_init level function "sirfsoc_mach_init()" at
> which it will be safe to do a ioremap with all mm setup finished?
>

i think it is ok as actually we wanted the reset controller module
ready before any users need it. the users include gps, graphics, usb
and some other peripheral drivers.
now they are actually initialized after init_machine().

>
> Thanks,
> srini
>
> On 03/06/13 03:19, Barry Song wrote:
>> this broke SiRF by:
>> Uncompressing Linux... done, booting the kernel.
>> [    0.000000] Booting Linux on physical CPU 0x0
>> [    0.000000] Linux version 3.10.0-rc2-00723-gd1a0472-dirty
>> (barry@barry-laptop) (gcc version 4.5.4 20110505 (prerelease)
>> (Ubuntu/Linaro 4.5-2011.5-csr-build) ) #35 SMP PREEMPT Mon Jun 3
>> 09:51:59 CST 2013
>> [    0.000000] CPU: ARMv7 Processor [413fc090] revision 0 (ARMv7), cr=10c53c7d
>> [    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing
>> instruction cache
>> [    0.000000] Machine: Generic ATLAS6 (Flattened Device Tree), model:
>> CSR SiRFatlas6 Evaluation Board
>> [    0.000000] bootconsole [earlycon0] enabled
>> [    0.000000] Memory policy: ECC disabled, Data cache writealloc
>> [    0.000000] Unable to handle kernel NULL pointer dereference at
>> virtual address 00000000
>> [    0.000000] pgd = c0004000
>> [    0.000000] [00000000] *pgd=00000000
>> [    0.000000] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
>> [    0.000000] Modules linked in:
>> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted
>> 3.10.0-rc2-00723-gd1a0472-dirty #35
>> [    0.000000] task: c05cfb40 ti: c05c4000 task.ti: c05c4000
>> [    0.000000] PC is at kmem_cache_alloc+0x2c/0x124
>> [    0.000000] LR is at __get_vm_area_node.clone.26+0x7c/0x190
>

-barry
