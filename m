Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaBTUqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 15:46:21 -0500
Received: from mail-bl2lp0206.outbound.protection.outlook.com ([207.46.163.206]:5601
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753971AbaBTUqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 15:46:19 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "rja@sgi.com" <rja@sgi.com>
CC: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Topic: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Index: AQHPLMZ9xGM3QUTlOk+rIS3zgvGkBZq+l00AgAAHJxWAAAGIgA==
Date: Thu, 20 Feb 2014 20:46:04 +0000
Message-ID: <1392929163.20109.5.camel@x230>
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com>
	 <20140220201458.GA7099@sgi.com> <1392927381.20109.0.camel@x230>
	 <20140220204028.GJ17949@sgi.com>
In-Reply-To: <20140220204028.GJ17949@sgi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(377424004)(189002)(199002)(24454002)(49866001)(47976001)(50986001)(56776001)(4396001)(47736001)(76482001)(53806001)(51856001)(54316002)(54356001)(95416001)(92566001)(94316002)(69226001)(85852003)(83072002)(46102001)(93136001)(92726001)(94946001)(86362001)(93516002)(80022001)(65816001)(80976001)(19580405001)(59766001)(19580395003)(77982001)(83322001)(2656002)(76786001)(85306002)(90146001)(74366001)(56816005)(81542001)(63696002)(79102001)(77096001)(81816001)(81686001)(47446002)(33646001)(81342001)(33716001)(74876001)(74706001)(31966008)(74662001)(74502001)(87936001)(87266001)(76796001)(95666003)(3826001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB421;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:BCF6F635.2C3552E1.F3F02B8A.8AEAD2A0.20270;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC7E23AE1175F340B547257E0FDFD879@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1KKkRZk021420

On Thu, 2014-02-20 at 14:40 -0600, Russ Anderson wrote:

> Why build a driver into the kernel?

Because it provides functionality that other drivers may need without
there being any mechanism to provide an explicit dependency. The same
reason we build the ACPI embedded controller driver into the kernel.

> The reason ipmi_si is 
> a driver is so systems that want it can load it and systems
> that do not want it do not have to load it.  Plus you can
> stop/start modules without rebooting.  You can change module
> parameters without rebooting.

You can change module parameters without rebooting anyway - there's an
interface for it in sysfs.

> There are any number of reasons why a BMC may not respond.
> BMCs are notorious for being flakey, with different types
> of BMCs that may or may not be reliable.  You do not want
> to make the kernel boot dependent on an unreliable component.

You appear to be saying "SGI ship hardware that doesn't work. We don't
know why it doesn't work and we're not interested in fixing it, so we'd
prefer the default kernel configuration to be broken". That doesn't seem
like an especially compelling argument.

> This is also a problem for systems with functional BMCs.  Our
> large cluster systems do all IPMI traffic (monitoring) through
> a system controller back door.  We do not want the kernel
> doing IPMI commands on those systems.

Why not?

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
