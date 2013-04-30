Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160Ab3D3KFC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 06:05:02 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50156 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759794Ab3D3KFA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 06:05:00 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Huang Shijie <b32955@freescale.com>
CC: "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: RE: [PATCH V4 5/9] mtd: replace the hardcode with the onfi_feature()
Thread-Topic: [PATCH V4 5/9] mtd: replace the hardcode with the
 onfi_feature()
Thread-Index: AQHOQmAouYQ3/CJ+jUWG0+OGq/54/Jjujdmg
Date: Tue, 30 Apr 2013 10:04:25 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73E9BF544@DBDE04.ent.ti.com>
References: <1366967337-5534-1-git-send-email-b32955@freescale.com>
 <1366967337-5534-6-git-send-email-b32955@freescale.com>
In-Reply-To: <1366967337-5534-6-git-send-email-b32955@freescale.com>
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

> -	*busw = 0;
> -	if (le16_to_cpu(p->features) & 1)
> -		*busw = NAND_BUSWIDTH_16;
> +
> +	*busw = (onfi_feature(chip) & ONFI_FEATURE_16_BIT_BUS) ?
> +			NAND_BUSWIDTH_16 : 0;

Is this really needed ? you have already checked the 'onfi_version' above in
nand_flash_detect_onfi() ..
	if (!chip->onfi_version) {
		pr_info("%s: unsupported ONFI version: %d\n", __func__, val);
		return 0;
	}

with regards, pekon
