Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab3AUOYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:24:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38041 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab3AUOYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:24:43 -0500
Message-ID: <50FD4F90.7080101@ti.com>
Date: Mon, 21 Jan 2013 16:24:16 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: kishon <kishon@ti.com>
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
Subject: Re: [RFC PATCH 6/6] USB: MUSB: OMAP: get PHY by phandle for dt boot
References: <1358348462-27693-1-git-send-email-kishon@ti.com> <1358348462-27693-7-git-send-email-kishon@ti.com> <50FD4034.5040402@ti.com> <50FD4593.5020007@ti.com>
In-Reply-To: <50FD4593.5020007@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 03:41 PM, kishon wrote:
> Hi,
> 
> On Monday 21 January 2013 06:48 PM, Roger Quadros wrote:
>> On 01/16/2013 05:01 PM, Kishon Vijay Abraham I wrote:
>>> The OMAP glue has been modified to get PHY by phandle for dt boot.
>>>
>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>> ---
>>>   drivers/usb/musb/omap2430.c |    7 ++++++-
>>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
>>> index 3628a50..08709cf 100644
>>> --- a/drivers/usb/musb/omap2430.c
>>> +++ b/drivers/usb/musb/omap2430.c
>>> @@ -346,7 +346,12 @@ static int omap2430_musb_init(struct musb *musb)
>>>        * up through ULPI.  TWL4030-family PMICs include one,
>>>        * which needs a driver, drivers aren't always needed.
>>>        */
>>> -    musb->xceiv = devm_usb_get_phy(dev, 0);
>>> +    if (dev->parent->of_node)
>>> +        musb->xceiv = devm_usb_get_phy_by_phandle(dev->parent,
>>> +            "usb_phy", 0);
>>
>> Why dev->parent and not just dev?
> 
> Right now MUSB core is not converted to dt and hence we don't have
> separate dt node for MUSB core.
> So the PHY information is added to the glue dt data.
> 

OK. Got it :).

--
cheers,
-roger


