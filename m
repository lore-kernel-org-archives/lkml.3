Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbaEEJKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:10:23 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:51536 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398AbaEEJKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:10:21 -0400
Message-ID: <5367553C.1040701@linux.vnet.ibm.com>
Date: Mon, 05 May 2014 14:39:16 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>, rjw@rjwysocki.net, viresh.kumar@linaro.org
CC: ego@linux.vnet.ibm.com, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] cpufreq: Catch double invocations of cpufreq_freq_transition_begin/end
References: <20140505072129.14454.25747.stgit@srivatsabhat.in.ibm.com> <alpine.SOC.1.00.1405051152370.17122@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.1405051152370.17122@math.ut.ee>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050509-2000-0000-0000-0000111FA675
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 02:23 PM, Meelis Roos wrote:
>>
>> Changes in v3:
>> Expanded the comment in the code to briefly mention why ASYNC_NOTIFICATION
>> drivers are left out from the check, as suggested by Gautham R. Shenoy.
>> No code changes in this version.
>>
>> v2: https://lkml.org/lkml/2014/4/29/283
>> v1: https://lkml.org/lkml/2014/4/28/469
> 
> Seems to work on VIA EPIA with 3.15-rc2 (no other cpufreq fixes):
>

Great! Thanks a lot for testing this!

Rafael/Viresh, can you please add Meelis' Tested-by while taking
this patch?

Thank you!

Regards,
Srivatsa S. Bhat
 
> [    8.250959] ------------[ cut here ]------------
> [    8.251179] WARNING: CPU: 0 PID: 116 at drivers/cpufreq/cpufreq.c:367 cpufreq_freq_transition_begin+0xd3/0xd8()
> [    8.251400] Modules linked in: snd_via82xx snd_mpu401_uart longhaul snd_ac97_codec ac97_bus snd_rawmidi snd_seq_device sg snd_pcm snd_timer vt8231 via_rhine uhci_hcd hwmon ehci_hcd tulip i2c_viapro snd evdev soundcore serio_raw sr_mod i2c_core mii usbcore gameport usb_common cdrom parport_pc fan parport via_agp button agpgart processor
> [    8.253465] CPU: 0 PID: 116 Comm: kworker/0:1 Not tainted 3.15.0-rc2-dirty #40
> [    8.253664] Hardware name: VIA TECHNOLOGIES, INC. EPIA/EPIA, BIOS 6.00 PG 11/02/2004
> [    8.253873] Workqueue: events od_dbs_timer
> [    8.254038]  00000000 00000000 cf6afd60 c1283096 cf6afd90 c101ff15 c135a90c 00000000
> [    8.254574]  00000074 c138ccdc 0000016f c11eaaf0 c11eaaf0 cf542000 00061698 cf582c00
> [    8.255118]  cf6afda0 c101ffa8 00000009 00000000 cf6afdd0 c11eaaf0 cf6afdd8 cf6afdf4
> [    8.255661] Call Trace:
> [    8.255815]  [<c1283096>] dump_stack+0x16/0x18
> [    8.255988]  [<c101ff15>] warn_slowpath_common+0x70/0x87
> [    8.256151]  [<c11eaaf0>] ? cpufreq_freq_transition_begin+0xd3/0xd8
> [    8.256316]  [<c11eaaf0>] ? cpufreq_freq_transition_begin+0xd3/0xd8
> [    8.256482]  [<c101ffa8>] warn_slowpath_null+0x1d/0x1f
> [    8.256641]  [<c11eaaf0>] cpufreq_freq_transition_begin+0xd3/0xd8
> [    8.256809]  [<c1036cba>] ? __srcu_notifier_call_chain+0x24/0x93
> [    8.256989]  [<d06c52d5>] longhaul_setstate+0x88/0x2f1 [longhaul]
> [    8.257149]  [<c1036d43>] ? srcu_notifier_call_chain+0x1a/0x1c
> [    8.257315]  [<c11eaad9>] ? cpufreq_freq_transition_begin+0xbc/0xd8
> [    8.257481]  [<d06c55ba>] longhaul_target+0x7c/0x8b [longhaul]
> [    8.257647]  [<c11eaebd>] __cpufreq_driver_target+0xfe/0x148
> [    8.257824]  [<c10540c6>] ? get_cpu_iowait_time_us+0x84/0xa3
> [    8.257981]  [<c11ebe27>] od_check_cpu+0x75/0x79
> [    8.258135]  [<c11ec7a1>] dbs_check_cpu+0xbd/0xc5
> [    8.258286]  [<c11ec813>] ? need_load_eval+0x18/0x79
> [    8.258439]  [<c11ec004>] od_dbs_timer+0x7a/0xd9
> [    8.258612]  [<c102f808>] process_one_work+0x205/0x363
> [    8.258770]  [<c102f7d7>] ? process_one_work+0x1d4/0x363
> [    8.258927]  [<c10300b3>] ? worker_thread+0x27/0x26f
> [    8.259086]  [<c103022c>] worker_thread+0x1a0/0x26f
> [    8.259244]  [<c103008c>] ? rescuer_thread+0x204/0x204
> [    8.259405]  [<c10339e9>] kthread+0xa3/0xa8
> [    8.259567]  [<c1287bc0>] ret_from_kernel_thread+0x20/0x30
> [    8.259726]  [<c1033946>] ? kthread_create_on_node+0x112/0x112
> [    8.259874] ---[ end trace fe16863c964a8bbe ]---
> 

