Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbaJWRTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 13:19:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:10607 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755665AbaJWRTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:19:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,776,1406617200"; 
   d="scan'208";a="610093068"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Chen Yucong <slaoub@gmail.com>
CC: Andi Kleen <ak@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Subject: RE: [PATCH] x86, MCE: support memory error recovery for both UCNA
 and Deferred error in machine_check_poll
Thread-Topic: [PATCH] x86, MCE: support memory error recovery for both UCNA
 and Deferred error in machine_check_poll
Thread-Index: AQHP5FAMtVPteB+EEE28SKVlaIO66Jw+CiWA///2T6A=
Date: Thu, 23 Oct 2014 17:18:29 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3290F9B0@ORSMSX114.amr.corp.intel.com>
References: <1412921020.3631.7.camel@debian> <20141023104717.GB4619@pd.tnic>
In-Reply-To: <20141023104717.GB4619@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9NHJP38017764

> The general idea of preemptively poisoning pages which contain deferred
> errors is fine though.

Agreed. I used to think that it wasn't likely to be very useful because in many
cases the UCNA errors are just a trail of breadcrumbs set by different units
on the chip as the poison passed through on the way to consumption - where
there would be a fatal (or recoverable) error.

But recently I found that a partial write to a poisoned cache line only sets the
trail of UCNA errors - there is no consumption, so no machine check.  So in
this case it would definitely be worthwhile to trigger the same action that we
do for SRAO to unmap the page before someone does do a read.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
