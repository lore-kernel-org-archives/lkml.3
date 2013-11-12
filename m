Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab3KLSAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:00:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:50053 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616Ab3KLSAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:00:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="407592034"
From: "Luck, Tony" <tony.luck@intel.com>
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
CC: "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Does Itanium permit speculative stores?
Thread-Topic: Does Itanium permit speculative stores?
Thread-Index: AQHO3wTYfgu6SOPRfUqcstIZdoZgD5oh4Tgg
Date: Tue, 12 Nov 2013 18:00:26 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D5DB28@ORSMSX106.amr.corp.intel.com>
References: <20131111171307.GA27002@linux.vnet.ibm.com>
In-Reply-To: <20131111171307.GA27002@linux.vnet.ibm.com>
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

> Does Itanium permit speculative stores?  For example, on Itanium what are
> the permitted outcomes of the following litmus test, where both x and y
> are initially zero?

We have a complier visible speculative read via the "ld.s" and "chk" instructions. But
there is no speculative write ("st.s") instruction.  I think you are asking "can out of order
writes become visible in this scenario?"

	CPU 0				CPU 1

	r1 = ACCESS_ONCE(x);		r2 = ACCESS_ONCE(y);
	if (r1)				if (r2)
		ACCESS_ONCE(y) = 1;		ACCESS_ONCE(x) = 1;

> In particular, is the outcome (r1 == 1 && r2 == 1) possible on Itanium
> given this litmus test?

The "ACCESS_ONCE" macro casts to volatile - which will make gcc generate
ordered "ld.acq" and "st.rel" instructions for your code snippets. So I think
you should be fine.

-Tony
