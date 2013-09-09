Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab3IISbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:31:13 -0400
Received: from mail-bn1lp0152.outbound.protection.outlook.com ([207.46.163.152]:17103
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab3IISbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:31:10 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 01/12] Add BSD-style securelevel support
Thread-Topic: [PATCH 01/12] Add BSD-style securelevel support
Thread-Index: AQHOrXST0kcK6RTzv06SuZIfeWETyJm9l/EAgAAioQA=
Date: Mon, 9 Sep 2013 18:31:05 +0000
Message-ID: <1378751464.17982.13.camel@x230.lan>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	 <1378741786-18430-2-git-send-email-matthew.garrett@nebula.com>
	 <522DF6DC.1050303@zytor.com>
In-Reply-To: <522DF6DC.1050303@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:5d52:9ee3:3e84:6668]
x-forefront-prvs: 09645BAC66
x-forefront-antispam-report: SFV:NSPM;SFS:(377454003)(377424004)(479174003)(24454002)(51704005)(189002)(199002)(81816001)(81342001)(69226001)(65816001)(80022001)(46102001)(63696002)(51856001)(4396001)(76786001)(76796001)(81542001)(81686001)(47736001)(49866001)(50986001)(47976001)(36756003)(33646001)(74366001)(47446002)(74706001)(31966008)(74502001)(74662001)(74876001)(80976001)(83072001)(77982001)(59766001)(56776001)(54316002)(79102001)(77096001)(56816003)(53806001)(54356001)(76482001)(83322001)(19580405001)(19580395003)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB222;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:5d52:9ee3:3e84:6668;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <AAAADC9B8E65414AB9A274967479DDAC@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r89IVJIV022096

On Mon, 2013-09-09 at 09:27 -0700, H. Peter Anvin wrote:
> On 09/09/2013 08:49 AM, Matthew Garrett wrote:

> > +1:  Secure mode. If set, userspace will be unable to perform direct access
> > +    to PCI devices, port IO access, access system memory directly via
> > +    /dev/mem and /dev/kmem, perform kexec_load(), use the userspace
> > +    software suspend mechanism, insert new ACPI code at runtime via the
> > +    custom_method interface or modify CPU MSRs (on x86). Certain drivers
> > +    may also limit additional interfaces.
> > +
> 
> This will break or have to be redefined once you have signed kexec.

So, thinking about this, how about defining it as:

1:  Secure mode. If set, userspace will be prevented from performing any
operation that would permit the insertion of untrusted code into the
running kernel. At present this includes direct access to PCI devices,
port IO access,  direct system memory access via /dev/mem and /dev/kmem,
kexec_load(), the userspace software suspend mechanism, insertion of new
ACPI code at runtime via the custom_method interface or modification of
CPU MSRs (on x86). Certain drivers may also limit additional interfaces.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
