Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab3IIXCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 19:02:55 -0400
Received: from mail-bn1lp0153.outbound.protection.outlook.com ([207.46.163.153]:40478
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756083Ab3IIXCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 19:02:10 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: David Lang <david@lang.hm>
CC: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
Thread-Topic: [PATCH 00/12] One more attempt at useful kernel lockdown
Thread-Index: AQHOrYDL2QYLBLFVskGOdCrAsfX2cpm9uPUAgABNO4A=
Date: Mon, 9 Sep 2013 23:02:05 +0000
Message-ID: <1378767723.17982.27.camel@x230.lan>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	 <19562.1378747124@turing-police.cc.vt.edu>
	 <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
In-Reply-To: <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:5d52:9ee3:3e84:6668]
x-forefront-prvs: 09645BAC66
x-forefront-antispam-report: SFV:NSPM;SFS:(189002)(199002)(24454002)(15404003)(377424004)(65816001)(80976001)(80022001)(47446002)(74662001)(74366001)(74502001)(74706001)(53806001)(54316002)(56776001)(83072001)(76482001)(54356001)(77982001)(51856001)(59766001)(77096001)(56816003)(74876001)(19580395003)(83322001)(19580405001)(81686001)(81816001)(63696002)(46102001)(81342001)(47976001)(81542001)(50986001)(69226001)(76796001)(76786001)(4396001)(47736001)(49866001)(31966008)(79102001)(33646001)(36756003)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB222;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:5d52:9ee3:3e84:6668;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <4ADAF0E2F2A954468B9E59094147F8DF@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r89N30FQ023678

On Mon, 2013-09-09 at 11:25 -0700, David Lang wrote:

> 1 lock down modules
> 2 lock down kexec

Having thought about this, the answer is no. It presents exactly the
same problem as capabilities do - the set can never be meaningfully
extended. If an application sets only the bits it knows about, and if a
new security-sensitive feature is added to the kernel, the feature will
be left enabled and the system will be insecure. Alternatively, if an
application sets all the bits regardless of whether it knows them or
not, it may enable a lockdown feature that it otherwise required.

The only way this is useful is if all the bits are semantically
equivalent, and in that case there's no point in having anything other
than a single bit. Users who want a more fine-grained interface should
use one of the existing mechanisms for doing so - leave the kernel open
and impose the security policy from userspace using either capabilities
or selinux.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
