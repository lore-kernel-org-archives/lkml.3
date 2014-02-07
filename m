Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaBGINT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:13:19 -0500
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1042 "EHLO
	smtp-out-089.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751439AbaBGINS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:13:18 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 10806
Message-ID: <52F495A4.70400@metafoo.de>
Date: Fri, 07 Feb 2014 09:13:24 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH 3/4] rtc: rtc-jz4740: Use devm_ioremap_resource()
References: <000401cf23d9$d1df6e30$759e4a90$%han@samsung.com> <000701cf23da$688e1b60$39aa5220$%han@samsung.com>
In-Reply-To: <000701cf23da$688e1b60$39aa5220$%han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 08:58 AM, Jingoo Han wrote:
[...]
> -	rtc->base = devm_ioremap_nocache(&pdev->dev, rtc->mem->start,
> -					resource_size(rtc->mem));
> -	if (!rtc->base) {
> -		dev_err(&pdev->dev, "Failed to ioremap mmio memory\n");
> -		return -EBUSY;
> -	}
> +	mem->flags &= ~IORESOURCE_CACHEABLE;

You shouldn't be modifying the resource, strictly speaking it is not owned 
by the device. And IORESOURCE_CACHEABLE is never set for this device anyway.

> +	rtc->base = devm_ioremap_resource(&pdev->dev, mem);
> +	if (IS_ERR(rtc->base))
> +		return PTR_ERR(rtc->base);
>
>   	spin_lock_init(&rtc->lock);
>
>

