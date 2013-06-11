Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab3FKJp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 05:45:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53808 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061Ab3FKJp1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 05:45:27 -0400
From: "B, Ravi" <ravibabu@ti.com>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: RE: [PATCH v2 2/7] usb: phy: dsps: adding usbphy driver for am33xx
 platform
Thread-Topic: [PATCH v2 2/7] usb: phy: dsps: adding usbphy driver for am33xx
 platform
Thread-Index: AQHOZnPPYPfsaLwAwUyNU6t2EvLj+Jkvq6kAgACXOAA=
Date: Tue, 11 Jun 2013 09:45:23 +0000
Message-ID: <6C6B28D4DC342643927BEAFCE8707BF63EB02C13@DBDE04.ent.ti.com>
References: <1370935072-21056-1-git-send-email-ravibabu@ti.com>
 <1370935072-21056-3-git-send-email-ravibabu@ti.com> <51B6E282.9030400@ti.com>
In-Reply-To: <51B6E282.9030400@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kishon

> Cc: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Balbi, Felipe
> Subject: Re: [PATCH v2 2/7] usb: phy: dsps: adding usbphy driver for am33xx platform

>> +
>> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "phy_wkup");
>> +	phy->phy_wkup = ioremap(res->start, resource_size(res));

>devm_ioremap?

The phy_wakeup register is common across two instances of phy, devm_ioremap_resource() will fail to map for twice for same register space.

>> +	if (IS_ERR(phy->phy_wkup))
>> +		return PTR_ERR(phy->phy_wkup);
>> +
>> +	if (np)
>> +		of_property_read_u32(np, "id", &phy->id);

> Is this property documented somewhere?

Not it is not documented.

>> +
>> +	phy->phy.dev		= phy->dev;
>> +	phy->phy.label		= "dsps-usbphy";
>> +	dsps_usbphy_power(&dsps_phy->phy, 0);
>> +	dsps_phy->is_suspended = 1;

> Are you using this "is_suspended" anywhere else?

Currently not used.
--
Ravi B
