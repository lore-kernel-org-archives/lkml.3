Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaKJDl5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 22:41:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:60476 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbaKJDl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 22:41:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,350,1413270000"; 
   d="scan'208";a="619756839"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: "jonghwa3.lee@samsung.com" <jonghwa3.lee@samsung.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "sre@kernel.org" <sre@kernel.org>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "anton@enomsg.org" <anton@enomsg.org>, "pavel@ucw.cz" <pavel@ucw.cz>
Subject: RE: [PATCH 1/3] power: core: Add generic interface to get battery
 specification.
Thread-Topic: [PATCH 1/3] power: core: Add generic interface to get battery
 specification.
Thread-Index: AQHP4h263BcJpDIneE+5kaYQB24XuZxWs9dQgAIyEwCAAIUrQA==
Date: Mon, 10 Nov 2014 03:41:04 +0000
Message-ID: <20ADAB092842284E95860F279283C5642ED9B294@BGSMSX104.gar.corp.intel.com>
References: <1412679518-21499-1-git-send-email-jonghwa3.lee@samsung.com>
 <1412679518-21499-2-git-send-email-jonghwa3.lee@samsung.com>
 <20ADAB092842284E95860F279283C5642ED8AE04@BGSMSX104.gar.corp.intel.com>
 <5460109E.9060603@samsung.com>
In-Reply-To: <5460109E.9060603@samsung.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAA3g4Ls025188

> 
> >> +ATOMIC_NOTIFIER_HEAD(psy_battery_info_notifier);
> >
> >  Isn't it good to reuse the existing power_supply_notifier for this?
> >
> >> +enum battery_info_notifier_events {
> >> +	PSY_BATT_INFO_REGISTERED,
> >> +	PSY_BATT_INFO_UNREGISTERED,
> >> +};
> >
> > If we use the power_supply_notifier, then this can be moved to
> > enum power_supply_notifier_events
> >
> 
> 
> It doesn't use power_supply_notifier, rather than it uses newly introduced
> notifier for battery information. Intention of making of new notifier block here
> is to extinguish event from power_supply_changed which might be noisy for
> battery information consumer. However, If it looks wasteful code, it's not a big
> deal to use existed power_supply_notifier.

Using the power_supply_notifier helps to get all power supply notifications
(power_supply_chnaged, battery info register/unregister, ..) using a single notifier. The
consumers can ignore the unwanted events.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
