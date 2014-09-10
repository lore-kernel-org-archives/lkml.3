Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaIJH5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 03:57:00 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:59944 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaIJH46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 03:56:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAFp+6iHMhbi4V4LAkNsgzDc192ihT2a1mZHgLbia=K2U8+x=2w@mail.gmail.com>
References: <CAFp+6iEyqmbwMLFrBKD7NVLDAC=b+h1hPKFS=BG4k9D69hn_dg@mail.gmail.com>
	<20140903144225.GD31855@saruman.home>
	<CAFp+6iETPJCWMMkjHrpDcdCv=K0PbefYLa4eBOwN=aUY2=EHLA@mail.gmail.com>
	<20140905175651.GK24449@saruman.home>
	<CAFp+6iGU86yL8Ry3ArJJjBy2Cs0Em2B49yssH3BK5fJwyaZbtA@mail.gmail.com>
	<20140908134454.GK22409@saruman.home>
	<CAFp+6iG+gmD_JseytYuVQcRK9ErOqQrUEWJoU1KUU7PqMd=aRw@mail.gmail.com>
	<20140909144225.GF6151@saruman.home>
	<CAFp+6iHJKmeothDM67WW60Sqqj8BQroBCzZ8zecKwM_GcYL8HA@mail.gmail.com>
	<CAFp+6iHRJ5oAA+K1Y0Y2uadPhsR6wmrd13DM39dqiL4jj+swHg@mail.gmail.com>
	<20140910045328.GA32475@saruman.home>
	<CAFp+6iHMhbi4V4LAkNsgzDc192ihT2a1mZHgLbia=K2U8+x=2w@mail.gmail.com>
Date: Wed, 10 Sep 2014 13:26:57 +0530
X-Google-Sender-Auth: VXEKsprRg9QGxtwNt7MoUh_B9E0
Message-ID: <CAFp+6iErXKpXgE0tRPB=tEqXxcXgQAeFJP1TpSwRN6fNu9a-qw@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] phy: exynos5-usbdrd: Calibrate LOS levels for exynos5420/5800
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Julius Werner <jwerner@google.com>, Julius Werner <jwerner@chromium.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
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

On Wed, Sep 10, 2014 at 10:53 AM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> On Wed, Sep 10, 2014 at 10:23 AM, Felipe Balbi <balbi@ti.com> wrote:
>> On Wed, Sep 10, 2014 at 09:09:57AM +0530, Vivek Gautam wrote:
>>> On Wed, Sep 10, 2014 at 9:07 AM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
>>> > adding Julius here,
>>>
>>> i think i had missed adding Julius for this entire series :-(
>>> I should be more careful with the CC list in future.
>>> Added his chromium id, since that seems to be more active.
>>>
>>> >
>>> >
>>> > On Tue, Sep 9, 2014 at 8:12 PM, Felipe Balbi <balbi@ti.com> wrote:
>>> >> On Tue, Sep 09, 2014 at 07:19:50AM +0530, Vivek Gautam wrote:
>>> >>> Hi,
>>> >>>
>>> >>>
>>> >>> On Mon, Sep 8, 2014 at 7:14 PM, Felipe Balbi <balbi@ti.com> wrote:
>>> >>> > Hi,
>>> >>> >
>>> >>> > On Mon, Sep 08, 2014 at 09:53:09AM +0530, Vivek Gautam wrote:
>>> >>> >> On Fri, Sep 5, 2014 at 11:26 PM, Felipe Balbi <balbi@ti.com> wrote:
>>> >>> >> > On Thu, Sep 04, 2014 at 12:01:19PM +0530, Vivek Gautam wrote:
>>> >>> >> >> > Don't we have phy_power_on()
>>> >>> >> >> > for that ? It looks like you could just as well do this from
>>> >>> >> >> > phy_power_on() ?
>>> >>> >> >>
>>> >>> >> >> No, unfortunately keeping these calibration settings in phy_power_on()
>>> >>> >> >> doesn't help, since we need to do this after XHCI reset has happened.
>>> >>> >> >
>>> >>> >> > teach xHCI about PHYs ?
>>> >>> >>
>>> >>> >> sorry i couldn't understand you here.
>>> >>> >> Aren't we trying to do the same with Heikki's patch about dwc3 :
>>> >>> >> [PATCH 6/6] usb: dwc3: host: convey the PHYs to xhci
>>> >>> >>
>>> >>> >> and the 2nd patch in this series :
>>> >>> >> [PATCH v6 2/4] usb: host: xhci-plat: Get PHYs for xhci's hcds
>>> >>> >>
>>> >>> >> Is there something else that is expected ?
>>> >>> >
>>> >>> > right, use that to call phy_init() at the right time, then you need to
>>> >>> > add a new ->calibrate() method which, likely, will only be used by you
>>> >>> > ;-)
>>> >>>
>>> >>> so you mean, the xhci should itself call phy_init() at a time suitable,
>>> >>> so that ->calibrate() is not required at all ?

but wait, dwc3 does a phy_init() already, then how xhci will be able to
do that again. We can't do phy_init() multiple times right ?

>>> >>>
>>> >>> i think you meant there - "then you __do not__ need to
>>> >>
>>> >> right :-)
>>> >
>>> > alright, i will prepare a patch for the suggested change.
>>> >
>>> > But AFAI remember we had discussion for this patch in earlier
>>> > version, and Julius suggested to use a generic approach for such
>>> > change wherein other users in future may be able to use the
>>> > facility.
>>
>> right, and what's more generic than adding the support for PHYs straight
>> into xHCI ?
>>
>> What I fear is that we end up opening the doors for every odd
>> platform-specific operation to be added to the framework without really
>> considering what needs to be done. That would defeat the idea of having
>> a generic framework altogether.
>
> Ok, i will prepare the patch series as suggested and post it
> to gather opinion from you. :-)
>
>>
>> cheers
>>
>> --
>> balbi
>
>
>
> --
> Best Regards
> Vivek Gautam
> Samsung R&D Institute, Bangalore
> India



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
