Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333AbaBZKVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 05:21:14 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:36700 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaBZKVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 05:21:12 -0500
Message-ID: <530DC013.9040908@cogentembedded.com>
Date: Wed, 26 Feb 2014 14:21:07 +0400
From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: dbaryshkov@gmail.com
CC: "anton@enomsg.org" <anton@enomsg.org>, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mk7.kang@samsung.com, k.kozlowski@samsung.com, mark.rutland@arm.com
Subject: Re: [PATCH v2 0/3] power_supply: modelgauge_battery: Add Maxim ModelGauge
 ICs gauge
References: <1391293385-27539-1-git-send-email-vladimir.barinov@cogentembedded.com>
In-Reply-To: <1391293385-27539-1-git-send-email-vladimir.barinov@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry,

In accordance to this change you've taken the responsibility for power 
supply maintainership.
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/MAINTAINERS?id=573189354b7c97cd2256b87cf083ee435584594e

It passed almost month and no answer from you.
Does it make sense to apply this patch series?

Regards,
Vladimir

On 02/02/2014 02:23 AM, Vladimir Barinov wrote:
> Hello.
>
> This adds the folowing:
> - Maxim ModelGauge ICs gauge driver for MAX17040/41/43/44/48/49/58/59 chips
> - Document DT bindings
> - Remove superseded Maxim MAX17040 gauge driver
>
> Vladimir Barinov (3):
>   [1/3] power_supply: modelgauge_battery: Maxim ModelGauge ICs gauge
>   [2/3] dt: Document ModelGauge gauge bindings
>   [3/3] power_supply: modelgauge_battery: Remove Maxim MAX17040 gauge
>
> ---
> This patchset is against the 'kernel/git/torvalds/linux.git' repo.
>
> Changes since v1:
> - switched to REGMAP API
> - replaced request_threaded_irq with devm_request_threaded_irq
> - replaced cancel_delayed_work with _sync version
> - moved "empty_alert_threshold, soc_change_alert, hibernate_threshold,
>    active_threshold, undervoltage, overvoltage, resetvoltage" parameters
>    out from platform_data and DT
> - removed unused parameters "empty_adjustment, empty_adjustment"
> - added return value checks for of_property_read_XX functions
> - removed irrelevant bindings
> - fixed dt properties naming in documentation
> - added binding size description in documentation
> - removed satelite include file include/linux/max17040_battery.h
>
>   Documentation/devicetree/bindings/power_supply/modelgauge_battery.txt |   61
>   drivers/power/Kconfig                                                 |   17
>   drivers/power/Makefile                                                |    2
>   drivers/power/max17040_battery.c                                      |  297 ---
>   drivers/power/modelgauge_battery.c                                    |  838 ++++++++++
>   include/linux/max17040_battery.h                                      |   19
>   include/linux/platform_data/battery-modelgauge.h                      |   31
>   7 files changed, 940 insertions(+), 325 deletions(-)

