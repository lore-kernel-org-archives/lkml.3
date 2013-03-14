Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab3CNMEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 08:04:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989Ab3CNMEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 08:04:05 -0400
Subject: Re: [PATCH v2] USB: ehci-s5p: Fix phy reset
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=iso-8859-1
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <CAD=FV=UyCUMZss36Fw3VZSGgi56CToewEaOjUo95z6=vJreysg@mail.gmail.com>
Date: Thu, 14 Mar 2013 13:04:00 +0100
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dmueller@suse.de, Vivek Gautam <gautam.vivek@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Transfer-Encoding: 7bit
Message-Id: <0A9719D9-5957-44B8-8466-F0F454588B2C@suse.de>
References: <1363219179-14900-1-git-send-email-agraf@suse.de> <CAD=FV=UyCUMZss36Fw3VZSGgi56CToewEaOjUo95z6=vJreysg@mail.gmail.com>
To: Doug Anderson <dianders@chromium.org>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 14.03.2013, at 04:38, Doug Anderson wrote:

> Alexander,
> 
> On Wed, Mar 13, 2013 at 4:59 PM, Alexander Graf <agraf@suse.de> wrote:
>> On my Exynos 5 based Arndale system, I need to pull the reset line down
>> and then let it go up again to actually perform a reset. Without that
>> reset, I can't find any USB hubs on my bus, rendering the USB controller
>> useless.
>> 
>> We also only need to reset the line after the phy node has been found.
>> This way we don't accidently reserve the vbus GPIO pin, but later on
>> defer the creation of our controller, because the phy device tree node
>> hasn't been probed yet.
>> 
>> This patch implements the above logic, making EHCI and OHCI work on
>> Arndale systems for me.
>> 
>> Signed-off-by: Alexander Graf <agraf@suse.de>
>> CC: Vivek Gautam <gautam.vivek@samsung.com>
>> CC: Jingoo Han <jg1.han@samsung.com>
>> CC: Alan Stern <stern@rowland.harvard.edu>
>> CC: Kukjin Kim <kgene.kim@samsung.com>
>> CC: Felipe Balbi <balbi@ti.com>
>> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> CC: Doug Anderson <dianders@chromium.org>
>> 
>> ---
>> 
>> v1 -> v2:
>> 
>>  - remove gpio_free call
>>  - move reset logic after phy node search
> 
> Seems fine to me.  I guess the earlier problem you wrote about was the
> probe failure, then?  

Well, the problem I wrote about was that when I do

  * probe
    -> reset phy
  * probe gets deferred
  * deferred probe
    -> can't reset phy because the pin is already in use

Then I get the same breakage again. However, if I do

  * probe
  * probe gets deferred
  * deferred probe
    -> reset phy

Then everything works just fine.

> I think that the reason I don't tend to get the
> probe failure is that I've got my device tree ordered differently so
> that the phy gets initted in a different order.

Odd - I get the deferral regardless of how I order my device tree :).


Alex

> 
> I'll send up the devm_ patch atop this.
> 
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> 
> Thanks!  :)
> 
> -Doug

