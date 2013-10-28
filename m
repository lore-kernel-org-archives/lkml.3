Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3J1DBo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 23:01:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:5717 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252Ab3J1DBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 23:01:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="313570279"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: =?utf-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@ring0.de>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: N900 DT
Thread-Topic: N900 DT
Thread-Index: AQHO0eHiZ5WzVxENukuroibDb0C6cJoGnkCAgALPV8A=
Date: Mon, 28 Oct 2013 03:01:35 +0000
Message-ID: <20ADAB092842284E95860F279283C5640AA999C5@BGSMSX104.gar.corp.intel.com>
References: <201310240806.49340@pali> <201310252039.41026@pali>
 <20131026002500.GA16970@earth.universe> <201310261527.25787@pali>
In-Reply-To: <201310261527.25787@pali>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9S31nC3001894


> 
> On Saturday 26 October 2013 02:25:02 Sebastian Reichel wrote:
> > Hi Pali,
> >
> > On Fri, Oct 25, 2013 at 08:39:40PM +0200, Pali RohÃ¡r wrote:
> > > Now I found this patch and it looks like it will be in mainline
> > > kernel. And after that it could be simple to listen for needed
> > > events from isp driver in my bq driver (without touching isp).
> > >
> > > https://lkml.org/lkml/2013/7/25/204
> > >
> > > Can you look at isp1704 driver for DT support? I think that only one
> > > gpio needs to be passed to driver from board data.
> >
> > I had a quick overview over Jenny's patchset [0] (the patch you
> > referenced is part of a bigger patchset). I don't think the scenario
> > found in the Nokia N900 is covered by it, but probably now is the time
> > to change it :)
> >
> > So for everybody new to this thread:
> >
> > Multiple chips are involved in the charging of the Nokia N900
> > battery:
> >
> > bq27200:   This chip is used for reading battery status. AFAIK
> >            it's not directly involved in charging the battery.
> > bq24150a:  This chip takes care of actually charging the battery. It
> > has no clue about USB related stuff. The maximum
> > current it draws can be configured, though. isp1704:   USB
> > charger detector. This chip is used to detect how much current may be
> > used by the bq24150a chip. rx51-temp: Analog temperature sensor for
> > the battery, which is connected via an analog-digital-converter.
> >
> > The question is how to connected these driver with each other if
> > device tree is used to boot the system. Any suggestions?
> >
The patch http://thread.gmane.org/gmane.linux.kernel/1377608 is intended to cover similar
scenario. It connects different components involved in charging to monitor and control the
charging.  This keeps the charging logic outside the charger driver and the charger driver just
need to be a h/w abstraction layer. It doesn't take care of the device tree part. But as long as the
drivers are registered with power supply class,  the framework can take actions. Hope this helps.

> > [0] http://thread.gmane.org/gmane.linux.kernel/1377608
> >
> > -- Sebastian
> 
> What I need is receive property change event (from isp1704) in bq24150a. And with this
> patch https://lkml.org/lkml/2013/7/25/204
> bq24150a driver can receive them and use only these which comes from driver specified in
> DT (on n900 from isp1704).
> 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
