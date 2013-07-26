Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab3GZIQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 04:16:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:34591 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab3GZIQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 04:16:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,749,1367996400"; 
   d="scan'208";a="273625725"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Zheng, Lv" <lv.zheng@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH 06/13] ACPI/IPMI: Add reference counting for ACPI
 operation region handlers
Thread-Topic: [PATCH 06/13] ACPI/IPMI: Add reference counting for ACPI
 operation region handlers
Thread-Index: AQHOh3wWhtcRfGeNDUSAzJ7WvM5MAZl1Zu+AgADNjlCAAGyHIA==
Date: Fri, 26 Jul 2013 08:15:56 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E8802435E11@SHSMSX101.ccr.corp.intel.com>
References: <cover.1370652213.git.lv.zheng@intel.com>
 <cover.1374566394.git.lv.zheng@intel.com>
 <d9d5acba01eb80580e7696c50db4263ded86a86c.1374566394.git.lv.zheng@intel.com>
 <2501577.sf07PMEtR1@vostro.rjw.lan>
 <1AE640813FDE7649BE1B193DEA596E8802435B7C@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E8802435B7C@SHSMSX101.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6Q8GXk9009791

> From: linux-acpi-owner@vger.kernel.org
> [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Zheng, Lv
> Sent: Friday, July 26, 2013 9:54 AM
> To: Rafael J. Wysocki
> Cc: Wysocki, Rafael J; Brown, Len; linux-kernel@vger.kernel.org;
> linux-acpi@vger.kernel.org
> Subject: RE: [PATCH 06/13] ACPI/IPMI: Add reference counting for ACPI
> operation region handlers
> 
> > From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> > Sent: Friday, July 26, 2013 5:29 AM
> >
> > On Tuesday, July 23, 2013 04:09:43 PM Lv Zheng wrote:
> > > This patch adds reference couting for ACPI operation region handlers
> > > to fix races caused by the ACPICA address space callback invocations.
> > >
> > > ACPICA address space callback invocation is not suitable for Linux
> > > CONFIG_MODULE=y execution environment.
> >
> > Actually, can you please explain to me what *exactly* the problem is?
> 
> OK.  I'll add race explanations in the next revision.
> 
> The problem is there is no "lock" held inside ACPICA for invoking operation
> region handlers.
> Thus races happens between the acpi_remove/install_address_space_handler
> and the handler/setup callbacks.

This seems not a good explanation of the intent of this patch.
I think the intent is here in the patch description:

1. It acts as a barrier for operation region callbacks - no callback will
   happen after acpi_unregister_region().
2. acpi_unregister_region() is safe to be called in moudle->exit()
   functions.

Hmm, maybe I need to re-order the patch description for this patch.

Thanks for commenting.

Best regards
-Lv

> 
> This is correct per ACPI specification.
> As if there is interpreter locks held for invoking operation region handlers, the
> timeout implemented inside the operation region handlers will make all locking
> facilities (Acquire or Sleep,...) timed out.
> Please refer to ACPI specification "5.5.2 Control Method Execution":
> Interpretation of a Control Method is not preemptive, but it can block. When a
> control method does block, OSPM can initiate or continue the execution of a
> different control method. A control method can only assume that access to
> global objects is exclusive for any period the control method does not block.
> 
> So it is pretty much likely that ACPI IO transfers are locked inside the operation
> region callback implementations.
> Using locking facility to protect the callback invocation will risk dead locks.
> 
> Thanks
> -Lv
> 
> > Rafael
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
