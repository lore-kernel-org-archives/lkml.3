Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaKJXcQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 18:32:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:53367 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbaKJXcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 18:32:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,355,1413270000"; 
   d="scan'208";a="605603304"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
CC: Chen Yucong <slaoub@gmail.com>, "ak@linux.intel.com" <ak@linux.intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 1/2] x86, mce, severity: extend the the mce_severity
 mechanism to handle UCNA/DEFERRED error
Thread-Topic: [PATCH v3 1/2] x86, mce, severity: extend the the mce_severity
 mechanism to handle UCNA/DEFERRED error
Thread-Index: AQHP+vUgoD/q7VyRgEG5Av0WO+I2NJxa9TcAgAADNAD//4mloA==
Date: Mon, 10 Nov 2014 23:32:12 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F329282FA@ORSMSX114.amr.corp.intel.com>
References: <1415410821-15063-1-git-send-email-slaoub@gmail.com>
 <1415410821-15063-2-git-send-email-slaoub@gmail.com>
 <546136C8.5060104@amd.com> <20141110221728.GA23419@pd.tnic>
In-Reply-To: <20141110221728.GA23419@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAANWM7d032445

But then I tested it ...

I injected a UC error to memory - then did a simple byte write to the target line.
This resulted in two banks logging errors:

[  124.638045] poll: CPU54 saw ec00000000010092 in bank 7
[  124.639006] poll: severity = 0
[  124.647333] poll: CPU54 saw b800000000200179 in bank 3
[  124.648322] poll: severity = 1

The bank 7 error reported as severity 0 because EN=0 ... so we took no action for it.

The bank 3 error got past that hurdle, then through the next BIT(8) set indicates a
cache error. Fell at the last check because ADDRV=0.


I think the severity table entry for the "EN" check should have been skipped
when calling from the CMCI handler. Then we would have seen severity=1
from the bank 7 error.  It would have passed the other tests too (BIT(7) and
ADDRV).

-Tony


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
