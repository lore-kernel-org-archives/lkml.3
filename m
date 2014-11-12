Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934729AbaKLDp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:45:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:29635 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932706AbaKLDpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 22:45:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,366,1413270000"; 
   d="scan'208";a="630526058"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: Pavel Machek <pavel@ucw.cz>
CC: "jonghwa3.lee@samsung.com" <jonghwa3.lee@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "sre@kernel.org" <sre@kernel.org>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "anton@enomsg.org" <anton@enomsg.org>
Subject: RE: [PATCH 2/3] power: core: Add variables related temperature to
 power_supply_info.
Thread-Topic: [PATCH 2/3] power: core: Add variables related temperature to
 power_supply_info.
Thread-Index: AQHP4h28WS6Qmn8eW0+W+Bid+M8/ppxZ6CGAgACEzQCAAJeRcIAAuwqAgADMxpA=
Date: Wed, 12 Nov 2014 03:45:03 +0000
Message-ID: <20ADAB092842284E95860F279283C5642EDCE099@BGSMSX104.gar.corp.intel.com>
References: <1412679518-21499-1-git-send-email-jonghwa3.lee@samsung.com>
 <1412679518-21499-3-git-send-email-jonghwa3.lee@samsung.com>
 <20ADAB092842284E95860F279283C5642ED9EDE3@BGSMSX104.gar.corp.intel.com>
 <546158A0.5000707@samsung.com>
 <20ADAB092842284E95860F279283C5642EDB8431@BGSMSX104.gar.corp.intel.com>
 <20141111204219.GA1347@amd>
In-Reply-To: <20141111204219.GA1347@amd>
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

> > The CC/CV for each battery temperature zone is defined as part of battery spec.
> This is
> > as per the JEITA/PSE standards. So IMO, this is a battery charging information
> > (charging object) rather than a thermal throttling information.
> >
> > Also the battery information may not fit into a standard format. Different standards
> have
> > different format for charging object. So I would suggest to make it flexible enough to
> > support different charging object format. For example MIPI BIF charging object
> format
> > (https://members.mipi.org/wg/BIF/document/11518) and MIPI BIF Rule based
> charging algorithm
> > (http://mipi.org/sites/default/files/mipi_BIF_rule-based-charging_white-paper_1.pdf)
> > has different charging object format. This is why the patch
> https://lkml.org/lkml/2014/8/13/355
> > has option to support different charging objects and different charging algorithms.
> 
> Yes, and this is also why your patches are not being
> merged. Overengineered, too complex. Citing standards will not improve
> the patches.
> 
> And yes, adding cc/cv to the thermal interface seems like a good idea
> to me.

Sorry to disagree with you. IMHO it's a charging profile and not a thermal profile. The
cc/cv information is defined as part of battery spec. If the intention here is to provide a
place for battery info, then cc/cv should be part of battery info. The latest charger chips
allows to configure CC/CV for different temperature zone. IMHO adding these information
to thermal profile doesn't seems to be the right approach since the thermal subsystem
need to be aware of the charging subsystem constraints.

The standards were cited to point where the industry is moving. Anyway let the maintainer
take a final call -  should we align with industry standards or stick to legacy charging
methodologies?

-Jenny
