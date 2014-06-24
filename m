Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbaFXGKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 02:10:10 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:35325 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaFXGKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 02:10:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAODwPW-2tbDht8P=KsTyTyeBivFtFMiyCpxd0QFa-cUSRTpJjQ@mail.gmail.com>
References: <1402056736-12674-1-git-send-email-gautam.vivek@samsung.com>
	<1402056736-12674-3-git-send-email-gautam.vivek@samsung.com>
	<CAODwPW-2tbDht8P=KsTyTyeBivFtFMiyCpxd0QFa-cUSRTpJjQ@mail.gmail.com>
Date: Tue, 24 Jun 2014 11:40:07 +0530
X-Google-Sender-Auth: nexfpgdfZ8i8HrSCHzV6aE4fCKk
Message-ID: <CAFp+6iHUX0jn0xW6ijXmRpgXodp43_mBtVxnCcOb2H6duHvigQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] usb: host: xhci-plat: Add support to get PHYs
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Julius Werner <jwerner@chromium.org>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
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

Hi,


On Tue, Jun 10, 2014 at 1:52 AM, Julius Werner <jwerner@chromium.org> wrote:
>> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
>> index 9ffecd5..453d89e 100644
>> --- a/drivers/usb/host/xhci.h
>> +++ b/drivers/usb/host/xhci.h
>> @@ -1582,6 +1582,9 @@ struct xhci_hcd {
>>         u32                     port_status_u0;
>>  /* Compliance Mode Timer Triggered every 2 seconds */
>>  #define COMP_MODE_RCVRY_MSECS 2000
>> +       /* phys for the controller */
>> +       struct phy              *phy2_gen;
>> +       struct phy              *phy3_gen;
>>  };
>
> I don't think adding new variables here and restricting most of this
> logic to xhci-plat.c (in the next patch) is the best way to do it.
> There's no conceptual reason why other host controllers (e.g. xhci-pci
> or even EHCI) could not have a similar need to tune their PHY after
> reset. PHYs are universal to all host controllers.
>
> There is already a 'phy' member in struct usb_hcd which I think is
> mostly unused right now. I think it would be much less
> confusing/redundant to reuse that member for this purpose (you could
> still set it up from xhci_plat_probe(), and then call it from
> hcd_bus_resume() or something like that). Since XHCI host controllers
> already conveniently have two struct usb_hcd (one for 2.0 and one for
> 3.0), you can cleanly store references to your two PHYs in there.

Ok, i will look into the suggested approach, and raise flag in case i
have doubts.



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
