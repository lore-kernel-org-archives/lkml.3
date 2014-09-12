Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaILC23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 22:28:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:54682 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbaILC21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 22:28:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,509,1406617200"; 
   d="scan'208";a="590203721"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: atull <atull@opensource.altera.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: RE: [PATCH 4/4 v3] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Thread-Topic: [PATCH 4/4 v3] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Thread-Index: AQHPzjEb/eqFgepPqECCtRJAIRWRtA==
Date: Fri, 12 Sep 2014 02:27:33 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E990CFF@SHSMSX101.ccr.corp.intel.com>
References: <1410286081-16653-1-git-send-email-alvin.chen@intel.com>
 <1410286081-16653-5-git-send-email-alvin.chen@intel.com>
 <alpine.DEB.2.02.1409111138080.4869@atx-linux-37>
In-Reply-To: <alpine.DEB.2.02.1409111138080.4869@atx-linux-37>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 9 Sep 2014, Weike Chen wrote:
> 
> >
> >  struct dwapb_gpio;
> > +struct dwapb_context;
> >
> >  struct dwapb_gpio_port {
> >  	struct bgpio_chip	bgc;
> >  	bool			is_registered;
> >  	struct dwapb_gpio	*gpio;
> > +	struct dwapb_context	*ctx;
> 
> Alvin,
> 
> Will this build if CONFIG_PM_SLEEP is not defined?
Actually, PM_SLEEP is always set as 'y' in 'kerne/power/Kconfig'. But I manually change it to 'n', this module can be compiled correctly.
You may be concern with 'ctx', and you can see 'ctx' accessing is always in CONFIG_PM_SLEEP.


> Alan
