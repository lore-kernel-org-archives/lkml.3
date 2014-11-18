Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbaKRMUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:20:22 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:44568 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbaKRMUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:20:20 -0500
MIME-Version: 1.0
In-Reply-To: <546A1F64.7000209@cogentembedded.com>
References: <1414761989-21088-1-git-send-email-gautam.vivek@samsung.com>
	<1414761989-21088-2-git-send-email-gautam.vivek@samsung.com>
	<545393CE.8070102@cogentembedded.com>
	<CAFp+6iG37uE1uB5Z8B-hM3nKyBeR6Vxb-YKegd7MrRB3wuA9xw@mail.gmail.com>
	<546A1F64.7000209@cogentembedded.com>
Date: Tue, 18 Nov 2014 17:50:19 +0530
Message-ID: <CAFp+6iHVWuiTfc4n8LeYkYhmMXA76kEs3xcH1WbrAr468MFe2A@mail.gmail.com>
Subject: Re: [PATCH v7 1/2] usb: host: xhci-plat: Get PHYs for xhci's hcds
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>, kishon <kishon@ti.com>,
        Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Julius Werner <jwerner@google.com>, Jingoo Han <jg1.han@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 9:46 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> Hello.
>
> On 11/17/2014 9:36 AM, Vivek Gautam wrote:
>
>>>> The host controller by itself may sometimes need to handle PHY
>>>> and re-initialize it to re-configure some of the PHY parameters
>>>> to get full support out of the PHY controller.
>>>> Therefore, facilitate getting the two possible PHYs, viz.
>>>> USB 2.0 type (UTMI+) and USB 3.0 type (PIPE3), and initialize them.
>
>
>>>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>>>> ---
>>>>    drivers/usb/host/xhci-plat.c |   74
>>>> ++++++++++++++++++++++++++++++++++++++++++
>>>>    1 file changed, 74 insertions(+)
>
>
>>>> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
>>>> index 3d78b0c..5207d5b 100644
>>>> --- a/drivers/usb/host/xhci-plat.c
>>>> +++ b/drivers/usb/host/xhci-plat.c
>
> [...]
>>>>
>>>> @@ -204,6 +271,8 @@ static int xhci_plat_suspend(struct device *dev)
>>>>          struct usb_hcd  *hcd = dev_get_drvdata(dev);
>>>>          struct xhci_hcd *xhci = hcd_to_xhci(hcd);
>>>>
>>>> +       phy_exit(hcd->phy);
>
>
>>>     Hm, in the suspend() method?
>
>
>> phy_exit() should eventually be suspending the PHY and put it to
>> low power state.
>
>
>    I thought it's a role that the power_off() mothod should play,
> considering that the power_on() method gets called after the init()
> method....

phy_power_off() should be cutting the clocks and power from PHY
completely, no ?
In that case one may not be able to wakeup the system from USB.

So phy_exit() gets the responsibility to put the PHY into low power state.

Ccing Kishon also to get his opinion on actual role of the two callbacks -
phy_init/exit() and phy_power_on/off().

>
>> phy_init() in resume() will then take up the task of activating the
>> PHY again.
>
>
>> phy_power_on() and phy_power_off() are called at xhci_probe() and remove()
>> time.
>
>
>    Of course.
>
>> Does this makes sense ?
>
>
>    Not much, really.
>
> WBR, Sergei
>



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
