Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaIZBg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 21:36:56 -0400
Received: from mga03.intel.com ([134.134.136.65]:53589 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbaIZBgy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 21:36:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,601,1406617200"; 
   d="scan'208";a="480092943"
From: "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>
To: "'Mika Westerberg'" <mika.westerberg@linux.intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] gpio: sch: Consolidate similar algorithms
Thread-Topic: [PATCH 1/3] gpio: sch: Consolidate similar algorithms
Thread-Index: AQHP0zITy1c+9hxkcUuFzrdfTj4FxJwMpx4g//+6rACAAxnHUIAAEfwAgAMgJZA=
Date: Fri, 26 Sep 2014 01:35:49 +0000
Message-ID: <50B33AC5ED75F74F991980326F1C438D0FBE8725@PGSMSX108.gar.corp.intel.com>
References: <1410943745-9354-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1410943745-9354-2-git-send-email-rebecca.swee.fun.chang@intel.com>
 <20140918111705.GM10854@lahna.fi.intel.com>
 <50B33AC5ED75F74F991980326F1C438D0FBDB28B@PGSMSX108.gar.corp.intel.com>
 <20140922092528.GM1786@lahna.fi.intel.com>
 <50B33AC5ED75F74F991980326F1C438D0FBDBA92@PGSMSX108.gar.corp.intel.com>
 <20140924095052.GZ1786@lahna.fi.intel.com>
In-Reply-To: <20140924095052.GZ1786@lahna.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: 'Mika Westerberg' [mailto:mika.westerberg@linux.intel.com]
> Sent: 24 September, 2014 5:51 PM
> To: Chang, Rebecca Swee Fun
> Cc: Linus Walleij; linux-gpio@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/3] gpio: sch: Consolidate similar algorithms
> 
> On Wed, Sep 24, 2014 at 12:55:07AM +0000, Chang, Rebecca Swee Fun wrote:
> > > > The register values are required when it comes to IRQ handling. By
> > > > passing in the registers values, we can make full use of the
> > > > algorithms without introducing extra/similar algorithms to compute
> > > > other register offset values.
> > > > For example, we have other offset values to handle such as:-
> > > > GTPE	0x0C
> > > > GTNE	0x10
> > > > GGPE	0x14
> > > > GSMI	0x18
> > > > GTS	0x1C
> > > > CGNMIEN	0x40
> > > > RGNMIEN	0x44
> > >
> > > Well, can we at least call it something else than sch_gpio_enable()?
> > > Perhaps sch_gpio_set_value() or so?
> >
> > sch_gpio_set_value() sounds good. After think twice, I intend to merge
> > sch_gpio_enable() and sch_gpio_disable() into one functions. Using
> > variable "enable" as an indicator, I can control whether to enable or
> > disable when calling the function. Here is my draft:
> 
> Actually sch_gpio_set_value() is too close to sch_gpio_set() which sets the GPIO
> to 1 or 0. How about sch_gpio_register_set() or something along those lines?
> 
> And I don't think it is good idea to add yet another functionality, like enable
> there. Please leave sch_gpio_enable()/sch_gpio_disable() as is.

Alright, I will change the sch_gpio_enable()/sch_gpio_disable() into sch_gpio_register_set()/sch_gpio_register_clear().
Thanks.

Rebecca
