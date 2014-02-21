Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbaBUQNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:13:00 -0500
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:12759
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754370AbaBUQM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:12:58 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "lv.zheng@intel.com" <lv.zheng@intel.com>
CC: "rja@sgi.com" <rja@sgi.com>, "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Topic: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Index: AQHPLMZ9xGM3QUTlOk+rIS3zgvGkBZq+l00AgAAHJxWAAAUvD4AACFkLgAAKotuAAArDa4AAFJArgAAmkQCAAOl7AA==
Date: Fri, 21 Feb 2014 16:12:52 +0000
Message-ID: <1392999172.20109.47.camel@x230>
References: <20140220204028.GJ17949@sgi.com> <1392929163.20109.5.camel@x230>
	 <20140220205901.GM17949@sgi.com> <1392930047.20109.6.camel@x230>
	 <20140220212854.GO17949@sgi.com> <1392932363.20109.11.camel@x230>
	 <20140220220656.GT17949@sgi.com> <1392935204.20109.17.camel@x230>
	 <20140220224529.GV17949@sgi.com> <1392937781.20109.24.camel@x230>
	 <20140220235904.GZ17949@sgi.com>
	 <1AE640813FDE7649BE1B193DEA596E88024B228C@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88024B228C@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(189002)(199002)(377424004)(24454002)(76786001)(76796001)(81542001)(81342001)(69226001)(79102001)(77982001)(59766001)(74706001)(74876001)(74366001)(33646001)(33716001)(95666003)(63696002)(80022001)(86362001)(65816001)(94316002)(93136001)(93516002)(95416001)(92566001)(92726001)(87936001)(94946001)(90146001)(80976001)(56816005)(83072002)(83322001)(19580395003)(19580405001)(85852003)(46102001)(85306002)(4396001)(15975445006)(53806001)(54356001)(51856001)(77096001)(47736001)(49866001)(50986001)(47976001)(74502001)(47446002)(87266001)(81816001)(74662001)(2656002)(56776001)(54316002)(76482001)(31966008)(81686001)(3826001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB421;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:94B0D106.15355FE1.C3F92D32.4A29D171.20298;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <09101956F3F9C84EABBADE2BBCAE1C2F@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1LGD5WQ001019

On Fri, 2014-02-21 at 02:17 +0000, Zheng, Lv wrote:

> In fact there is a workaround solution I've posted here:
> https://patchwork.kernel.org/patch/2831851/
> The updated version of this patch can be found at:
> https://bugzilla.kernel.org/attachment.cgi?id=112611
> It is the acpi-ipmi13.patch file.

I don't think that solves the underlying problem? We're still left with
no guarantee of ordering between ACPI IPMI operation region support
being available and the loading of a driver that may rely on it.

> I think there should be relationship between ACPI region and Linux kernel modules.
> In fact on the well-known operating system, _REG is always invoked at the end of the IRP_PNP_START_DEVICE completions.
> But we may still be able to return -EPROBE_DEFER in the power meter driver when it detects failures caused by the readiness state of the region handlers.

We don't have a guarantee that it'll happen at probe time. The
capabilities list may be static, and so we'll get our first failure on
an attempted userspace access instead.

It may be that Corey's suggestion satisfies the concerns Russ raised.
Building IPMI in but only probing by default on systems that declare a
BMC in ACPI or DMI should avoid boot-time delays while still ensuring
that the functionality is available on systems where there's a real
chance that the firmware expects the OS to provide support.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
