Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbaKFScl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:32:41 -0500
Received: from mga03.intel.com ([134.134.136.65]:32423 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbaKFScj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:32:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,327,1413270000"; 
   d="scan'208";a="603645499"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Chen Yucong <slaoub@gmail.com>, "ak@linux.intel.com" <ak@linux.intel.com>,
        "aravind.gopalakrishnan@amd.com" <aravind.gopalakrishnan@amd.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2 v2] x86, mce, severity: extend the the mce_severity
Thread-Topic: [PATCH 1/2 v2] x86, mce, severity: extend the the mce_severity
Thread-Index: AQHP+LPxnTcFzUHCrEu4gxFYauoR5JxUQ1cA//+R0PCAAJywAP//e56A
Date: Thu, 6 Nov 2014 18:32:37 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3292433C@ORSMSX114.amr.corp.intel.com>
References: <1415162873-1874-1-git-send-email-slaoub@gmail.com>
 <1415162873-1874-2-git-send-email-slaoub@gmail.com>
 <20141106153539.GC4318@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F329240AE@ORSMSX114.amr.corp.intel.com>
 <20141106182206.GG4318@pd.tnic>
In-Reply-To: <20141106182206.GG4318@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sA6IWkMl006078

> Basically, this check is being done only for machine check exceptions
> only.

But you proposed setting excp by looking at mcg_status:
> excp = ((m->mcg_status & MCG_STATUS_MCIP) ? EXCP_CONTEXT : NO_EXCP);

Which makes the code rather self referential.  If we actually did arrive in MCE handler
with MCIP == 0 ... then your code would pretend that we'd arrived here from the
poll code, and skip over the test for MCIP - so fail to report that MCIP wasn't set.

-Tony

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
