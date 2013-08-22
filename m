Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab3HVDdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 23:33:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:2062 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab3HVDdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 23:33:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,932,1367996400"; 
   d="scan'208";a="285147240"
From: "Li, Fei" <fei.li@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "holt@sgi.com" <holt@sgi.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] reboot: perform warm/cold reset correctly for CF9 type
Thread-Topic: [PATCH] reboot: perform warm/cold reset correctly for CF9 type
Thread-Index: AQHOnkAyupFWw/TFQUeMMS/7isOBqpmevtGAgACNFwD//41LAIABqn5w
Date: Thu, 22 Aug 2013 03:32:40 +0000
Message-ID: <BEC9F67575FA1E429CA7CF5AE9BE3634012EDD40@SHSMSX104.ccr.corp.intel.com>
References: <1377049949.18357.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <20130821072940.GB27495@gmail.com>
 <69b80c44-3245-4393-b6e9-4d8a7f3d3c66@email.android.com>
 <BEC9F67575FA1E429CA7CF5AE9BE3634012ED68C@SHSMSX104.ccr.corp.intel.com>
 <7233d29e-ea01-4eb6-8018-b9c8e3730a30@email.android.com>
In-Reply-To: <7233d29e-ea01-4eb6-8018-b9c8e3730a30@email.android.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7M3XF26027753

> Subject: RE: [PATCH] reboot: perform warm/cold reset correctly for CF9 type
> 
> The thing is that the existing "warm" and "cold" means something different, I
> believe (skip post vs do post.)  It is possible it just works, but it would be good to
> know which platforms or works on.
> 
> Also, why do you need the cf9 boot method at all?  All current systems * should
> * use the ACPI method.
> 

In fact, ACPI method also implements reset by writing RESET_VALUE into RESET_REG
port. In our platform, it also uses port 0xCF9. The difference between cold and wart reset
is whether power cycle is involved or not. After all, this is another topic.

>From the source code, CF9 boot method are still used by some apple MAC and dell
platforms if I understand correctly.

Back to our patch, if you really concern the effect of cold reboot 0x0E to current existed
platforms, we can set the default value of reboot_mode as REBOOT_WARM.

Does it make sense?

Thanks,
Fei
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
