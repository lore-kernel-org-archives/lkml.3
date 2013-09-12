Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab3ILRn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:43:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:63630 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab3ILRn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:43:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,891,1371106800"; 
   d="scan'208";a="402457422"
From: "Luck, Tony" <tony.luck@intel.com>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "seiji.aguchi@hds.com" <seiji.aguchi@hds.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>
CC: "jkenisto@linux.vnet.ibm.com" <jkenisto@linux.vnet.ibm.com>,
        "mahesh@linux.vnet.ibm.com" <mahesh@linux.vnet.ibm.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "ccross@android.com" <ccross@android.com>
Subject: RE: [PATCH v2] pstore: Adjust buffer size for compression for
 smaller registered buffers
Thread-Topic: [PATCH v2] pstore: Adjust buffer size for compression for
 smaller registered buffers
Thread-Index: AQHOr4R5BRhqzPStTkiO0wfSOra2NpnCXxWg
Date: Thu, 12 Sep 2013 17:43:56 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31CF6AB8@ORSMSX106.amr.corp.intel.com>
References: <20130912064832.15340.52422.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130912064832.15340.52422.stgit@aruna-ThinkPad-T420>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8CHi5x9014566

+	default:
+		cmpr = 60;
+		break;
+	}
 
Is this the right "default"?  It may be a good choice for a backend with a really
tiny buffer (1 ... 999).  But less good for a (theoretical) backend with a larger
buffer (10001 ... infinity and beyond).  Which are you trying to catch here?

-Tony

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
