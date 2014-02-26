Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbaBZWsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 17:48:54 -0500
Received: from mail-bl2lp0206.outbound.protection.outlook.com ([207.46.163.206]:8364
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752603AbaBZWsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 17:48:53 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>
CC: "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Subject: Re: [PATCH 12/12] Add option to automatically set trusted_kernel
 when in Secure Boot mode
Thread-Topic: [PATCH 12/12] Add option to automatically set trusted_kernel
 when in Secure Boot mode
Thread-Index: AQHPMy+YI6SzIeT3jk2nIdGkqUBmB5rIIXaAgAAB7gA=
Date: Wed, 26 Feb 2014 22:48:38 +0000
Message-ID: <1393454916.14900.54.camel@x230>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	 <1393445473-15068-13-git-send-email-matthew.garrett@nebula.com>
	 <20140226224141.1741a746@alan.etchedpixels.co.uk>
In-Reply-To: <20140226224141.1741a746@alan.etchedpixels.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(377424004)(24454002)(65816001)(56816005)(80022001)(85852003)(83072002)(90146001)(95666003)(63696002)(69226001)(95416001)(81816001)(46102001)(81342001)(56776001)(92566001)(92726001)(81542001)(59766001)(77982001)(79102001)(81686001)(74366001)(54316002)(33716001)(33646001)(83322001)(94946001)(4396001)(19580405001)(19580395003)(76482001)(94316002)(47736001)(49866001)(77096001)(85306002)(50986001)(47976001)(74876001)(76786001)(86362001)(54356001)(74502001)(76796001)(47446002)(80976001)(31966008)(93136001)(74706001)(87936001)(74662001)(2656002)(93516002)(87266001)(53806001)(51856001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB424;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:E0D6F124.EFD19421.61F3A780.88C4FD5D.20331;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <57C333CE7C86484C92E9550F2ACA27D6@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1QMn0nr002553

On Wed, 2014-02-26 at 22:41 +0000, One Thousand Gnomes wrote:

> I think you have a load more cases to attempt to paper over before you
> even pretend to achieve that goal. Firewire for example. Also it only
> remotely begins to work if you also force CAP_SYS_RAWIO off globally as
> you need to force off things like raw command issuing to various
> controllers (especially as some of that code is written on the basis that
> 'its RAWIO, screw making it secure and doing all the checks we could
> bother with'.

Physical presence is required to do anything meaningful with firewire,
and UEFI secure boot isn't intended to protect against that. Which
controllers will trigger arbitrary DMA in response to raw commands?

> RAWIO also disables things like CPU msr access - which is also quite
> adequate for subverting a kernel.

Patch 7.

> Another issue that needs addressing is firmware. Quite a few of our
> request_firmware cases load device firmware which is not signed into DMA
> capable hardware. Probably also worth checking what the
> architectural guarantees on bogus microcode updates is. Maybe we need
> firmware signing for such cases to match the mod signing ?

Vendors keep telling me that they're validating firmware for new
hardware, and I keep tending not to believe them. Meh. The big problem
with firmware signatures is that we don't necessarily have the right to
distribute modified versions of the firmware, so we'd need detached
signature support. I'm certainly not against this.

> I'm trying to think what else. Possibly disabling it on Pentium-M with
> the rep movs erratum (Y19) as it's quite possible to set up suitable
> adjacent page sets in user space via the graphics.

Quirking this out when the hardware makes it impossible to provide any
guarantees seems reasonable.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
