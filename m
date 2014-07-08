Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbaGHGH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 02:07:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:9862 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbaGHGH4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 02:07:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,624,1400050800"; 
   d="scan'208";a="454314380"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: Sebastian Reichel <sre@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "David Cohen" <david.a.cohen@linux.intel.com>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Subject: RE: [PATCH 3/4] power_supply: Introduce PSE compliant algorithm
Thread-Topic: [PATCH 3/4] power_supply: Introduce PSE compliant algorithm
Thread-Index: AQHPlEmiwCL4psBg3UmQFWJgLR5uO5uOGRuAgAejXIA=
Date: Tue, 8 Jul 2014 06:07:29 +0000
Message-ID: <20ADAB092842284E95860F279283C56422F95A3E@BGSMSX104.gar.corp.intel.com>
References: <1404122155-12369-1-git-send-email-jenny.tc@intel.com>
 <1404122155-12369-4-git-send-email-jenny.tc@intel.com>
 <20140703145617.GA23309@earth.universe>
In-Reply-To: <20140703145617.GA23309@earth.universe>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static int get_tempzone(struct psy_pse_chrg_prof *pse_mod_bprof,
> > +		int temp)
> > +{
> > +	int i = 0;
> > +	int temp_range_cnt;
> > +
> > +	temp_range_cnt =  min_t(u16, pse_mod_bprof->temp_mon_ranges,
> > +					BATT_TEMP_NR_RNG);
> > +	if ((temp < pse_mod_bprof->temp_low_lim) ||
> > +		(temp > pse_mod_bprof->temp_mon_range[0].temp_up_lim))
> > +		return -EINVAL;
> > +
> > +	for (i = 0; i < temp_range_cnt; ++i)
> > +		if (temp > pse_mod_bprof->temp_mon_range[i].temp_up_lim)
> > +			break;
> > +	return i-1;
> > +}
> 
> pse_mod_bprof->temp_mon_ranges > BATT_TEMP_NR_RNG is not allowed, so I
> suggest to print an error and return some error code.
> 
min_t takes care of the upper bound. The algorithm process BATT_TEMP_NR_RNG
even if the actual number of zones are greater than this. 
Agree to other comments

-Jenny
