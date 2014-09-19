Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbaISDEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 23:04:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:47980 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbaISDEU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 23:04:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,551,1406617200"; 
   d="scan'208";a="605170896"
From: "Drokin, Oleg" <oleg.drokin@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "<devel@driverdev.osuosl.org>" <devel@driverdev.osuosl.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "<kernel-janitors@vger.kernel.org>" <kernel-janitors@vger.kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        "<HPDD-discuss@ml01.01.org>" <HPDD-discuss@ml01.01.org>
Subject: Re: [HPDD-discuss] [PATCH] staging: lustre: llite: Use kzalloc and
 rewrite null tests
Thread-Topic: [HPDD-discuss] [PATCH] staging: lustre: llite: Use kzalloc and
 rewrite null tests
Thread-Index: AQHP038cV7KKUWUf/U2QvPeJwPvEYJwIAvSAgAA2K4CAAAH8gA==
Date: Fri, 19 Sep 2014 03:04:08 +0000
Message-ID: <517B3353-BD3C-4326-A8F4-F1775B4865E5@intel.com>
References: <1411071842-24714-1-git-send-email-Julia.Lawall@lip6.fr>
 <1411071842-24714-2-git-send-email-Julia.Lawall@lip6.fr>
 <20140918234309.GP17875@mwanda>
 <E43F4FD2-3A79-485E-960B-A12960B3D2B7@intel.com>
In-Reply-To: <E43F4FD2-3A79-485E-960B-A12960B3D2B7@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.20.165]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E46547270BE4784884EC401EFF024F5D@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 18, 2014, at 10:57 PM, Drokin, Oleg wrote:

> would not be easy to do. Perhaps registered callbacks for pools that could be called on alloc and on free - though such pools would also need to allow to allocate different sized chunks too).

Come think of it - we don't even need callbacks here. If a pool would allow to allocate different sized chunks of memory. Then on module unmount there's already a warning for freeing
not yet empty pool, and we can even see all the leaked bits if we really want to (in like a crash dump).
So a module would just need to register such a general pool and use it for all allocations.

Bye,
    Oleg