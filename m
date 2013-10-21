Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab3JUROJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 13:14:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:22851 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab3JUROH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 13:14:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="396241817"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "bp@alien8.de" <bp@alien8.de>, "joe@perches.com" <joe@perches.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "arozansk@redhat.com" <arozansk@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chen Gong <gong.chen@linux.intel.com>
Subject: RE: [PATCH v3 8/9] ACPI, APEI, CPER: Cleanup CPER memory error
 output format
Thread-Topic: [PATCH v3 8/9] ACPI, APEI, CPER: Cleanup CPER memory error
 output format
Thread-Index: AQHOy92plRjhtpgznEKRMXMo82fJkJn60SKAgAGIuQCAA3dMgP//l3xQ
Date: Mon, 21 Oct 2013 17:14:05 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D45B22@ORSMSX106.amr.corp.intel.com>
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
 <1382084624-10857-9-git-send-email-gong.chen@linux.intel.com>
 <52612311.2000303@linux.vnet.ibm.com>
 <20131019112658.GB16597@gchen.bj.intel.com>
 <526554D3.9050902@linux.vnet.ibm.com>
In-Reply-To: <526554D3.9050902@linux.vnet.ibm.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9LHEDDo001213

>>>> +	if (severity != CPER_SEV_FATAL)
>>>
>>> Shouldn't this just be (severity == CPER_SEV_CORRECTED)?


>> IMO, only fatal error can't be handlered gracefully in current
>> kernel plus H/W. Once it can be recovered by H/W and OS, we
>> can call it recovered.

> Sure, but we don't recover in all scenarios. So, calling it corrected 
> seems incorrect to me.

Even if we recovered from a UC error (which is by no means a sure
thing) ... I don't think the "requires no further action" message applies.

Soft single bit errors are common (well, common-ish ... they should still
be somewhat rare by most objective standard).  Double bit errors are
much rarer ... and are very unlikely to be the result of two single bit errors
happening to be inside the same cache line.  I'd recommend further investigation
of the source of a UC error (even one that is "recovered" in software).

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
