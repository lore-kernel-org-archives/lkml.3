Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbaFYFuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:50:54 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:51269 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbaFYFt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:49:56 -0400
MIME-Version: 1.0
In-Reply-To: <53A9FCDB.6060805@cogentembedded.com>
References: <1402056736-12674-1-git-send-email-gautam.vivek@samsung.com>
	<1402056736-12674-3-git-send-email-gautam.vivek@samsung.com>
	<CAODwPW-2tbDht8P=KsTyTyeBivFtFMiyCpxd0QFa-cUSRTpJjQ@mail.gmail.com>
	<53A9FCDB.6060805@cogentembedded.com>
Date: Wed, 25 Jun 2014 11:19:55 +0530
X-Google-Sender-Auth: OIvO7rkHfivny-wAabY1FG455cg
Message-ID: <CAFp+6iH_rxNpHZyFH6k5Got6YJ_RQMsm=95=pkRPitsxopsosA@mail.gmail.com>
Subject: Re: [PATCH 2/4] usb: host: xhci-plat: Add support to get PHYs
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Julius Werner <jwerner@chromium.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kishon <kishon@ti.com>, Mathias Nyman <mathias.nyman@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Sergei,


On Wed, Jun 25, 2014 at 4:04 AM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> Hello.
>
>
> On 06/10/2014 12:22 AM, Julius Werner wrote:
>
>>> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
>>> index 9ffecd5..453d89e 100644
>>> --- a/drivers/usb/host/xhci.h
>>> +++ b/drivers/usb/host/xhci.h
>>> @@ -1582,6 +1582,9 @@ struct xhci_hcd {
>>>          u32                     port_status_u0;
>>>   /* Compliance Mode Timer Triggered every 2 seconds */
>>>   #define COMP_MODE_RCVRY_MSECS 2000
>>> +       /* phys for the controller */
>>> +       struct phy              *phy2_gen;
>>> +       struct phy              *phy3_gen;
>>>   };
>
>
>> I don't think adding new variables here and restricting most of this
>> logic to xhci-plat.c (in the next patch) is the best way to do it.
>
>
>    Indeed.
>
>
>> There's no conceptual reason why other host controllers (e.g. xhci-pci
>> or even EHCI) could not have a similar need to tune their PHY after
>> reset. PHYs are universal to all host controllers.
>
>
>> There is already a 'phy' member in struct usb_hcd which I think is
>> mostly unused right now. I think it would be much less
>> confusing/redundant to reuse that member for this purpose (you could
>> still set it up from xhci_plat_probe(), and then call it from
>> hcd_bus_resume() or something like that).
>
>
>    That member has type 'struct usb_phy *' while here we have 'struct phy *'
> -- feel the difference.
>    I have already tried adding 'struct phy *gen_phy' to 'struct usb_hcd',
> however Greg wasn't eager to pick that up so far. Here's the last posting of
> my patch:
>
> http://marc.info/?l=linux-usb&m=140145917506582

Thanks for pointing to the patch, i have also been tracking this patch.
I will try to rework using this patch and post the relevant patches.



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
