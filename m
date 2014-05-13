Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaEMRtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 13:49:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:42706 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbaEMRtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 13:49:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1044,1389772800"; 
   d="scan'208";a="511035215"
From: "Luck, Tony" <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Chris Metcalf <cmetcalf@tilera.com>
CC: LKML <linux-kernel@vger.kernel.org>, Tony Lu <zlu@tilera.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: RE: [patch 03/32] genirq: Provide generic hwirq allocation facility
Thread-Topic: [patch 03/32] genirq: Provide generic hwirq allocation facility
Thread-Index: AQHPagtD6Yy2ISwNbEKI8hsHdZ1HHZs2CZcAgAAsCACAALqEAIAISpkA//+W2SA=
Date: Tue, 13 May 2014 17:48:46 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F328056B2@ORSMSX114.amr.corp.intel.com>
References: <20140507153622.703412101@linutronix.de>
 <20140507154334.208629358@linutronix.de> <536A998A.4000307@tilera.com>
 <alpine.DEB.2.02.1405072259230.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1405081140410.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1405131858520.6261@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1405131858520.6261@ionos.tec.linutronix.de>
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

> - a bitmap based matrix vector allocator, but that shouldn't be rocket
>   science to write one.

Not rocket science - but some tricky corner cases to make sure all the
allocations will fit.  MSI needs blocks of irqs that start on a power-of-two
boundary so the h/w can just fiddle with low order bits.  We'll see the
requests for allocation in some random order (rather than the more
convenient "largest block first"). We also have to handle hotplug events
adding and removing (and generally messing up the neat layout).
In the worst case we might need a callback to a driver to tell it
that we need to move irqs previously allocated to some new range
in order to free a contiguous block.

-Tony
