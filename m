Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbaDHWfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 18:35:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:25285 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288AbaDHWfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 18:35:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,821,1389772800"; 
   d="scan'208";a="509654539"
From: "Luck, Tony" <tony.luck@intel.com>
To: Jason Baron <jbaron@akamai.com>, Borislav Petkov <bp@alien8.de>
CC: "hpa@zytor.com" <hpa@zytor.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "mitake@dcl.info.waseda.ac.jp" <mitake@dcl.info.waseda.ac.jp>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] ie31200_edac: Add driver
Thread-Topic: [PATCH 3/3] ie31200_edac: Add driver
Thread-Index: AQHPUErabVWTFTq13UyiP3ii3SIN9psH6TsAgADb+YD//4z98A==
Date: Tue, 8 Apr 2014 22:34:15 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31E21864@ORSMSX106.amr.corp.intel.com>
References: <cover.1396645124.git.jbaron@akamai.com>
 <760765424abe31811027ff3efd078bc858b7d3ed.1396645124.git.jbaron@akamai.com>
 <20140408090924.GE30077@pd.tnic> <5344754B.8050909@akamai.com>
In-Reply-To: <5344754B.8050909@akamai.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s38Ma1rf015048

>> Btw, this driver is polling, AFAICT. Doesn't e3-12xx support the CMCI
>> interrupt which you can feed into this driver directly and thus not need
>> the polling at all?
>
> On the system with the ce and ue events that I'm testing on, I don't see
> 'MCE' nudge above 0, in /proc/interrupts. So I think that implies that
> we are not getting any CMCI there?

CMCI will bump up the "THR" (Threshold) entries in /proc/interrupts.

> So if possible maybe we can confirm with Intel whether we expect an MCE
> for memory errors...

MCG_CAP bit 10 tells you whether a given processor implements CMCI.
If that is set - then MCi_CTL2 bit 30 indicates whether a given bank
supports it (Linux tries to set this bit, if it sticks, then it knows that CMCI
is supported - Linux also assigns ownership of the bank to the first cpu
to successfully set it (since a bank may be shared by multiple threads/cores
on a package).

Consumed uncorrectable errors should generate a machine check. Which
on the E3-12xx series will be a fatal machine check: MCi_STATUS.PCC=1

-Tony

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
