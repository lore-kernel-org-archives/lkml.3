Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab3EXUQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 16:16:34 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:6714
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756709Ab3EXUQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 16:16:33 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 May 2013 16:16:33 EDT
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Russ Anderson <rja@sgi.com>
CC: Matt Fleming <matt@console-pimps.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Thread-Topic: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Thread-Index: AQHOVwlPdAxADEfBGkSu955aMbeVBpkSq3mAgACPxACAALt2gIAAz1mAgAABeYA=
Date: Fri, 24 May 2013 20:11:01 +0000
Message-ID: <1369426255.2217.9.camel@x230>
References: <20130522162747.GA20816@sgi.com>
	 <20130523115801.GJ14575@console-pimps.org> <20130523203234.GD20913@sgi.com>
	 <20130524074331.GL14575@console-pimps.org> <20130524200539.GA3322@sgi.com>
In-Reply-To: <20130524200539.GA3322@sgi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
x-forefront-antispam-report: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:BL2PR05MB210;H:BL2PR05MB211.namprd05.prod.outlook.com;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <57B58A5C84456A4E8B5B8EA858867C69@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4OKGdQl013955

On Fri, 2013-05-24 at 15:05 -0500, Russ Anderson wrote:

> One other data point is if the query_variable_info call is hacked to
> remove one of the EFI flags (ie comment out EFI_VARIABLE_BOOTSERVICE_ACCESS)
> the efi_call_phys4() call fails with EFI_INVALID_PARAMETER and
> the system boots.  Of course it does not create /sys/firmware/efivars
> entries and complains "[Firmware Bug]: efi: Inconsistent initial sizes".
> But at least it boots.

EFI_VARIABLE_RUNTIME_ACCESS is only legal if
EFI_VARIABLE_BOOTSERVICE_ACCESS is set, so it's correct to throw
EFI_INVALID_PARAMETER there.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
