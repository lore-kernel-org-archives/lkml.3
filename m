Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3KLSrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:47:03 -0500
Received: from mga11.intel.com ([192.55.52.93]:44222 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab3KLSrB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:47:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,686,1378882800"; 
   d="scan'208";a="432237899"
From: "Luck, Tony" <tony.luck@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Does Itanium permit speculative stores?
Thread-Topic: Does Itanium permit speculative stores?
Thread-Index: AQHO3wTYfgu6SOPRfUqcstIZdoZgD5oh4TgggACQNID//34RoA==
Date: Tue, 12 Nov 2013 18:46:20 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D5DF47@ORSMSX106.amr.corp.intel.com>
References: <20131111171307.GA27002@linux.vnet.ibm.com>
 <3908561D78D1C84285E8C5FCA982C28F31D5DB28@ORSMSX106.amr.corp.intel.com>
 <20131112182617.GG21461@twins.programming.kicks-ass.net>
In-Reply-To: <20131112182617.GG21461@twins.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So the point we're having a discussion on is if any architecture has
> visible speculative STORES and if there's an architecture that doesn't
> have control dependencies.
>
> On the visible speculative STORES; can, if in the above example we have
> regular loads/stores:
>
>  LOAD r1, x			LOAD r2, y
>  IF (r1)			IF (r2)
>	STORE y, 1			STORE x, 1
>
> we observe: r1==1 && r2==1
>
> In order for that to be true; we must be able to observe the stores
> before the loads are complete -- and therefore before the branches are a
> certainty.

Even without the ".acq" and ".rel" this code is still safe.

Quoting ia64 SDM vol 1, Section 4.4.7 Memory Access Ordering"
"In addition, memory writes and flushes must observe control dependencies"

which I take to mean that the STORE can't be visible until we are certain of
the outcome of the conditional.

-Tony
