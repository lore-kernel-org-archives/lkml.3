Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaBZQry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:47:54 -0500
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:46266
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751936AbaBZQrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:47:52 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "rui.zhang@intel.com" <rui.zhang@intel.com>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>
Subject: Re: [RFC PATCH 0/8] ACPI: change the way of enumerating
 PNPACPI/Platform devices
Thread-Topic: [RFC PATCH 0/8] ACPI: change the way of enumerating
 PNPACPI/Platform devices
Thread-Index: AQHPMtK4cG7APMXHIUq7OaKkVNhdy5rHv0+A
Date: Wed, 26 Feb 2014 16:47:48 +0000
Message-ID: <1393433267.14900.3.camel@x230>
References: <1393405874-3266-1-git-send-email-rui.zhang@intel.com>
In-Reply-To: <1393405874-3266-1-git-send-email-rui.zhang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(24454002)(199002)(377424004)(189002)(95416001)(94946001)(74662001)(31966008)(74502001)(86362001)(92566001)(54316002)(76482001)(74876001)(54356001)(92726001)(53806001)(47446002)(33646001)(19580405001)(19580395003)(83072002)(83322001)(95666003)(81816001)(51856001)(77096001)(80976001)(74366001)(2656002)(81686001)(85306002)(87936001)(59766001)(47736001)(50986001)(33716001)(49866001)(79102001)(47976001)(77982001)(81342001)(65816001)(80022001)(69226001)(93136001)(90146001)(85852003)(87266001)(81542001)(63696002)(94316002)(46102001)(74706001)(76796001)(76786001)(56816005)(56776001)(4396001)(93516002)(3826001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR05MB754;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:B0F5721D.DDE5419.F1F29394.C8BC9E52.201D7;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <102124477E7D1C48A3434E049DFB829F@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1QGm0BL032328

On Wed, 2014-02-26 at 17:11 +0800, Zhang Rui wrote:

> 1. without the patch, the acpi_platform scan handler white list is
>    continuously growing.
> 2. with the patch set, the PNPACPI scan handler white list will become
>    smaller and smaller by
>    a) remove the ids from the PNPACPI white list, for the devices
>       that are never enumerated via ACPI
>    b) remove the ids from the PNPACPI whilte list and convert the drivers to
>       platform bus drivers, for the devices that are not PNP devices in nature.
>    which will be done later.

I agree that this is the right direction to go in. The number of acpipnp
devices that are also pnpbios or (even worse) isapnp is (a) unlikely to
increase, and (b) *very* small, and pretty much limited to superio and a
small number of sound cards on old laptops. We may come up with a better
solution for them later, but right now shifting away from requiring that
every new ACPI device driver also bump a whitelist is an improvement.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
