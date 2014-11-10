Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaKJVoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 16:44:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:58619 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbaKJVo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 16:44:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,355,1413270000"; 
   d="scan'208";a="629766233"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Chen Yucong <slaoub@gmail.com>
CC: "ak@linux.intel.com" <ak@linux.intel.com>,
        "aravind.gopalakrishnan@amd.com" <aravind.gopalakrishnan@amd.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 2/2] x86, mce: support memory error recovery for both
 UCNA and Deferred error in machine_check_poll
Thread-Topic: [PATCH v3 2/2] x86, mce: support memory error recovery for
 both UCNA and Deferred error in machine_check_poll
Thread-Index: AQHP+vUszT5ByudVb0mBAEdijOAoW5xawwCAgAAqPgD//3qvgA==
Date: Mon, 10 Nov 2014 21:44:26 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F329281E9@ORSMSX114.amr.corp.intel.com>
References: <1415410821-15063-1-git-send-email-slaoub@gmail.com>
 <1415410821-15063-3-git-send-email-slaoub@gmail.com>
 <20141110190617.GJ4359@pd.tnic> <20141110213728.GN4359@pd.tnic>
In-Reply-To: <20141110213728.GN4359@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAALibRr032043

> In fact, you could redo this patch in the meantime without the AMD vendor
> check so that Tony can pick them up soon. I'll add the correct AMD bits
> later.

You just want this hunk deleted ...

+	if (c->x86_vendor == X86_VENDOR_AMD) {
+		/*
+		 * AMD BKDGs - Machine Check Error Codes
+		 *
+		 * Bit 8 of ErrCode[15:0] of MCi_STATUS is used for indicating
+		 * a memory-specific error. Note that this field encodes info-
+		 * rmation about memory-hierarchy level involved in the error.
+		 */
+		return (m->status & 0xff00) == BIT(8);
+	} else

I can do that without a repost.  Or I can leave a reminder ...

+	if (c->x86_vendor == X86_VENDOR_AMD) {
+		/*
+		 * coming soon
+		 */
+		return false;
+	} else

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
