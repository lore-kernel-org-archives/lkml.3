Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3FFFm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 01:42:28 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:27712
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752773Ab3FFFmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 01:42:23 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: joeyli <jlee@suse.com>
CC: Matt Fleming <matt@console-pimps.org>,
        "Fleming, Matt" <matt.fleming@intel.com>, "rja@sgi.com" <rja@sgi.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "bp@alien8.de" <bp@alien8.de>, "jkosina@suse.cz" <jkosina@suse.cz>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "oneukum@suse.de" <oneukum@suse.de>
Subject: Re: [PATCH] Modify UEFI anti-bricking code
Thread-Topic: [PATCH] Modify UEFI anti-bricking code
Thread-Index: AQHOXwRQ69J870D+8ESfIa4gHR89tpkkLJYAgAAE7oCAALmWgIACTrOAgAABCYCAABJVAIAA26IAgAAKTIA=
Date: Thu, 6 Jun 2013 05:42:01 +0000
Message-ID: <1370497321.6315.44.camel@x230.lan>
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
	 <1370276021.30695.4.camel@linux-s257.site>
	 <1370277079.6315.14.camel@x230.lan>
	 <1370316933.30695.7.camel@linux-s257.site>
	 <CAL01qptzxe5L6Vq+nBZLq+bQNxbe_i_2OdKMNJGZQDfMihaHOw@mail.gmail.com>
	 <1370444007.6315.32.camel@x230.lan>
	 <20130605155904.GC30420@console-pimps.org>
	 <1370495110.6523.35.camel@linux-s257.site>
In-Reply-To: <1370495110.6523.35.camel@linux-s257.site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
x-forefront-antispam-report: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:BY2PR05MB221;H:BY2PR05MB222.namprd05.prod.outlook.com;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <62F8B28132E0B941AD9817AEE13168B5@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r565gnvY007903

On Thu, 2013-06-06 at 13:05 +0800, joeyli wrote:

> +		if (!(attributes & EFI_VARIABLE_NON_VOLATILE))
> +			return EFI_OUT_OF_RESOURCES;

I'd move this up to the top of the function, and just return 0 - there's
no risk of the firmware causing problems if it's a volatile variable, so
we should probably just pass it down to the firmware and return an error
from there.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
