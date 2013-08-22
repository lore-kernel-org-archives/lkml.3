Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab3HVXR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 19:17:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:16561 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384Ab3HVXRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 19:17:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,937,1367996400"; 
   d="scan'208";a="285583859"
From: "Luck, Tony" <tony.luck@intel.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>,
        Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>
CC: "jkenisto@linux.vnet.ibm.com" <jkenisto@linux.vnet.ibm.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "mahesh@linux.vnet.ibm.com" <mahesh@linux.vnet.ibm.com>,
        "ccross@android.com" <ccross@android.com>
Subject: RE: [RFC PATCH v2 04/11] pstore: Add compression support to pstore
Thread-Topic: [RFC PATCH v2 04/11] pstore: Add compression support to pstore
Thread-Index: AQHOmoMbiAeVAEJI6Eexn1HhYtGcd5miWTOA//+LrwA=
Date: Thu, 22 Aug 2013 23:17:10 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31CC7AC0@ORSMSX106.amr.corp.intel.com>
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
 <20130816131805.3338.68767.stgit@aruna-ThinkPad-T420>
 <A5ED84D3BB3A384992CBB9C77DEDA4D443E8F0D7@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D443E8F0D7@USINDEM103.corp.hds.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7MNHVdv002253

<1>[  383.209057] RIP  [<ffffffff813d3946>] sysrq_handle_crash+0x16/0x20
<4>[  383.209057]  RSP <ffff88006f551e80>
<4>[  383.209057] CR2: 0000000000000000
<4>[  383.209057] ---[ end trace 04a1cddad37b4b33 ]---
<3>[  383.209057] pstore: compression failed for Part 2 returned -5
<3>[  383.209057] pstore: Capture uncompressed oops/panic report of Part 2
<3>[  383.209057] pstore: compression failed for Part 5 returned -5

Interesting.  With ERST backend I didn't see these messages.  Traces in 
pstore recovered files go as far as the line before the "---[ end trace 04a1cddad37b4b33 ]---"

Why the difference depending on which back end is in use?

But I agree that we shouldn't have these messages.  They use up space
in the persistent store that could be better used saving some more lines
from earlier in the console log.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
