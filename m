Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab3GILxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 07:53:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33853 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab3GILxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 07:53:12 -0400
Message-ID: <51DBF98B.1050104@ti.com>
Date: Tue, 9 Jul 2013 17:22:43 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>, <afzal@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] arm: dts: AM43x: Add usb_otg_hs node
References: <1373361446-30050-1-git-send-email-george.cherian@ti.com> <20130709102022.GH5552@arwen.pp.htv.fi> <51DBF23F.20103@ti.com> <20130709112751.GI5552@arwen.pp.htv.fi>
In-Reply-To: <20130709112751.GI5552@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/2013 4:57 PM, Felipe Balbi wrote:
> Hi,
>
> On Tue, Jul 09, 2013 at 04:51:35PM +0530, George Cherian wrote:
>>>> +				compatible = "snps,dwc3";
>>>> +				reg = <0x48390000 0xcfff>;
>>> weird size, shouldn't this be 0xd000 then the size would be exactly
>>> 52KiB
>> okay
> btw, the reason here is that when you call devm_ioremap_resource(), that
> will call resource_size() which does:
>
> 	size = res->end - res->start - 1;
>
> so you need this extra 1 on the size when passing it via DT.

agreed.
>>> Another thing: am437x has 4 instances of this IP, why are you adding
>>> only one ?
>> AM437x has got only 2 instances. I have verified only one on HAPS so
>> adding only one.
> weird, on my TRM I see for dwc3 but 2 PHYs.

Please confirm whether you are looking at am437x TRM or dra7x TRM?
dra7x has 4 dwc3 and 2 internal  phys and 2 external phys
>>> And why aren't you pasing the PHY nodes here ? The device
>>> won't work without its PHYs.
>> Yes true, again in HAPS I  didnt have any PHY configuration to be done.
> alright, but we should still pass the PHY right ? once silicon comes,
> we want this to work without any further changers.

okay will add phy nodes and 2 instances of dwc3.



-- 
-George

