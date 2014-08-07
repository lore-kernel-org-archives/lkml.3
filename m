Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbaHGUxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 16:53:23 -0400
Received: from natalenko.name ([78.47.77.148]:49610 "EHLO natalenko.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231AbaHGUxV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 16:53:21 -0400
DMARC-Filter: OpenDMARC Filter v1.2.0 natalenko.name DEE29A5A4
Authentication-Results: mail.natalenko.name; dmarc=none header.from=natalenko.name
From: Oleksandr Natalenko <oleksandr@natalenko.name>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Subject: Re: [BUG] oops in cpufreq driver with AMD Kaveri CPU
Date: Thu, 07 Aug 2014 23:53:17 +0300
Message-ID: <2651364.4shODVy8cx@spock>
User-Agent: KMail/4.13.3 (Linux/3.15.0-pf5; KDE/4.13.3; x86_64; ; )
In-Reply-To: <4708675.eITUXPv8Ih@spock>
References: <4708675.eITUXPv8Ih@spock>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disabling cpufreq code in kernel config works around this issue.

Is this bug related to sleeping in atomic context, which is caused by improper 
GFP_KERNEL usage instead of GFP_ATOMIC? Should I test tat patch, or there will 
be another fix?

On Tuesday 05 August 2014 00:39:11 Oleksandr Natalenko wrote:
> Hello.
> 
> Occasionally I get my machine hung completely. Fortunately, I've got and
> saved oops listing using netconsole before hang, and here it is [1].
> 
> Here is little piece of oops from the link above:
> 
> ===
> [15051.270461] BUG: unable to handle kernel paging request at
> 00000000ff5ae8e4 [15051.271583] IP: [<ffffffff8109ae6e>]
> srcu_notifier_call_chain+0xe/0x20 …
> [15051.956205] Call Trace:
> [15051.980641]  [<ffffffff81606085>] ?
> __cpufreq_notify_transition+0x95/0x1e0 [15052.005640]  [<ffffffff816081ee>]
> cpufreq_notify_transition+0x3e/0x70 [15052.030240]  [<ffffffff816083d8>]
> cpufreq_freq_transition_begin+0xe8/0x130 [15052.054522] 
> [<ffffffff813b8940>] ? ucs2_strncmp+0x70/0x70
> [15052.078208]  [<ffffffff816089bf>] __target_index+0xbf/0x1a0
> [15052.101348]  [<ffffffff81608b9c>] __cpufreq_driver_target+0xfc/0x160
> [15052.124250]  [<ffffffff8160b0d4>] od_check_cpu+0xa4/0xb0
> [15052.146789]  [<ffffffff8160c9ec>] dbs_check_cpu+0x16c/0x1c0
> [15052.168935]  [<ffffffff8160b4dd>] od_dbs_timer+0x11d/0x180
> [15052.190607]  [<ffffffff8108e6ff>] process_one_work+0x17f/0x4c0
> [15052.211825]  [<ffffffff8108f46b>] worker_thread+0x11b/0x3f0
> [15052.232490]  [<ffffffff8108f350>] ? create_and_start_worker+0x80/0x80
> [15052.253127]  [<ffffffff81096479>] kthread+0xc9/0xe0
> [15052.273292]  [<ffffffff810963b0>] ? flush_kthread_worker+0xb0/0xb0
> [15052.293487]  [<ffffffff81793efc>] ret_from_fork+0x7c/0xb0
> [15052.313544]  [<ffffffff810963b0>] ? flush_kthread_worker+0xb0/0xb0
> …
> ===
> 
> Also here is my lspci [2] and cpuinfo [3] as well.
> 
> Vanilla 3.15.8 and 3.16.0 are affected as well as latest Ubuntu 3.13 kernel.
> 
> No visible reason to trigger the bug. After hang machine doesn't respond via
> network, there's no disk IO, and also it doesn't respond to pressing power
> button in order to perform soft off.
> 
> [1] https://gist.github.com/085af9da81197faf6637
> [2] https://gist.github.com/318ebda5576b099590b8
> [3] https://gist.github.com/9c1307463c7ad6835b2d
-- 
Oleksandr post-factum Natalenko, MSc
pf-kernel community
https://natalenko.name/
