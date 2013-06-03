Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543Ab3FCO7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 10:59:09 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:22549
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757296Ab3FCO7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 10:59:07 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Matt Fleming <matt.fleming@intel.com>
CC: "rja@sgi.com" <rja@sgi.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "bp@alien8.de" <bp@alien8.de>, "jkosina@suse.cz" <jkosina@suse.cz>,
        "jlee@suse.com" <jlee@suse.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] Modify UEFI anti-bricking code
Thread-Topic: [PATCH] Modify UEFI anti-bricking code
Thread-Index: AQHOXwRQ69J870D+8ESfIa4gHR89tpkj6rkAgAAs8gA=
Date: Mon, 3 Jun 2013 14:58:50 +0000
Message-ID: <1370271528.6315.5.camel@x230.lan>
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
	 <51AC8974.4010102@intel.com>
In-Reply-To: <51AC8974.4010102@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
x-forefront-antispam-report: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:BL2PR05MB209;H:BL2PR05MB211.namprd05.prod.outlook.com;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <B87F662C21C1BB478E88B1871A23DD66@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r53ExCEh008367

On Mon, 2013-06-03 at 13:17 +0100, Matt Fleming wrote:

> Do we really want to drop this hunk? The point of this code was to
> inform firmware vendors that their implementation is returning funky
> results, and that they should look into why it's doing that.

We're not doing anything with that information now, and I don't think we
can do anything meaningful with it - some implementations report the
maximum size as the maximum supported by the implementation, and some
report it as the maximum that can be written given the amount of space
currently available. So yeah, it's against the spec to report 0 here,
but any other value is equally useless to us, so it seems like something
we'd be complaining about for no reason.

> What's the origin of this guid? And should we be adding it to
> include/linux/efi.h?

It's a scratch guid that's randomly generated to avoid colliding with
any other guid - we want to avoid this ever being a real variable.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
