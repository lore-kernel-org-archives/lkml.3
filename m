Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab3BJVTP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 16:19:15 -0500
Received: from mga14.intel.com ([143.182.124.37]:60113 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027Ab3BJVTN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 16:19:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,639,1355126400"; 
   d="scan'208";a="255194067"
From: "Hefty, Sean" <sean.hefty@intel.com>
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jean Delvare <khali@linux-fr.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Roland Dreier <roland@kernel.org>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "Marciniszyn, Mike" <mike.marciniszyn@intel.com>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: RE: [PATCH 2/6] idr: remove MAX_IDR_MASK and move left MAX_IDR_*
 into idr.c
Thread-Topic: [PATCH 2/6] idr: remove MAX_IDR_MASK and move left MAX_IDR_*
 into idr.c
Thread-Index: AQHOBj+Q/tin3FfbzUm/J7sB5mI4OZhwhOCggAHkOoCAATJwUA==
Date: Sun, 10 Feb 2013 21:19:10 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237368B96C1F@ORSMSX101.amr.corp.intel.com>
References: <20130208210050.GA26660@mtj.dyndns.org>
 <20130208210149.GB26660@mtj.dyndns.org>
 <1828884A29C6694DAF28B7E6B8A8237357D44677@ORSMSX101.amr.corp.intel.com>
 <20130209190037.GB2875@htj.dyndns.org>
In-Reply-To: <20130209190037.GB2875@htj.dyndns.org>
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

> So, if you want a cyclic allocation, the allocation should be tried in
> [start, END) and then [0, start); otherwise, after the allocation
> wraps for the first time, as the closer the starting point gets to
> END, the chance of not finding a vacant slot in [start, END) goes
> higher.  When @start equals END - 1 for the second time, if the first
> END - 1 allocation is still around, you'll get -ENOSPC.

Got it - thanks.  I'll make a note to fix this.
