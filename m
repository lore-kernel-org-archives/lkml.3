Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaKKE4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 23:56:38 -0500
Received: from mga03.intel.com ([134.134.136.65]:43505 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbaKKE4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 23:56:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,358,1413270000"; 
   d="scan'208";a="605718577"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: "jonghwa3.lee@samsung.com" <jonghwa3.lee@samsung.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "sre@kernel.org" <sre@kernel.org>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "anton@enomsg.org" <anton@enomsg.org>, "pavel@ucw.cz" <pavel@ucw.cz>
Subject: RE: [PATCH 2/3] power: core: Add variables related temperature to
 power_supply_info.
Thread-Topic: [PATCH 2/3] power: core: Add variables related temperature to
 power_supply_info.
Thread-Index: AQHP4h28WS6Qmn8eW0+W+Bid+M8/ppxZ6CGAgACEzQCAAJeRcA==
Date: Tue, 11 Nov 2014 04:56:31 +0000
Message-ID: <20ADAB092842284E95860F279283C5642EDB8431@BGSMSX104.gar.corp.intel.com>
References: <1412679518-21499-1-git-send-email-jonghwa3.lee@samsung.com>
 <1412679518-21499-3-git-send-email-jonghwa3.lee@samsung.com>
 <20ADAB092842284E95860F279283C5642ED9EDE3@BGSMSX104.gar.corp.intel.com>
 <546158A0.5000707@samsung.com>
In-Reply-To: <546158A0.5000707@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAB4uipC001227

> > The CC,CV and restart threshold would vary based on the battery temperature
> > So I would suggest to have temperature zone table as part  of battery info
> > along with other attributes.
> >
> > int iterm; //charge termination current (used to stop charging)
> > int temp_zone_count; // number of temperature zone tables present
> > struct batt_temp_mon_table temp_mon_tbl[MAX_TEMP_MON_TABLE];
> //temperature zone table array
> >
> > struct  batt_temp_mon_table {
> > 	 short int temp_max;
> > 	 short int cc;
> > 	 short int cv;
> > 	 short int vbat_vchk_drop_uv;
> > 	 short int temp_min;
> > };
> >
> 
> 
> IMO, throttling cc/cv according the temperature can be done via thermal fw
> interface. However voltage drop and charging termination current can be added here.

The CC/CV for each battery temperature zone is defined as part of battery spec. This is
as per the JEITA/PSE standards. So IMO, this is a battery charging information
(charging object) rather than a thermal throttling information.

Also the battery information may not fit into a standard format. Different standards have
different format for charging object. So I would suggest to make it flexible enough to
support different charging object format. For example MIPI BIF charging object format
(https://members.mipi.org/wg/BIF/document/11518) and MIPI BIF Rule based charging algorithm
(http://mipi.org/sites/default/files/mipi_BIF_rule-based-charging_white-paper_1.pdf)
has different charging object format. This is why the patch  https://lkml.org/lkml/2014/8/13/355
has option to support different charging objects and different charging algorithms.

-Jenny
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
