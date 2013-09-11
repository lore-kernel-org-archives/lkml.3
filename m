Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab3IKSf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:35:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:8382 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129Ab3IKSf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:35:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,885,1371106800"; 
   d="scan'208";a="293658619"
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
Subject: RE: [PATCH 1/3] pstore: Adjust buffer size for compression for
 smaller registered buffers
Thread-Topic: [PATCH 1/3] pstore: Adjust buffer size for compression for
 smaller registered buffers
Thread-Index: AQHOrueI/ismTDcGZkqEOoiIbrzxU5nA27ig
Date: Wed, 11 Sep 2013 18:34:59 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31CF4C85@ORSMSX106.amr.corp.intel.com>
References: <20130911120639.27730.8671.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130911120639.27730.8671.stgit@aruna-ThinkPad-T420>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8BIZZto006992

-	big_oops_buf_sz = (psinfo->bufsize * 100) / 45;
+	big_oops_buf_sz = (psinfo->bufsize * 100) / cmpr;

Tested on an ERST backed system.  Seems to be working (we save a little less information
per ERST record than before this change (uncompressed size goes down from ~17500 to
~16400 bytes) - but this patch switched the denominator from 45 to 48 (for ERST) - so that
seems plausible.

Seiji: let me know how the efivars tests go.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
