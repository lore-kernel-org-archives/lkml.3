Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaEWSxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:53:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:34759 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbaEWSxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:53:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,895,1392192000"; 
   d="scan'208";a="436178526"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chen Gong <gong.chen@linux.jf.intel.com>,
        "Park, Aiden" <aiden.park@intel.com>
Subject: RE: [RFC] Unnecessary work and noise from mce code in
 suspend/resume path
Thread-Topic: [RFC] Unnecessary work and noise from mce code in
 suspend/resume path
Thread-Index: AQHPdnVpXOjksG3qFEaIpmSn4pSF4JtOgq+A
Date: Fri, 23 May 2014 18:53:18 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3281B0F5@ORSMSX114.amr.corp.intel.com>
References: <5373bdc83257044f09@agluck-desk.sc.intel.com>
 <20140523105439.GD21332@pd.tnic>
In-Reply-To: <20140523105439.GD21332@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4NIrZmU005486

>> When we suspend a laptop we offline all but one processor. But
>> the mce code registers on a notify chain so it can clean up
>> some sysfs entries. Part of that code calls device_unregister()
>> which will fire kobject_uevent() which might wake up some user
>> code that is watching for such things.
>
> The issue being?
>
> It is not clear from the text what actually is the problem.

We are trying to suspend - and yet we are now having udev
woken up to run some scripts ... that will burn power ... which
is what we are trying to avoid when we shut the lid of the
laptop.  There might be some Android-isms involved too
that I don't understand.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
