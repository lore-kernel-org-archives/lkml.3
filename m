Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab3JRWWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 18:22:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:22491 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757065Ab3JRWWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 18:22:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,525,1378882800"; 
   d="scan'208";a="395174294"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        "joe@perches.com" <joe@perches.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "arozansk@redhat.com" <arozansk@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 4/9] ACPI, x86: Extended error log driver for x86
 platform
Thread-Topic: [PATCH v3 4/9] ACPI, x86: Extended error log driver for x86
 platform
Thread-Index: AQHOy92NO8Ykl3Pixk2WuH27ZgvdfZn621sAgAAEVACAAAzW0IAAgtiA//+ZORA=
Date: Fri, 18 Oct 2013 22:22:26 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D41FD3@ORSMSX106.amr.corp.intel.com>
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
 <1382084624-10857-5-git-send-email-gong.chen@linux.intel.com>
 <52612BA4.2060906@linux.vnet.ibm.com> <20131018125326.GC1007@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31D41E37@ORSMSX106.amr.corp.intel.com>
 <20131018212741.GA26049@pd.tnic>
In-Reply-To: <20131018212741.GA26049@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9IMMsk7021010

@@ -154,6 +154,10 @@ void mce_log(struct mce *mce)
 	/* Emit the trace record: */
 	trace_mce_record(mce);
 
+	if (mce_ext_err_print)
+		if (mce_ext_err_print(NULL, m.extcpu, i))
+			return;
+
 	ret = atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, mce);
 	if (ret == NOTIFY_STOP)
 		return;

If we move mce_ext_err_print() this far ... then it's only one line further down
to have it be part of the x86_mce_decoder_chain as suggested by Naveen.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
