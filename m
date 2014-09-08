Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbaIHNuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:50:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:45292 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbaIHNuN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:50:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,486,1406617200"; 
   d="scan'208";a="599667624"
From: "Tirdea, Irina" <irina.tirdea@intel.com>
To: Hartmut Knaack <knaack.h@gmx.de>
CC: Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jonathan Cameron" <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: RE: [PATCH] iio: gyro: bmg160: only set power state if PM_RUNTIME
 is defined
Thread-Topic: [PATCH] iio: gyro: bmg160: only set power state if PM_RUNTIME
 is defined
Thread-Index: AQHPycvSvKCYo0vvNUezL4CGyo06tZv3Qwsg
Date: Mon, 8 Sep 2014 13:50:01 +0000
Deferred-Delivery: Mon, 8 Sep 2014 13:49:00 +0000
Message-ID: <1F3AC3675D538145B1661F571FE1805F199761AE@IRSMSX105.ger.corp.intel.com>
References: <1409655759-28849-1-git-send-email-irina.tirdea@intel.com>
 <540AFA13.6010207@gmx.de>
In-Reply-To: <540AFA13.6010207@gmx.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: linux-iio-owner@vger.kernel.org [mailto:linux-iio-owner@vger.kernel.org] On Behalf Of Hartmut Knaack
> Sent: 06 September, 2014 15:12
> To: Tirdea, Irina; Jonathan Cameron; linux-iio@vger.kernel.org
> Cc: Lars-Peter Clausen; Peter Meerwald; Srinivas Pandruvada; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] iio: gyro: bmg160: only set power state if PM_RUNTIME is defined
> 
> Irina Tirdea schrieb:
> > When CONFIG_PM_RUNTIME is not defined and bmg160 tries to power
> > off the device, bmg160_set_power_state will call pm_runtime_put_autosuspend,
> > which is not implemented (wil return -ENOSYS).
> >
> > Only call bmg160_set_power_state when CONFIG_PM_RUNTIME is defined.
> Unless there is anything more to come, what about putting the #ifdef into first line inside bmg160_set_power_state() and just an
> #endif before the return 0 at the end? Saves 5 lines.

Thanks for the suggestion! Will fix it in v2.

> > Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> > Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> > ---


Thanks,
Irina

