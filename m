Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211Ab3ARF2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 00:28:53 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38173 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab3ARF2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 00:28:50 -0500
Message-ID: <50F8DD63.8070404@ti.com>
Date: Fri, 18 Jan 2013 10:58:03 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-sh@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <balbi@ti.com>, <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <b-cousson@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <horms@verge.net.au>,
        <magnus.damm@gmail.com>, <cbou@mail.ru>, <dwmw2@infradead.org>,
        <alexander.shishkin@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <leoli@freescale.com>, <eric.y.miao@gmail.com>,
        <haojian.zhuang@gmail.com>, <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH 3/6] usb: otg: utils: change the phy lib to support
 multiple PHYs of same type
References: <1358348462-27693-1-git-send-email-kishon@ti.com> <1358348462-27693-4-git-send-email-kishon@ti.com> <50F821DD.1040609@ti.com>
In-Reply-To: <50F821DD.1040609@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 17 January 2013 09:37 PM, Roger Quadros wrote:
> On 01/16/2013 05:00 PM, Kishon Vijay Abraham I wrote:
>> In order to add support for multipe PHY's of the same type, the API's
>> for adding PHY and getting PHY has been changed. Now the binding
>> information of the PHY and controller should be done in platform file
>> using usb_bind_phy API. And for getting a PHY, the device pointer of the
>> USB controller and an index should be passed. Based on the binding
>> information that is added in the platform file, get_phy will return the
>> approappropriate PHY.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>   arch/arm/mach-shmobile/board-marzen.c |    2 +-
>>   drivers/power/ab8500_charger.c        |    2 +-
>>   drivers/power/isp1704_charger.c       |    2 +-
>>   drivers/power/pda_power.c             |    2 +-
>>   drivers/power/twl4030_charger.c       |    2 +-
>>   drivers/usb/chipidea/udc.c            |    2 +-
>>   drivers/usb/dwc3/core.c               |    4 +-
>>   drivers/usb/gadget/fsl_udc_core.c     |    2 +-
>>   drivers/usb/gadget/mv_udc_core.c      |    2 +-
>>   drivers/usb/gadget/omap_udc.c         |    2 +-
>>   drivers/usb/gadget/pxa25x_udc.c       |    2 +-
>>   drivers/usb/gadget/pxa27x_udc.c       |    2 +-
>>   drivers/usb/gadget/s3c-hsudc.c        |    2 +-
>>   drivers/usb/host/ehci-fsl.c           |    2 +-
>>   drivers/usb/host/ehci-msm.c           |    2 +-
>>   drivers/usb/host/ehci-mv.c            |    2 +-
>>   drivers/usb/host/ehci-tegra.c         |    2 +-
>>   drivers/usb/host/ohci-omap.c          |    2 +-
>>   drivers/usb/musb/am35x.c              |    2 +-
>>   drivers/usb/musb/blackfin.c           |    2 +-
>>   drivers/usb/musb/da8xx.c              |    2 +-
>>   drivers/usb/musb/davinci.c            |    2 +-
>>   drivers/usb/musb/musb_dsps.c          |    2 +-
>>   drivers/usb/musb/omap2430.c           |    2 +-
>>   drivers/usb/musb/tusb6010.c           |    2 +-
>>   drivers/usb/musb/ux500.c              |    2 +-
>>   drivers/usb/otg/ab8500-usb.c          |    3 +-
>>   drivers/usb/otg/fsl_otg.c             |    5 ++-
>>   drivers/usb/otg/gpio_vbus.c           |    3 +-
>>   drivers/usb/otg/isp1301_omap.c        |    3 +-
>>   drivers/usb/otg/msm_otg.c             |    3 +-
>>   drivers/usb/otg/mv_otg.c              |    3 +-
>>   drivers/usb/otg/nop-usb-xceiv.c       |    3 +-
>>   drivers/usb/otg/otg.c                 |   67 +++++++++++++++------------------
>>   drivers/usb/otg/twl4030-usb.c         |    3 +-
>>   drivers/usb/phy/mv_u3d_phy.c          |    3 +-
>>   drivers/usb/phy/omap-usb2.c           |   11 ++----
>>   drivers/usb/phy/rcar-phy.c            |    3 +-
>>   include/linux/usb/phy.h               |   12 +++---
>>   39 files changed, 87 insertions(+), 89 deletions(-)
>
> I think it better to leave the existing add/get APIs as they are add add
> new APIs that support multiple PHYs. You could probably mark the old
> ones as deprecated.
>
> That way you don't need to wait till all users are converted and tested.

Makes sense. Will do that :-)

Thanks
Kishon
