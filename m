Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160AbaKFVYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:24:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:57291 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaKFVYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:24:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,327,1413270000"; 
   d="scan'208";a="627941445"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Chen Yucong <slaoub@gmail.com>, "ak@linux.intel.com" <ak@linux.intel.com>,
        "aravind.gopalakrishnan@amd.com" <aravind.gopalakrishnan@amd.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2 v2] x86, mce, severity: extend the the mce_severity
Thread-Topic: [PATCH 1/2 v2] x86, mce, severity: extend the the mce_severity
Thread-Index: AQHP+LPxnTcFzUHCrEu4gxFYauoR5JxUQ1cA//+R0PCAAJywAP//e56AgACOCAD//6GU8A==
Date: Thu, 6 Nov 2014 21:24:01 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F329246B2@ORSMSX114.amr.corp.intel.com>
References: <1415162873-1874-1-git-send-email-slaoub@gmail.com>
 <1415162873-1874-2-git-send-email-slaoub@gmail.com>
 <20141106153539.GC4318@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F329240AE@ORSMSX114.amr.corp.intel.com>
 <20141106182206.GG4318@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3292433C@ORSMSX114.amr.corp.intel.com>
 <20141106185638.GH4318@pd.tnic>
In-Reply-To: <20141106185638.GH4318@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sA6LOG7V007147

> I'm under the assumption that at all times, when we get a MCE, MCIP will
> be set. For example, mce_gather_info() reads MCG_STATUS before we call
> mce_severity() in do_machine_check().
>
> Or am I missing something?

Architecturally it is true that MCIP will be set when machine check is signaled.
But, sometimes there are bugs. BIOS has a hook to get an SMI to see the
event before the OS sees the machine check - which gives lots of scope for
things to not happen by the book.  If MCIP isn't set correctly, I'd like to get
on and panic quickly - because all sorts of bad things will happen if a nested
machine check happens and isn't caught because MCIP wasn't set in the first
machine check.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
