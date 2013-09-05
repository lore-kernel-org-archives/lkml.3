Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3IED6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 23:58:52 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:13424
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753829Ab3IED6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 23:58:50 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>
Subject: Re: [PATCH V3 03/11] x86: Lock down IO port access when module
 security is enabled
Thread-Topic: [PATCH V3 03/11] x86: Lock down IO port access when module
 security is enabled
Thread-Index: AQHOqQBh9VrXJc6zbUqVxxtEmQPfAJm2hJUAgAAB2AA=
Date: Thu, 5 Sep 2013 03:58:45 +0000
Message-ID: <1378353524.13193.26.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-4-git-send-email-matthew.garrett@nebula.com>
	 <5227FFE8.5050102@zytor.com>
In-Reply-To: <5227FFE8.5050102@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [209.6.207.143]
x-forefront-prvs: 096029FF66
x-forefront-antispam-report: SFV:NSPM;SFS:(479174003)(377454003)(24454002)(189002)(199002)(377424004)(51704005)(51856001)(4396001)(66066001)(33716001)(80022001)(83072001)(59766001)(46102001)(77982001)(65816001)(81816001)(33646001)(81686001)(79102001)(81342001)(50986001)(47976001)(47736001)(49866001)(74876001)(54356001)(76482001)(81542001)(54316002)(56776001)(63696002)(74502001)(31966008)(74662001)(47446002)(19580405001)(74706001)(83322001)(56816003)(77096001)(76786001)(76796001)(69226001)(74366001)(19580395003)(80976001)(53806001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB224;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:209.6.207.143;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <20382F52C93E8C47A347896EBF08F954@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r853wu4n027492

On Wed, 2013-09-04 at 20:52 -0700, H. Peter Anvin wrote:
> On 09/03/2013 04:50 PM, Matthew Garrett wrote:
> > IO port access would permit users to gain access to PCI configuration
> > registers, which in turn (on a lot of hardware) give access to MMIO register
> > space. This would potentially permit root to trigger arbitrary DMA, so lock
> > it down by default.
> > 
> > Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> 
> Seriously... just deny CAP_SYS_RAWIO to any system in secure mode.

No. CAP_SYS_RAWIO blocks things that we don't want blocked (x86
microcode updates, various disk ioctls, *device firmware uploads* and a
few others) - the semantics just don't match. We could relax those
permissions, but then we'd potentially break someone else's security
considerations.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
