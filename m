Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947212Ab3BHWJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:09:31 -0500
Received: from mga14.intel.com ([143.182.124.37]:32885 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947025Ab3BHWJ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:09:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,632,1355126400"; 
   d="scan'208";a="200285712"
From: "Hefty, Sean" <sean.hefty@intel.com>
To: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Thread-Index: AQHOBj+Q/tin3FfbzUm/J7sB5mI4OZhwhOCg
Date: Fri, 8 Feb 2013 22:09:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237357D44677@ORSMSX101.amr.corp.intel.com>
References: <20130208210050.GA26660@mtj.dyndns.org>
 <20130208210149.GB26660@mtj.dyndns.org>
In-Reply-To: <20130208210149.GB26660@mtj.dyndns.org>
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

> * drivers/infiniband/core/cm.c:cm_alloc_id()
>   drivers/infiniband/hw/mlx4/cm.c:id_map_alloc()
> 
>   Used to wrap cyclic @start.  Can be replaced with max(next, 0).
>   Note that this type of cyclic allocation using idr is buggy.  These
>   are prone to spurious -ENOSPC failure after the first wraparound.

The replacement code looks fine, but can you explain why the use is buggy?
