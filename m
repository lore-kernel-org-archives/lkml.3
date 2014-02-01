Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbaBATjd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 14:39:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:29312 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbaBATjb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 14:39:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,760,1384329600"; 
   d="scan'208";a="474410432"
From: "Brown, Len" <len.brown@intel.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Arjan van de Ven <arjan@linux.intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Preeti Murthy <preeti.lkml@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: RE: [RFC PATCH 3/3] idle: store the idle state index in the struct
 rq
Thread-Topic: [RFC PATCH 3/3] idle: store the idle state index in the struct
 rq
Thread-Index: AQHPHmj1HuPlkSKnskqavB1n6ZD3b5qfdYqAgAAIdACAAAOggIAAKZ4AgAA834CAASafgP//u6dQ
Date: Sat, 1 Feb 2014 19:39:29 +0000
Message-ID: <1A7043D5F58CCB44A599DFD55ED4C948452D3706@FMSMSX106.amr.corp.intel.com>
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org>
 <1391090962-15032-4-git-send-email-daniel.lezcano@linaro.org>
 <20140130153150.GD5002@laptop.programming.kicks-ass.net>
 <52EA7D8A.6080604@linaro.org>
 <20140130163501.GG5002@laptop.programming.kicks-ass.net>
 <52EA8B07.6020206@linaro.org>
 <CAM4v1pPwmRUOtNeGh5sZmj+wAsC8RstofNA5Gx862SEECvW-Lg@mail.gmail.com>
 <20140131090230.GM5002@laptop.programming.kicks-ass.net>
 <52EB6F65.8050008@linux.vnet.ibm.com> <52EBBC23.8020603@linux.intel.com>
 <52EBC33A.6080101@linaro.org> <52EBC645.2040607@linux.intel.com>
 <alpine.LFD.2.11.1401311236470.2312@knanqh.ubzr>
 <1A7043D5F58CCB44A599DFD55ED4C948452D34DC@FMSMSX106.amr.corp.intel.com>
 <alpine.LFD.2.11.1402011028400.2312@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1402011028400.2312@knanqh.ubzr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And your point is?

It is a bad idea for an individual CPU to track the C-state
of another CPU, which can change the cycle after it was checked.
We know it is a bad idea because we used to do it,
until we realized code here can easily impact the
performance critical path.

In general, it is the OS's job to communicate constraints
to the HW, and the HW to act on them.  Not all HW is smart,
so sometimes the OS has to do more hand-holding -- but
less is more.

thanks,
-Len

