Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905Ab3BZICA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 03:02:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:17794 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab3BZIB7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 03:01:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,739,1355126400"; 
   d="scan'208";a="290538608"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "tglx@linutronix.de" <tglx@linutronix.de>,
        "Ingo Molnar (mingo@kernel.org)" <mingo@kernel.org>
CC: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "Chen, Jun D" <jun.d.chen@intel.com>
Subject: [Question]CLOCK_EVT_NOTIFY_BROADCAST_EXIT must be called with
 interrupts disabled?
Thread-Topic: [Question]CLOCK_EVT_NOTIFY_BROADCAST_EXIT must be called with
 interrupts disabled?
Thread-Index: Ac4T94ncBsIk2vpTQFWqB3qO9tzbDg==
Date: Tue, 26 Feb 2013 08:01:55 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A23E2CB@SHSMSX101.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just found some comments as below:
In commit 0beefa208bb3a9e581a60125703
+               /*
+                * The switch back from broadcast mode needs to be
+                * called with interrupts disabled.
+                */
+                local_irq_disable();
+                clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
+                local_irq_enable();


But checked some place in kernel code, it likes below in intel_idle.c:
	local_irq_enable();

	if (!(lapic_timer_reliable_states & (1 << (cstate))))
		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
Which enable the irq at first, then calling CLOCK_EVT_NOTIFY_BROADCAST_EXIT.

So not sure _BROAD_EXIT must be called with interrupts disabled? Thanks your comments in advance.


