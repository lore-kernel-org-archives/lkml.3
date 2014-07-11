Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaGKHyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:54:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44071 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbaGKHyo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:54:44 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: "Quadros, Roger" <rogerq@ti.com>, "tony@atomide.com" <tony@atomide.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>
CC: "javier@dowhile0.org" <javier@dowhile0.org>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH 07/10] OMAP: GPMC: Introduce APIs for Configuring
 ECC Engine
Thread-Topic: [RFC PATCH 07/10] OMAP: GPMC: Introduce APIs for Configuring
 ECC Engine
Thread-Index: AQHPm3KfolT+TFXUakK7gKHiJMY+w5uagd9A
Date: Fri, 11 Jul 2014 07:54:04 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EB01E0E@DBDE04.ent.ti.com>
References: <1404909450-11970-1-git-send-email-rogerq@ti.com>
 <1404909450-11970-8-git-send-email-rogerq@ti.com>
In-Reply-To: <1404909450-11970-8-git-send-email-rogerq@ti.com>
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

Hi Roger,

>From: Quadros, Roger
>
>Even though the ECC/BCH engine is meant for exclusive use by
>the OMAP NAND controller, the ECC/BCH registers belong
>to the GPMC controller's register space
>
>Add omap_gpmc_ecc_configure_enable() and omap_gpmc_ecc_disable()
>to manage the ECC engine. OMAP NAND driver must use these APIs
>instead of directly accessing the ECC Engine registers.
>
>Signed-off-by: Roger Quadros <rogerq@ti.com>
>---
As suggested in 
http://lists.infradead.org/pipermail/linux-mtd/2014-July/054595.html

Please try to move chip->ecc.calculate() implementations like
- omap_calculate_ecc_bch()
- omap_calculate_ecc()

>From NAND driver To GPMC driver, as that should be easy, And solve
most of your work (no need to export GPMC registers).
- You may rename them appropriately and change the argument list
   if needed.
- And NAND driver can just have some wrapper functions to match
  the MTD interface arguments.


with regards, pekon



