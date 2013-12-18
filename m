Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab3LRJSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:18:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:33322 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab3LRJSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:18:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="446205942"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Arend van Spriel <arend@broadcom.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sander Eikelenboom <linux@eikelenboom.it>
CC: Ben Hutchings <ben@decadent.org.uk>,
        Julian Calaby <julian.calaby@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Avinash Patil <avinashapatil@gmail.com>
Subject: RE: [cfg80211 / iwlwifi] setting wireless regulatory domain doesn't
 work.
Thread-Topic: [cfg80211 / iwlwifi] setting wireless regulatory domain
 doesn't work.
Thread-Index: AQHOzCmvoZApyQQAYE2ZI4JJ6vL7x5pPb9/1///kR4CAABUhAIAABbUAgAAD2wCAAAcAgIAABQQAgAAHwgCAB2GbAIAABGmAgAAWDwCAAN/TAIAAfSkAgAC06oCAAA8LgIAABisAgAAEtwCAALtYAIAAIcYQ
Date: Wed, 18 Dec 2013 09:18:39 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D23ABD@HASMSX103.ger.corp.intel.com>
References: <1342235583.20131211182804@eikelenboom.it>
	<CAB=NE6UfumA2xez1DvtDSBDZ72WF_tOozFo_8LRnMryYiSqD-A@mail.gmail.com>
	<871324710.20131211191104@eikelenboom.it>
	<CAB=NE6XRnE0j9NMW0K1vKzEO9v70arSH4YXZjudqa0ZxiLB4AA@mail.gmail.com>
	<1937118387.20131216122200@eikelenboom.it>	<52AEE60B.6030509@broadcom.com>
	<19210260274.20131216135644@eikelenboom.it>
	<CAGRGNgXHemM2FfnXgW5RbzhFT+9SfUfVkjdysK3+=_u3hWSacw@mail.gmail.com>
	<1534126119.20131217104548@eikelenboom.it>
	<387552477.20131217213319@eikelenboom.it>
	<20131217212709.GB5624@decadent.org.uk>
	<1254825772.20131217224914@eikelenboom.it>
 <CA+55aFxQg6=MAWEkEGz64Hz8OawvPyX=fpBOjY8cGBL5XgB9WQ@mail.gmail.com>
 <52B167F6.5060209@broadcom.com>
In-Reply-To: <52B167F6.5060209@broadcom.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBI9Ionu008922

> 
> On 12/17/2013 11:06 PM, Linus Torvalds wrote:
> > We have literally had this *exact* same issue with firmware loading.
> > Network drivers shouldn't try to load firmware at module load time.
> > Same deal.
> 
> It is kind of a chicken and egg problem for (wireless) networking drivers. To
> get IFF_UP from the network layer you have to register a netdevice. For
> wireless drivers this means you have to register a wiphy device with cfg80211
> which flags capabilities and optionally are custom regulatory domain. That
> information depends on the device and firmware used. And there we have a
> full circle.
> 

To solve this - iwlwifi uses request_firmware_nowait. Its doc reads:

"Asynchronous variant of request_firmware for user contexts: - sleep for as small periods as possible since it may increase kernel boot time of built-in device drivers requesting firmware in their ->probe methods, if gfp is GFP_KERNEL."
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
