Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbaEIHgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:36:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbaEIHf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:35:58 -0400
Message-ID: <536C84F6.2050701@redhat.com>
Date: Fri, 09 May 2014 09:34:14 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v2 3/7] mfd: add support for sun6i PRCM (Power/Reset/Clock
 Management) unit
References: <1399483554-8824-1-git-send-email-boris.brezillon@free-electrons.com> <1399483554-8824-4-git-send-email-boris.brezillon@free-electrons.com> <20140508110205.GB5767@lee--X1> <536BE366.8080907@free-electrons.com> <20140509071246.GE5767@lee--X1>
In-Reply-To: <20140509071246.GE5767@lee--X1>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/09/2014 09:12 AM, Lee Jones wrote:
>>>> +static struct platform_driver sun6i_prcm_driver = {
>>>> +	.driver = {
>>>> +		.name = "sun6i-prcm",
>>>> +		.owner = THIS_MODULE,
>>>> +		.of_match_table = sun6i_prcm_dt_ids,
>>>> +	},
>>>> +	.probe = sun6i_prcm_probe,
>>> You need a .remove() call-back.
>>
>> This driver cannot be compiled as module (see the Kconfig definition)
>> and the devices are not hotpluggable, as a result a probed device will
>> never be removed.
>>
>> Do you still want me to implement the remove function ?
> 
> .remove() also be run on shut down.

That is not true, if your device needs to do anything special at shutdown
you need to add a shutdown callback. Devices are kept as is (not torn down)
on shutdown.

> It's best practice to have one.
> 
>>>> +module_platform_driver(sun6i_prcm_driver);
>>>> +
>>>> +MODULE_AUTHOR("Boris BREZILLON <boris.brezillon@free-electrons.com>");
>>>> +MODULE_DESCRIPTION("Allwinner sun6i PRCM driver");
>>>> +MODULE_LICENSE("GPL v2");
>>
> 

Regards,

Hans
