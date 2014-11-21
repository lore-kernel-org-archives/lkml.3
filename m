Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaKUVcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:32:00 -0500
Received: from mga14.intel.com ([192.55.52.115]:52314 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbaKUVb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:31:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,432,1413270000"; 
   d="scan'208";a="626397735"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: rui wang <ruiv.wang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "Wang, Rui Y" <rui.y.wang@intel.com>
Subject: RE: [PATCH v3] x86/mce: Try printing all machine check banks known
 before panic
Thread-Topic: [PATCH v3] x86/mce: Try printing all machine check banks known
 before panic
Thread-Index: AQHQA9xP2DKrYSRRjki1N/RiQcamCZxoRecAgABTjfCAATqkgIAA/RuAgAEBPQD//4MAkIAAlq0A//+wGfA=
Date: Fri, 21 Nov 2014 21:31:56 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F329504FD@ORSMSX114.amr.corp.intel.com>
References: <1416388961-24159-1-git-send-email-ruiv.wang@gmail.com>
 <20141119102954.GA5617@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3294198E@ORSMSX114.amr.corp.intel.com>
 <20141120101505.GA791@pd.tnic>
 <CANVTcTa++Ef04JSYpfrCVuua5B0Wv=ASyr_H7nfHSQ-vC9GV3Q@mail.gmail.com>
 <20141121164140.GA4274@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3294F888@ORSMSX114.amr.corp.intel.com>
 <20141121181334.GC4274@pd.tnic>
In-Reply-To: <20141121181334.GC4274@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sALLW65A021332

>
>        /*
>         * No machine check event found. Must be some external
>         * source or one CPU is hung. Panic.
>         */
>        if (global_worst <= MCE_KEEP_SEVERITY && mca_cfg.tolerant < 3)
>                mce_panic("Machine check from unknown source", NULL, NULL);
>
> Provided this comment is correct, it doesn't sound like any MCE record
> will ever tell us what causes the error as an external source or a hung
> CPU doesn't generate an MCE record in any bank, does it?

That means there were no VALID=1, EN=1, S=1 errors anywhere.  But there
might be some other things logged that would help us understand.

We are into cpu errata territory here though ... we aren't supposed to get
machine checks that don't have a logged cause.  We panic for spurious
machine checks because we know something has gone horribly wrong,
even if we don't know what that something was.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
