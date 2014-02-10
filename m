Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaBJI1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 03:27:50 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51149 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaBJI1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 03:27:47 -0500
Message-ID: <52F88D79.9040203@ti.com>
Date: Mon, 10 Feb 2014 13:57:37 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <kgene.kim@samsung.com>, <balbi@ti.com>, <k.debski@samsung.com>,
        <s.nawrocki@samsung.com>, <jwerner@chromium.org>,
        <jg1.han@samsung.com>
Subject: Re: [PATCH v3] phy: Add new Exynos5 USB 3.0 PHY driver
References: <1386151747-3209-2-git-send-email-gautam.vivek@samsung.com> <1390225363-24210-1-git-send-email-gautam.vivek@samsung.com> <52F39710.80101@samsung.com>
In-Reply-To: <52F39710.80101@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 06 February 2014 07:37 PM, Tomasz Figa wrote:
> Hi Vivek,
> 
> This patch is just adding the PHY driver. I would also like to look at some
> users of it, to see how this works when put together.
> 
> For now, please see my comments inline.
> 
> On 20.01.2014 14:42, Vivek Gautam wrote:
>> Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
>> The new driver uses the generic PHY framework and will interact
>> with DWC3 controller present on Exynos5 series of SoCs.
>> Thereby, removing old phy-samsung-usb3 driver and related code
>> used untill now which was based on usb/phy framework.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>
>> Changes from v2:
>> 1) Added support for multiple PHYs (UTMI+ and PIPE3) and
>>     related changes in the driver structuring.
> 
> I'm a bit skeptical about this separation. Can the PHY operate with just the
> UTMI+ or PIPE3 part enabled alone without the other? Can any PHY consumer
> operate this way?

Theoretically yes. If the USB controller should operate only in high-speed
mode, the PIPE3 part is not required at all. However for super speed mode both
PIPE3 part and UTMI part should be enabled. Maybe it doesn't work that way with
all SoCs because of some HW bug.
> 
> Introducing separation of something that can't exist alone doesn't add any
> value, but instead makes things more difficult to work with. Of course, it's

IMO separating it into different parts adds more clarity to the driver.

Thanks
Kishon
