Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbaIEIU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:20:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:39195 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943AbaIEIUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:20:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,471,1406617200"; 
   d="scan'208";a="598395675"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: RE: [PATCH 3/3] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Thread-Topic: [PATCH 3/3] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Thread-Index: AQHPyF/xrVl5pOIy50CCjraIzroyT5vxx3yA///grICAAIrOQA==
Date: Fri, 5 Sep 2014 08:20:07 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E9828F8@SHSMSX101.ccr.corp.intel.com>
References: <1409161588-19417-1-git-send-email-alvin.chen@intel.com>
	<1409161588-19417-4-git-send-email-alvin.chen@intel.com>
	<CACRpkdZJSf+EfYN=hHxRnpjQZGuqroBL0c+08Ng=dRkS0GZySA@mail.gmail.com>
	<4656BEB6164FC34F8171C6538F1A595B2E9826A6@SHSMSX101.ccr.corp.intel.com>
 <CACRpkdYZ0W4+iGyP5bbARAAfrqcrG77PVCHKcGhnBXvpCHoqxw@mail.gmail.com>
In-Reply-To: <CACRpkdYZ0W4+iGyP5bbARAAfrqcrG77PVCHKcGhnBXvpCHoqxw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s858L30w015684

> >>
> >> Insert this into the dynamically allocated per-port or chip struct instead.
> >>
> > How about the following?
> >
> > static struct dwapb_context {
> >         u32 data[DWAPB_MAX_PORTS];
> >         u32 dir[DWAPB_MAX_PORTS];
> >         u32 ext[DWAPB_MAX_PORTS];
> >         u32 int_en;
> >         u32 int_mask;
> >         u32 int_type;
> >         u32 int_pol;
> >         u32 int_deb;
> > } dwapb_context;
> 
> NO because this is still a singleton variable. Put it into the dynamically allocated
> structs.
> 
> > Comparing to allocate for each port
> > dynamically, it is more directly and easy to understand.
> 
> No, I disagree. The overall design pattern in the kernel is to allocate all state
> containers dynamically.
> 
OK. Please also help review the v2 I just sent out, and after getting more feedbacks, I will improve this part in the next version together.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
