Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab3FLHWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 03:22:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57808 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab3FLHWd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 03:22:33 -0400
From: "B, Ravi" <ravibabu@ti.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: RE: [PATCH v2 2/7] usb: phy: dsps: adding usbphy driver for am33xx
 platform
Thread-Topic: [PATCH v2 2/7] usb: phy: dsps: adding usbphy driver for am33xx
 platform
Thread-Index: AQHOZnPPYPfsaLwAwUyNU6t2EvLj+Jkvq6kAgACXOACAABPRAIABS15QgAAMDLA=
Date: Wed, 12 Jun 2013 07:22:28 +0000
Message-ID: <6C6B28D4DC342643927BEAFCE8707BF63EB040E1@DBDE04.ent.ti.com>
References: <1370935072-21056-1-git-send-email-ravibabu@ti.com>
 <1370935072-21056-3-git-send-email-ravibabu@ti.com>
 <51B6E282.9030400@ti.com>
 <6C6B28D4DC342643927BEAFCE8707BF63EB02C13@DBDE04.ent.ti.com>
 <51B771FC.1000203@cogentembedded.com>
 <6C6B28D4DC342643927BEAFCE8707BF63EB040A8@DBDE04.ent.ti.com>
In-Reply-To: <6C6B28D4DC342643927BEAFCE8707BF63EB040A8@DBDE04.ent.ti.com>
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

Typo.. corrected
"The /proc/iomem does not show this common register"

-----Original Message-----
From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of B, Ravi
Sent: Wednesday, June 12, 2013 12:51 PM
To: Sergei Shtylyov
Cc: ABRAHAM, KISHON VIJAY; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Balbi, Felipe
Subject: RE: [PATCH v2 2/7] usb: phy: dsps: adding usbphy driver for am33xx platform

>>>> +
>>>> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "phy_wkup");
>>>> +	phy->phy_wkup = ioremap(res->start, resource_size(res));

>>> devm_ioremap?

>> The phy_wakeup register is common across two instances of phy, devm_ioremap_resource() will fail to map for twice for same register space.

>   I've already told you the register can't be shared between devices like this.
>  BTW, you haven't replied to my request concerning your /proc/iomem contents... 

I have missed that specific mail. The /proc/iomem does not show this common register. As you suggest to create a third device for this shared register? I agree it can be done. 
Initially I thought this should be part of control module, but do we have control module frame work for every SoC(am335x)?
Every SoC has many such shared register to handle control/status logic for Soc specific IP(s)? 
If we create separate device node for each such registers, this will end up in adding more files to kernel. 

We should create single control module node for each SoC,

	cm: control_module@44e10000 {
                        compatible = "ti,dsps-usbphy";
                        reg = 0x44e10648 0x4
		     
                               0x44e10XXX 0x4
		    ....>
                        reg-names = "phy_wkup", "mmc_control", <xxxreg_ctrl>, <xxxreg_status>;
                        id = <0>;
                };
Have common control module APIs to control these registers, can be used by other driver modules. 

--
Ravi B
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
