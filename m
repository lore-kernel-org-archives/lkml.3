Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaFEIA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 04:00:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:59321 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbaFEIA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 04:00:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="351330422"
Message-ID: <53902398.70005@linux.intel.com>
Date: Thu, 05 Jun 2014 16:00:24 +0800
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Liu ShuoX <shuox.liu@intel.com>
CC: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Zhang Yanmin <yanmin.zhang@intel.com>
Subject: Re: [PATCH] perf: fix kernel panic when parsing user space CS saved
 in pt_regs
References: <20140605023610.GA12905@lskakaxi-intel> <20140605071919.GD3213@twins.programming.kicks-ass.net> <20140605073321.GA14869@lskakaxi-intel> <20140605075507.GA6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140605075507.GA6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/5 15:55, Peter Zijlstra wrote:
> On Thu, Jun 05, 2014 at 03:33:21PM +0800, Liu ShuoX wrote:
>> On Thu  5.Jun'14 at  9:19:19 +0200, Peter Zijlstra wrote:
>>> On Thu, Jun 05, 2014 at 10:36:10AM +0800, Liu ShuoX wrote:
>>>> From: Zhang Yanmin <yanmin.zhang@intel.com>
>>>>
>>>> We hit a kernel panic when running perf to collect some performance data.
>>>> kenel is x86_64 and user space apps are 32bit.
>>>>
>>>> [   71.965351, 1] [       Binder_2] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
>>>> [   71.965360, 1] [       Binder_2] IP: [<ffffffff82012091>] get_segment_base+0x71/0xc0
>>>> [   71.965367, 1] [       Binder_2] PGD 6c65f067 PUD 0
>>>> [   71.965375, 1] [       Binder_2] Oops: 0000 [#1] PREEMPT SMP
>>>> [   71.965413, 1] [       Binder_2] Modules linked in: ddrgx snd_merr_dpcm_wm8958 snd_intel_sst snd_soc_sst_platform snd_soc_wm8994 snd_soc_wm_hubs lm3559 imx1x5 atomisp_css2401a0_v21 libmsrlisthelper rmi4 bcm_bt_lpm videobuf_vmalloc videobuf_core fps_throttle hdmi_audio pn544(O) tngdisp bcm4335(O) cfg80211
>>>> [   71.965420, 1] [       Binder_2] CPU: 1 PID: 304 Comm: Binder_2 Tainted: G        W  O 3.10.20-263902-g184bfbc-dirty #14
>>>> [   71.965426, 1] [       Binder_2] task: ffff8800764dc300 ti: ffff88006c6e8000 task.ti: ffff88006c6e8000
>>>> [   71.965439, 1] [       Binder_2] RIP: 0010:[<ffffffff82012091>]  [<ffffff?f82012091>] get_segment_base+0x71/0xc0
>>>                                                                              ^
>>>> [   71.965<44, 1] [       Binder_2] RSP: 0018:ffff^X8007ea87b98  EFLAGS: 00010092
>>>            ^                                       ^
>>>> [   71.965447, 1] [      !Binder_2] RAX: 0000000000000024 RBX: 0000000000000000 RCX: 0000000000000000
>>>                           ^
>>>> [   71.965450, 1] [       Binder_2] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000009
>>>> [   71.965454, 1] [       Binder_2] RBP: ffff88007ea87ba8 R08: ffffffff83143b3c R09: ffffffff831848a8
>>>> [   71.965458, 1] [       Binder_2] R10: 0000000000000000 R11: 00000000001bf2d8 R12: 0000000000000000
>>>> [   71.965462, 1] [       Binder_2] R13: ffff88006c6e9fd8 R14: ffff88006c6e9f58 R15: ffff8800764dc300
>>>> [   71.965468, 1_ [       Binder_2] FS:  0000000000000000(0000) GS:ffff88007ea80000(006b) knlGS:00000000f704add0
>>>                  ^
>>>
>>> Are you suffering some serious corruption?
>> The log captured by pstore after rebooting, so there are some
>> corruption. Please ignore those.
> Why does pstore cause corruption? I thought that stuff was supposed to
> be 'good' ?
pstore is good if the board is reset by WarmReset as memory content is 
kept across rebooting.
If it's a ColdReset, memory might lose some or all contents. My board 
uses Coldreset, which is a very
fast ColdReset. Most memory content can be kept. But sometimes, some 
data has little change.

Yanmin


