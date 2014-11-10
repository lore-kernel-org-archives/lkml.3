Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaKJLR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 06:17:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:41729 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbaKJLRZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 06:17:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,352,1413270000"; 
   d="scan'208";a="629472752"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "sre@kernel.org" <sre@kernel.org>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "anton@enomsg.org" <anton@enomsg.org>, "pavel@ucw.cz" <pavel@ucw.cz>
Subject: RE: [PATCH 2/3] power: core: Add variables related temperature to
 power_supply_info.
Thread-Topic: [PATCH 2/3] power: core: Add variables related temperature to
 power_supply_info.
Thread-Index: AQHP4h28WS6Qmn8eW0+W+Bid+M8/ppxZ6CGA
Date: Mon, 10 Nov 2014 11:16:32 +0000
Message-ID: <20ADAB092842284E95860F279283C5642ED9EDE3@BGSMSX104.gar.corp.intel.com>
References: <1412679518-21499-1-git-send-email-jonghwa3.lee@samsung.com>
 <1412679518-21499-3-git-send-email-jonghwa3.lee@samsung.com>
In-Reply-To: <1412679518-21499-3-git-send-email-jonghwa3.lee@samsung.com>
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

> @@ -241,6 +241,8 @@ struct power_supply_info {
>  	int charge_empty_design;
>  	int energy_full_design;
>  	int energy_empty_design;
> +	int temperature_max;
> +	int temperature_min;
>  	int use_for_apm;
>  };


The CC,CV and restart threshold would vary based on the battery temperature
So I would suggest to have temperature zone table as part  of battery info
along with other attributes.

int iterm; //charge termination current (used to stop charging)
int temp_zone_count; // number of temperature zone tables present
struct batt_temp_mon_table temp_mon_tbl[MAX_TEMP_MON_TABLE]; //temperature zone table array

struct  batt_temp_mon_table {
	 short int temp_max;
	 short int cc;
	 short int cv;
	 short int vbat_vchk_drop_uv;
	 short int temp_min;
};

-Jenny

