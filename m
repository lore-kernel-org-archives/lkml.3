Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270AbaDAAYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 20:24:32 -0400
Received: from mail.active-venture.com ([67.228.131.205]:65064 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaDAAY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 20:24:29 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <533A073A.6060807@roeck-us.net>
Date: Mon, 31 Mar 2014 17:24:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Harini Katakam <harinik@xilinx.com>
CC: grant.likely@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, michals@xilinx.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] watchdog: Add Cadence WDT driver
References: <1396002720-7105-1-git-send-email-harinik@xilinx.com> <20140331113020.03be6894@alan.etchedpixels.co.uk>
In-Reply-To: <20140331113020.03be6894@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 03:30 AM, One Thousand Gnomes wrote:
>
>> +	wdt->cdns_wdt_notifier.notifier_call = &cdns_wdt_notify_sys;
>> +	/* Register the reboot notifier */
>> +	ret = register_reboot_notifier(&wdt->cdns_wdt_notifier);
>> +	if (ret != 0) {
>> +		dev_err(&pdev->dev, "cannot register reboot notifier err=%d)\n",
>> +			ret);
>> +		return ret;
>
> Your ordering is wrong. If the box reboots between here and the spin lock
> in it further down it'll crash in your notifier.
>
Not only that, the callback also ends up using watchdog_get_drvdata()
which is only set after registering the notifier.

Guenter

> As
>
>> +	spin_lock_init(&wdt->io_lock);
>
> is needed before the code your notifier calls will work.
>
>> +	dev_info(&pdev->dev, "Xilinx Watchdog Timer at %p with timeout %ds%s\n",
>> +		 wdt->regs, cdns_wdt_device->timeout,
>> +		 nowayout ? ", nowayout" : "");
>
> dev_dbg
>
> if every driver felt the need to announce itself on boot you'd have pages
> and pages of junk.
>
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

