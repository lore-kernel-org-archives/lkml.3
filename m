Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab3GOIYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 04:24:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58823 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845Ab3GOIYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 04:24:30 -0400
Message-ID: <51E3B19E.80906@ti.com>
Date: Mon, 15 Jul 2013 11:23:58 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <sergei.shtylyov@cogentembedded.com>, <tony@atomide.com>,
        <ruslan.bilovol@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 4/6] mfd: omap-usb-host: Put pins in IDLE state on suspend
References: <1373473081-27181-1-git-send-email-rogerq@ti.com> <1373473380-27515-1-git-send-email-rogerq@ti.com> <51E2A603.1000805@linaro.org>
In-Reply-To: <51E2A603.1000805@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2013 04:22 PM, Kevin Hilman wrote:
> On 07/10/2013 05:23 PM, Roger Quadros wrote:
>> In order to support wake up from suspend use the pinctrl
>> framework to put the USB host pins in IDLE state during suspend.
>>
>> CC: Samuel Ortiz <sameo@linux.intel.com>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
> 
> [...]
> 
>> @@ -608,6 +618,14 @@ static int usbhs_omap_probe(struct platform_device *pdev)
>>  		return -ENOMEM;
>>  	}
>>  
>> +	if (!dev->pins || !dev->pins->idle_state) {
>> +		/* If IDLE pins are not available, we can't remote wakeup,
>> +		 * so prevent idling in that case.
>> +		 */
> 
> nit: multi-line comment style
> 
> Also, if there are no pins, aren't the pinctrl ops nops anyways?  IOW,
> not sure the need
> for this is clear, and it's not mentioned in the changelog.

The pinctrl ops are nops but the runtime suspend isn't. So in this case,
we'll never be able to wake up the USB controller.

I'll update the changelog to reflect this.

cheers,
-roger
