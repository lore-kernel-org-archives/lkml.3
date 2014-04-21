Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbaDUEUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:20:53 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:64180 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaDUEUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:20:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140416141239.GB30528@xps8300>
References: <1386672926-26885-1-git-send-email-gautam.vivek@samsung.com>
	<1386672926-26885-4-git-send-email-gautam.vivek@samsung.com>
	<20131210135548.GA28456@xps8300>
	<CAFp+6iGAdDgC=21VjCUjx3u_ZohhCyj2nG8qzvz3CHTZzoXWJQ@mail.gmail.com>
	<20140416141239.GB30528@xps8300>
Date: Mon, 21 Apr 2014 09:50:47 +0530
X-Google-Sender-Auth: NNRoQn6vbWz87w8fYteVtW_LkfY
Message-ID: <CAFp+6iGictwugB2A3ddpW2T7h-eSQ5vkM1RVrWsboGtWE1SkMg@mail.gmail.com>
Subject: Re: [PATCH RFC 3/4] xhci: Tune PHY for the DWC3-Exynos host controller
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>, kishon <kishon@ti.com>,
        Jingoo Han <jg1.han@samsung.com>, Julius Werner <jwerner@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Wed, Apr 16, 2014 at 7:42 PM, Heikki Krogerus
<heikki.krogerus@linux.intel.com> wrote:
> Hi,
>
> On Tue, Apr 15, 2014 at 06:24:11PM +0530, Vivek Gautam wrote:
>> I had seen your patches in the mailing list, but i don't see any
>> updated version of these patches.
>> Are you planning to work on this above mentioned patch-series any time soon ?
>
> I'm sorry, I forgot this completely. I have not prepared new version
> of those patches as the drivers I need them for are not ready yet, but
> I guess I can also use this case as justification for them.
>
>> Or, should i try to find a different approach for handling the phy
>> from the host controller (child of DWC3 in this case, which has the
>> phys).
>
> Well, there is now an issue with the lookup method I'm suggesting in
> this case. Since the device ID is now generated automatically for
> xhci-hcd in dwc3, we don't know the xhci-hcd device name before
> platform_device_add(), and that is too late.

True, the xhci-hcd are getting AUTO ID, so it might not be possible to
get their device
names in dwc3.

> I don't see why the
> device could not be named when platform_device_alloc() is called, so I
> think I'll suggest something like the attached patch to fix this
> issue

Ok, i had a look at the patch, and it looks promising.

>
> In any case, I'll send an updated version of the phy patches soon.

Thanks for your efforts.
