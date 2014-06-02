Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaFBXi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 19:38:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:62204 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbaFBXiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 19:38:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,960,1392192000"; 
   d="scan'208";a="521712421"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: Andi Kleen <andi@firstfloor.org>, Kamil Iskra <iskra@mcs.anl.gov>,
        Borislav Petkov <bp@suse.de>, Chen Gong <gong.chen@linux.jf.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH 0/3] HWPOISON: improve memory error handling for
 multithread process
Thread-Topic: [PATCH 0/3] HWPOISON: improve memory error handling for
 multithread process
Thread-Index: AQHPfrQO7M4wCNOfC0qg1yK0O+UIRJted7Hw
Date: Mon, 2 Jun 2014 23:37:58 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F328268B7@ORSMSX114.amr.corp.intel.com>
References: <53877e9c.8b2cdc0a.1604.ffffea43SMTPIN_ADDED_BROKEN@mx.google.com>
	<1401432670-24664-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<3908561D78D1C84285E8C5FCA982C28F32823225@ORSMSX114.amr.corp.intel.com>
	<5388cd0e.463edd0a.755d.6f61SMTPIN_ADDED_BROKEN@mx.google.com>
 <20140602154302.595a54190afdffd4b50f22c2@linux-foundation.org>
In-Reply-To: <20140602154302.595a54190afdffd4b50f22c2@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not sure that "[PATCH 3/3] mm/memory-failure.c: support dedicated
> thread to handle SIGBUS(BUS_MCEERR_AO)" is a -stable thing?  That's a
> feature addition more than a bugfix?

No - the old behavior was crazy - someone with a multithreaded process might
well expect that if they call prctl(PF_MCE_EARLY) in just one thread, then that
thread would see the SIGBUS  with si_code = BUS_MCEERR_A0 - even if that
thread wasn't the main thread for the process.

Perhaps the description for the commit should better reflect that?

-Tony



