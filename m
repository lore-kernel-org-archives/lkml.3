Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbaIJDhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 23:37:31 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:47462 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaIJDh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 23:37:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140909144225.GF6151@saruman.home>
References: <1409656338-20337-1-git-send-email-gautam.vivek@samsung.com>
	<1409656338-20337-5-git-send-email-gautam.vivek@samsung.com>
	<20140902143438.GB16872@saruman.home>
	<CAFp+6iEyqmbwMLFrBKD7NVLDAC=b+h1hPKFS=BG4k9D69hn_dg@mail.gmail.com>
	<20140903144225.GD31855@saruman.home>
	<CAFp+6iETPJCWMMkjHrpDcdCv=K0PbefYLa4eBOwN=aUY2=EHLA@mail.gmail.com>
	<20140905175651.GK24449@saruman.home>
	<CAFp+6iGU86yL8Ry3ArJJjBy2Cs0Em2B49yssH3BK5fJwyaZbtA@mail.gmail.com>
	<20140908134454.GK22409@saruman.home>
	<CAFp+6iG+gmD_JseytYuVQcRK9ErOqQrUEWJoU1KUU7PqMd=aRw@mail.gmail.com>
	<20140909144225.GF6151@saruman.home>
Date: Wed, 10 Sep 2014 09:07:28 +0530
X-Google-Sender-Auth: imroKd2uTRL6BhrQoW4gw91tVlg
Message-ID: <CAFp+6iHJKmeothDM67WW60Sqqj8BQroBCzZ8zecKwM_GcYL8HA@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] phy: exynos5-usbdrd: Calibrate LOS levels for exynos5420/5800
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Felipe Balbi <balbi@ti.com>, Julius Werner <jwerner@google.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>, kishon <kishon@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jingoo Han <jg1.han@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adding Julius here,


On Tue, Sep 9, 2014 at 8:12 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Sep 09, 2014 at 07:19:50AM +0530, Vivek Gautam wrote:
>> Hi,
>>
>>
>> On Mon, Sep 8, 2014 at 7:14 PM, Felipe Balbi <balbi@ti.com> wrote:
>> > Hi,
>> >
>> > On Mon, Sep 08, 2014 at 09:53:09AM +0530, Vivek Gautam wrote:
>> >> On Fri, Sep 5, 2014 at 11:26 PM, Felipe Balbi <balbi@ti.com> wrote:
>> >> > On Thu, Sep 04, 2014 at 12:01:19PM +0530, Vivek Gautam wrote:
>> >> >> > Don't we have phy_power_on()
>> >> >> > for that ? It looks like you could just as well do this from
>> >> >> > phy_power_on() ?
>> >> >>
>> >> >> No, unfortunately keeping these calibration settings in phy_power_on()
>> >> >> doesn't help, since we need to do this after XHCI reset has happened.
>> >> >
>> >> > teach xHCI about PHYs ?
>> >>
>> >> sorry i couldn't understand you here.
>> >> Aren't we trying to do the same with Heikki's patch about dwc3 :
>> >> [PATCH 6/6] usb: dwc3: host: convey the PHYs to xhci
>> >>
>> >> and the 2nd patch in this series :
>> >> [PATCH v6 2/4] usb: host: xhci-plat: Get PHYs for xhci's hcds
>> >>
>> >> Is there something else that is expected ?
>> >
>> > right, use that to call phy_init() at the right time, then you need to
>> > add a new ->calibrate() method which, likely, will only be used by you
>> > ;-)
>>
>> so you mean, the xhci should itself call phy_init() at a time suitable,
>> so that ->calibrate() is not required at all ?
>>
>> i think you meant there - "then you __do not__ need to
>
> right :-)

alright, i will prepare a patch for the suggested change.

But AFAI remember we had discussion for this patch in earlier version,
and Julius suggested to use a generic approach for such
change wherein other users in future may be able to use the
facility.
Julius any thoughts about the change suggested by Felipe.

[snip]


-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
