Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab3IEOs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:48:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:29278 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab3IEOs5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:48:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,847,1371106800"; 
   d="scan'208";a="398732166"
From: "Luck, Tony" <tony.luck@intel.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] lockref: remove cpu_relax() again
Thread-Topic: [PATCH] lockref: remove cpu_relax() again
Thread-Index: AQHOqjponYZ6pHUzoUeo27Wv6BHm9pm3Ny3w
Date: Thu, 5 Sep 2013 14:48:52 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31CDC251@ORSMSX106.amr.corp.intel.com>
References: <20130905131814.GA24274@osiris>
In-Reply-To: <20130905131814.GA24274@osiris>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> *If* however the cpu_relax() makes sense on other platforms maybe we could
> add something like we have already with "arch_mutex_cpu_relax()":

I'll do some more measurements on ia64.  During my first tests cpu_relax() seemed
to be a big win - but I only ran "./t" a couple of times.  Later (with the cpu_relax() in
place) I ran a bunch more iterations, and found that the variation from run to run
is much larger with lockref.  The mean score is 60% higher, but the standard deviation
is an order of magnitude bigger (enough that one run out of 20 with lockref scored
lower than the pre-lockref kernel).

I think this is expected ... cmpxchg is a free-for-all - and sometimes poor placement
across the four socket system might cause short term starvation to a thread while
threads on another socket monopolize the cache line.

-Tony
