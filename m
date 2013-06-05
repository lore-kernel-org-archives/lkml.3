Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab3FEQI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 12:08:57 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:11912
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755655Ab3FEQI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 12:08:56 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Matt Fleming <matt@console-pimps.org>
CC: "Fleming, Matt" <matt.fleming@intel.com>, joeyli <jlee@suse.com>,
        "rja@sgi.com" <rja@sgi.com>, "mingo@kernel.org" <mingo@kernel.org>,
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
Thread-Index: AQHOXwRQ69J870D+8ESfIa4gHR89tpkkLJYAgAAE7oCAALmWgIACTrOAgAABCYCAABJVAIAAAq6A
Date: Wed, 5 Jun 2013 16:08:39 +0000
Message-ID: <1370448519.6315.36.camel@x230.lan>
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
	 <1370276021.30695.4.camel@linux-s257.site>
	 <1370277079.6315.14.camel@x230.lan>
	 <1370316933.30695.7.camel@linux-s257.site>
	 <CAL01qptzxe5L6Vq+nBZLq+bQNxbe_i_2OdKMNJGZQDfMihaHOw@mail.gmail.com>
	 <1370444007.6315.32.camel@x230.lan>
	 <20130605155904.GC30420@console-pimps.org>
In-Reply-To: <20130605155904.GC30420@console-pimps.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
x-forefront-antispam-report: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:BY2PR05MB222;H:BY2PR05MB222.namprd05.prod.outlook.com;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <2DCA9AAFD6F52F41AA2F8C296796801F@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r55G963L001403

On Wed, 2013-06-05 at 16:59 +0100, Matt Fleming wrote:

> +	/* clean DUMMY object */
> +	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID, 0, 0, NULL);

Hm. Actually, is that going to work? From the spec:

If a preexisting variable is rewritten with different attributes,
SetVariable()shall not modify the variable and shall return
EFI_INVALID_PARAMETER. 

So I think we probably need to fix the attributes to NV|RT|BS for both
this call and the one in query_variable_store. We should probably also
only do the workaround if the NV bit is set in the original query.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
