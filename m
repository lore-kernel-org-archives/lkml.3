Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3C1QrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:47:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:34081 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755844Ab3C1QrW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:47:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,927,1363158000"; 
   d="scan'208";a="219941918"
From: "Luck, Tony" <tony.luck@intel.com>
To: Xie XiuQi <xiexiuqi@huawei.com>, "Yu, Fenghua" <fenghua.yu@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>
Subject: RE: [PATCH] ia64: Fix example error_injection_tool
Thread-Topic: [PATCH] ia64: Fix example error_injection_tool
Thread-Index: AQHOK1/BVjdISEv1w0alJtWktDd8mpi7UAAw
Date: Thu, 28 Mar 2013 16:47:13 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1E093C98@ORSMSX108.amr.corp.intel.com>
References: <5153B0ED.8020309@huawei.com>
In-Reply-To: <5153B0ED.8020309@huawei.com>
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

Nice catch.

-			mask[j]=1<<k;
+			mask[j] = (unsigned long)1<<k;

Could use
			mask[j] = 1ul << k;
to avoid the verbose cast.

-Tony
