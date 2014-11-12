Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaKLScN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:32:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:28805 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbaKLScM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:32:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,370,1413270000"; 
   d="scan'208";a="606769782"
From: "Luck, Tony" <tony.luck@intel.com>
To: Chen Yucong <slaoub@gmail.com>
CC: Borislav Petkov <bp@alien8.de>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 1/2] x86, mce, severity: extend the the mce_severity
 mechanism to handle UCNA/DEFERRED error
Thread-Topic: [PATCH v3 1/2] x86, mce, severity: extend the the mce_severity
 mechanism to handle UCNA/DEFERRED error
Thread-Index: AQHP+vUgoD/q7VyRgEG5Av0WO+I2NJxa9TcAgAADNAD//4mloIABKNEAgAAZJLCAAPUhAIAAnXKQ
Date: Wed, 12 Nov 2014 18:28:40 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3292B1A6@ORSMSX114.amr.corp.intel.com>
References: <1415410821-15063-1-git-send-email-slaoub@gmail.com>
	 <1415410821-15063-2-git-send-email-slaoub@gmail.com>
	 <546136C8.5060104@amd.com> <20141110221728.GA23419@pd.tnic>
	 <3908561D78D1C84285E8C5FCA982C28F329282FA@ORSMSX114.amr.corp.intel.com>
	 <20141111085612.GA31490@pd.tnic>
	 <3908561D78D1C84285E8C5FCA982C28F329293DE@ORSMSX114.amr.corp.intel.com>
 <1415754212.12188.12.camel@debian>
In-Reply-To: <1415754212.12188.12.camel@debian>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sACIWj9V019043

> Just as what you said, the severity table entry for the "EN" check
> should have been skipped when calling from the CMCI/Poll handler.
> As shown below:
>
>        MCESEV(
>                NO, "Not enabled",
>                EXCP, BITCLR(MCI_STATUS_EN)
>                ),

Yes - that worked.  The bank 7 error now gets processed and we offline the page.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
