Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaI2BaE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 21:30:04 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.12]:42990 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752741AbaI2BaC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 21:30:02 -0400
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Sep 2014 21:30:02 EDT
X-Env-Sender: Iwo.Mergler@netcommwireless.com
X-Msg-Ref: server-15.tower-210.messagelabs.com!1411953776!19652362!1
X-Originating-IP: [220.233.131.78]
X-StarScan-Received: 
X-StarScan-Version: 6.12.2; banners=netcommwireless.com,-,-
X-VirusChecked: Checked
From: Iwo Mergler <Iwo.Mergler@netcommwireless.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Huang Shijie <shijie8@gmail.com>
CC: Mike Voytovich <mvoytovich@paypal.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Roy Lee <roylee@paypal.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 29 Sep 2014 11:22:11 +1000
Subject: RE: [PATCH] mtd: nand: gpmi: add proper raw access support
Thread-Topic: [PATCH] mtd: nand: gpmi: add proper raw access support
Thread-Index: Ac/NvUrlDqT/a1grSmyHgeSBOjXbYQNxoAiy
Message-ID: <EACD232272DA4849B060F0828564D13B44955ABD82@ntcex01.corp.netcomm.com.au>
References: <1410339339-25561-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140911120928.GA1585@localhost.localdomain>,<20140911143616.3ebb025a@bbrezillon>
In-Reply-To: <20140911143616.3ebb025a@bbrezillon>
Accept-Language: en-US, en-AU
Content-Language: en-AU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-AU
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014 22:36:16 +1000
Boris BREZILLON <boris.brezillon@free-electrons.com> wrote:
> 
> Well, I don't know about freescale specific tools, but at least I have
> an example with mtd_nandbiterrs module.
> This module is assuming it can write only the data part of a NAND page
> without modifying the OOB area (see [1]), which in GPMI controller
> case is impossible because raw write function store the data as if
> there were no specific scheme, while there is one:
> (metadata + n x (data_chunk + ECC bytes) + remaining_bytes).
> 

Hi Boris,


just as an aside, only the incremental bit errors test in nandbiterrs
positively requires raw data write.

The overwrite test (re-write the same page data repeatedly without
erase), only uses raw access because I was lazy. A normal ECC write
would do just as well.


Best regards,

Iwo

______________________________________________________________________
This communication contains information which may be confidential or privileged. The information is intended solely for the use of the individual or entity named above.  If you are not the intended recipient, be aware that any disclosure, copying, distribution or use of the contents of this information is prohibited.  If you have received this communication in error, please notify me by telephone immediately.
______________________________________________________________________
