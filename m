Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab3IQQrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 12:47:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:9029 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379Ab3IQQrm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 12:47:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,924,1371106800"; 
   d="scan'208";a="404728603"
From: "Luck, Tony" <tony.luck@intel.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RESEND PATCH v2 1/4] mm/hwpoison: fix traverse hugetlbfs page
 to avoid printk flood
Thread-Topic: [RESEND PATCH v2 1/4] mm/hwpoison: fix traverse hugetlbfs page
 to avoid printk flood
Thread-Index: AQHOsaXFJmJWUCUhwUmKHzq/SE5I2JnGYvcAgAKGf9CAAHuMgIAAFJ6A//+PnLCAAHzVgIAAnJxw
Date: Tue, 17 Sep 2013 16:47:39 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31CFEAC9@ORSMSX106.amr.corp.intel.com>
References: <1379202839-23939-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <20130915001352.GQ18242@two.firstfloor.org>
 <3908561D78D1C84285E8C5FCA982C28F31CFD2D6@ORSMSX106.amr.corp.intel.com>
 <1379369397-ld8lbcn-mutt-n-horiguchi@ah.jp.nec.com>
 <20130916232345.GA3241@hacker.(null)>
 <3908561D78D1C84285E8C5FCA982C28F31CFD50B@ORSMSX106.amr.corp.intel.com>
 <20130917000817.GA5996@hacker.(null)>
In-Reply-To: <20130917000817.GA5996@hacker.(null)>
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

> Transparent huge pages are not helpful for DB workload which there is a lot of 
> shared memory

Hmm. Perhaps they should be.  If a database allocates most[1] of the memory on a
machine to a shared memory segment - that *ought* to be a candidate for using
transparent huge pages.  Now that we have them they seem a better choice (much
more flexibility) than hugetlbfs.

-Tony

[1] I've been told that it is normal to configure over 95% of physical memory to the
shared memory region to run a particular transaction based benchmark with one
commercial data base application.

