Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab3LCJni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:43:38 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:59622 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab3LCJnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:43:33 -0500
Message-ID: <529DA7B6.4020402@ti.com>
Date: Tue, 3 Dec 2013 11:43:18 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>, <lee.jones@linaro.org>,
        <sameo@linux.intel.com>
CC: <tomi.valkeinen@ti.com>, <balbi@ti.com>, <sr@denx.de>,
        <ljkenny.mailinglists@gmail.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] mfd: omap-usb-host: Fix USB device detection problems
 on OMAP4 Panda
References: <1385730118-26402-1-git-send-email-rogerq@ti.com> <1385730118-26402-2-git-send-email-rogerq@ti.com> <AE90C24D6B3A694183C094C60CF0A2F6026B744D@saturn3.aculab.com> <529C4726.6080708@ti.com> <AE90C24D6B3A694183C094C60CF0A2F6026B7455@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7455@saturn3.aculab.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 06:28 PM, David Laight wrote:
>> From: Roger Quadros [mailto:rogerq@ti.com]
>> On 11/29/2013 03:17 PM, David Laight wrote:
> ...
>>>> +	timeout = jiffies + msecs_to_jiffies(100);
>>>> +	while (!(usbhs_read(omap->uhh_base, OMAP_UHH_SYSSTATUS)
>>>> +			& OMAP_UHH_SYSSTATUS_RESETDONE)) {
>>>> +		cpu_relax();
>>
>> You mean use msleep(1) here instead of cpu_relax()?
>> Shouldn't be a problem IMO, but can you please tell me why that is better
>> as the reset seems to complete usually in the first iteration.
> 
> If it doesn't finish in the first iteration you don't want to
> spin the cpu for 100ms.
> 
> If it hasn't finished in the first millisecond, you probably expect
> it to actually time out - so you might as well look (say) every 10ms.
> 

Understood now. Thanks.

cheers,
-roger
