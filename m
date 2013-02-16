Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258Ab3BPF0b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 00:26:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:2564 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812Ab3BPF0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 00:26:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,677,1355126400"; 
   d="scan'208";a="263460070"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: RE: [tip:core/locking] Revert "smp: Give WARN()ing if
 in_interrupt()  when calling smp_call_function_many()/single()"
Thread-Topic: [tip:core/locking] Revert "smp: Give WARN()ing if
 in_interrupt()  when calling smp_call_function_many()/single()"
Thread-Index: AQHOCFIzdVcGnIjvBkq+EWVxsga+IJh7+t6Q
Date: Sat, 16 Feb 2013 05:26:25 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A23337D@SHSMSX101.ccr.corp.intel.com>
References: <1360163901.24670.13.camel@cliu38-desktop-build>
 <tip-56624143151fdb84c32a43463864e6c12a5ebcfc@git.kernel.org>
In-Reply-To: <tip-56624143151fdb84c32a43463864e6c12a5ebcfc@git.kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1G5QkI6015142



> -----Original Message-----
> From: tip tree robot [mailto:tipbot@zytor.com] On Behalf Of tip-bot for Ingo
> Molnar
> Sent: Monday, February 11, 2013 8:20 PM
> To: linux-tip-commits@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; hpa@zytor.com; mingo@kernel.org;
> a.p.zijlstra@chello.nl; torvalds@linux-foundation.org;
> akpm@linux-foundation.org; tglx@linutronix.de; Wu, Fengguang; Liu,
> Chuansheng
> Subject: [tip:core/locking] Revert "smp: Give WARN()ing if in_interrupt() when
> calling smp_call_function_many()/single()"
> 
> Commit-ID:  56624143151fdb84c32a43463864e6c12a5ebcfc
> Gitweb:
> http://git.kernel.org/tip/56624143151fdb84c32a43463864e6c12a5ebcfc
> Author:     Ingo Molnar <mingo@kernel.org>
> AuthorDate: Mon, 11 Feb 2013 10:03:29 +0100
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Mon, 11 Feb 2013 10:03:29 +0100
> 
> Revert "smp: Give WARN()ing if in_interrupt() when calling
> smp_call_function_many()/single()"
> 
> This reverts commit b29f39c7c3e75a741a7da88244ec707f293ec04c.
> 
> Fengguang Wu reported that the commit triggers a bogus warning
> on the current networking tree:
> 
> [  229.339945] Call Trace:
> [  229.341176]  [<ffffffff810353b4>] warn_slowpath_common+0x83/0x9c
> [  229.343091]  [<ffffffff817089d6>] ? flow_cache_new_hashrnd+0x98/0x98
> [  229.345105]  [<ffffffff810353e7>] warn_slowpath_null+0x1a/0x1c
> [  229.346978]  [<ffffffff81090793>] smp_call_function_single+0xbd/0x1c7
> [  229.349017]  [<ffffffff81090afe>] smp_call_function_many+0x121/0x23e
> [  229.350996]  [<ffffffff817089d6>] ? flow_cache_new_hashrnd+0x98/0x98
> [  229.353005]  [<ffffffff81090e09>] smp_call_function+0x37/0x40
> [  229.354860]  [<ffffffff8170907e>] flow_cache_flush+0x72/0xa0
> [  229.356735]  [<ffffffff81759e33>] xfrm_dev_event+0x14/0x20
> [  229.358545]  [<ffffffff817ff8b0>] notifier_call_chain+0x65/0x95
> [  229.360469]  [<ffffffff8105ce16>] __raw_notifier_call_chain+0xe/0x10
> [  229.362453]  [<ffffffff8105ce2c>] raw_notifier_call_chain+0x14/0x16
> [  229.364453]  [<ffffffff816f63d6>] call_netdevice_notifiers+0x4a/0x4f
> [  229.366434]  [<ffffffff816fa2ab>] __dev_notify_flags+0x37/0x5b
> [  229.368342]  [<ffffffff816fa318>] dev_change_flags+0x49/0x54
> [  229.370184]  [<ffffffff8174574a>] devinet_ioctl+0x24f/0x542
> [  229.372036]  [<ffffffff81746975>] inet_ioctl+0x97/0xb1
> [  229.373774]  [<ffffffff816e5042>] sock_do_ioctl.constprop.42+0x18/0x37
> [  229.375791]  [<ffffffff816e5480>] sock_ioctl+0x1fd/0x20a
> [  229.377648]  [<ffffffff810bb9cd>] ?
> trace_buffer_lock_reserve+0x41/0x56
> [  229.379701]  [<ffffffff8112b7c6>] vfs_ioctl+0x26/0x39
> [  229.381459]  [<ffffffff8112c0d2>] do_vfs_ioctl+0x41b/0x45e
> [  229.383269]  [<ffffffff8100bc3a>] ?
> ftrace_raw_event_sys_enter+0x10b/0x11a
> [  229.385404]  [<ffffffff817fc118>] ? retint_swapgs+0x13/0x1b
> [  229.387227]  [<ffffffff8112c15a>] sys_ioctl+0x45/0x73
> [  229.388975]  [<ffffffff818034be>] tracesys+0xd0/0xd5
> 
> The intention of the warning is to warn about IPIs generated from
> hardirq contexts. But in_interrupt() will also warn from
> softirq-disabled contexts.
Thanks Ingo and Fengguang's pointing out.
I have written a new patch https://lkml.org/lkml/2013/2/16/1 which use the below macro to know if
nmi/hard/soft irq is handling.
+#define in_serving_irq() (in_nmi() || in_irq() || in_serving_softirq())
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
