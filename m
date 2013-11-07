Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab3KGMwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 07:52:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:25331 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab3KGMww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 07:52:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,652,1378882800"; 
   d="scan'208";a="429392428"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
CC: "Usyskin, Alexander" <alexander.usyskin@intel.com>,
        Nicol? Costanza <abitrules@yahoo.it>,
        Alex Burmashev <alex.burmashev@rosalab.ru>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: mei: cancel stall timers in mei_reset
Thread-Topic: mei: cancel stall timers in mei_reset
Thread-Index: AQHO1v25eHT6rrwZAkeTBc+srO32QJoTJVWQgAH12wCAARFxgIAAHv+AgAAeFACAACHsAIABJEKAgAD0PACAAJQjAIAAQ7VA
Date: Thu, 7 Nov 2013 12:52:47 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AF07452@HASMSX106.ger.corp.intel.com>
References: <5B8DA87D05A7694D9FA63FD143655C1B1AF0656E@HASMSX106.ger.corp.intel.com>
 <1046189209.5373.1383806272671.JavaMail.root@collab.rosalab.ru>
In-Reply-To: <1046189209.5373.1383806272671.JavaMail.root@collab.rosalab.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.12]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rA7CquYh031894



> -----Original Message-----
> From: Eugene Shatokhin [mailto:eugene.shatokhin@rosalab.ru]
> Sent: Thursday, November 07, 2013 08:38
> To: Winkler, Tomas
> Cc: Usyskin, Alexander; Nicol? Costanza; Alex Burmashev; LKML
> Subject: RE: mei: cancel stall timers in mei_reset
> 
> Hi,
> 
> > You can safely comment out all of the timer_work.
> 
> Well, I rebuilt the kernel with the schedule_... commented out (in
> mei_me_pci_resume(), for the present). The errors are no longer visible in the
> log. The full log is attached.
> 

Looks like there is a hiccup in scheduling during resume and timer work is kicked before its time and starts unnecessary  the reset flow.
Can you check  that the device is in good state (<debugfs>/mei/devastate , it should be ENABLED).

We will work on some solution. 

Thanks
Tomas
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
