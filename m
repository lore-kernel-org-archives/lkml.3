Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab3H2Sks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:40:48 -0400
Received: from kiruna.synopsys.com ([198.182.44.80]:54082 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab3H2Skq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:40:46 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Julius Werner <jwerner@chromium.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>, Felipe Balbi <balbi@ti.com>,
        "mathias.nyman@linux.intel.com" <mathias.nyman@linux.intel.com>,
        Josh Triplett <josh.triplett@intel.com>
Subject: RE: [PATCH] usb: xhci-plat: Enable USB 2.0 hardware LPM support for
 platform xHCs
Thread-Topic: [PATCH] usb: xhci-plat: Enable USB 2.0 hardware LPM support
 for platform xHCs
Thread-Index: AQHOnfwYI9Np33Plqkq7vUNbfD4u75mgdUEAgAAzMICAADKpAIAAPKeA//+VVhCAB60tgP//i2hQgAPFRAD//4sloAARR2QAACYXUgAAAangAAAOb5Ag
Date: Thu, 29 Aug 2013 18:40:44 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458DEEC7E@US01WEMBX2.internal.synopsys.com>
References: <20130821184042.GC3577@xanatos>
	<CAODwPW8tCFaykJnatyweJ96UzntRVNmo3WU1UYXw9nwp2bq_Ow@mail.gmail.com>
	<20130822004514.GB19747@xanatos>
	<CAODwPW99gLBtNQD=UyPq9DqY0TtNubR_7e+FymkfO5u2+et++Q@mail.gmail.com>
	<A2CA0424C0A6F04399FB9E1CD98E030458DEC6BC@US01WEMBX2.internal.synopsys.com>
	<20130826191411.GG5112@xanatos>
	<A2CA0424C0A6F04399FB9E1CD98E030458DED818@US01WEMBX2.internal.synopsys.com>
	<20130828215142.GJ26483@xanatos>
	<A2CA0424C0A6F04399FB9E1CD98E030458DEE7A3@US01WEMBX2.internal.synopsys.com>
	<CAODwPW_nPvS3Y9J2J9nU49uuDSB0kVirnKTF7HejfcYJEhgsUw@mail.gmail.com>
	<20130829171852.GB5538@xanatos>
 <CAODwPW9inceudHq9L7JB60q+g91UFxqtdpiS7T6PWvwS7RwA4g@mail.gmail.com>
In-Reply-To: <CAODwPW9inceudHq9L7JB60q+g91UFxqtdpiS7T6PWvwS7RwA4g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: jwerner@google.com [mailto:jwerner@google.com] On Behalf Of Julius Werner
> Sent: Thursday, August 29, 2013 11:07 AM
> 
> > If you take a look at Table
> > 13: BESL/HIRD Encoding from the xHCI spec version including errata to
> > 08/14/2012
> 
> Could you please provide a link to that errata? I still cannot find
> it... but from your explanation, that design decision sounds pretty
> horrible. Why didn't they just choose not to set old HLC flag in BESL
> controllers? Seems like the only purpose it provides there is to make
> old drivers break.
> 
> Anyway, looks like we are stuck with it now, and need to deal with
> those mislabeled DWC3 versions. I agree with you that we should
> blacklist instead of whitelist, but I don't think the device tree is
> the best place to put that... we would have to figure out the exact
> DWC3 version for every processor/SoC dtsi file to determine if they
> are affected, and remember to keep that up to date as we added more.
> 
> I would instead propose to check for the revision register directly in
> the DWC3 stack. I think I could add a little check to dwc3_host_init()
> and hack the quirk bit into the newly created XHCI controller instance
> if required. However, I only have an old (unaffected) 1.85 controller
> for testing, so I would need Synopsys to provide me with the exact
> revision numbers affected (as read from the register) and to test the
> change for us.

OK, I did a little more digging, and it turns out the 2.41a version
_does_ set bit 20 in the protocol defined field if BESL support is
enabled. It wasn't mentioned in the "registers" section of the databook,
but there is a note to that effect in a different section.

So it looks like we don't need to worry about this for the DWC3
controllers, anyway. Sorry for the noise.

-- 
Paul

