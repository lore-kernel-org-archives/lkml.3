Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbaEII2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:28:30 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43729 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752724AbaEII2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:28:24 -0400
Message-ID: <536C91A6.6000500@free-electrons.com>
Date: Fri, 09 May 2014 10:28:22 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>, Lee Jones <lee.jones@linaro.org>
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
References: <1399483554-8824-1-git-send-email-boris.brezillon@free-electrons.com> <1399483554-8824-4-git-send-email-boris.brezillon@free-electrons.com> <20140508110205.GB5767@lee--X1> <536BE366.8080907@free-electrons.com> <20140509071246.GE5767@lee--X1> <536C84F6.2050701@redhat.com> <20140509080807.GH5767@lee--X1> <536C8F71.5040604@redhat.com>
In-Reply-To: <536C8F71.5040604@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/05/2014 10:18, Hans de Goede wrote:
> Hi,
>
> On 05/09/2014 10:08 AM, Lee Jones wrote:
>>>>>>> +static struct platform_driver sun6i_prcm_driver = {
>>>>>>> +	.driver = {
>>>>>>> +		.name = "sun6i-prcm",
>>>>>>> +		.owner = THIS_MODULE,
>>>>>>> +		.of_match_table = sun6i_prcm_dt_ids,
>>>>>>> +	},
>>>>>>> +	.probe = sun6i_prcm_probe,
>>>>>> You need a .remove() call-back.
>>>>> This driver cannot be compiled as module (see the Kconfig definition)
>>>>> and the devices are not hotpluggable, as a result a probed device will
>>>>> never be removed.
>>>>>
>>>>> Do you still want me to implement the remove function ?
>>>> .remove() also be run on shut down.
>>> That is not true, if your device needs to do anything special at shutdown
>>> you need to add a shutdown callback. Devices are kept as is (not torn down)
>>> on shutdown.
>> Ah okay, I'll bow to your knowledge.  So there's no reason for this
>> driver to ever call mfd_remove_devices() then?
> No, this is an integral part of the SOC, which never gets removed in any way.

Lee, I'm about to send a 3rd version of this series, is it okay for you
if I leave the remove function unimplemented ?

>
> Regards,
>
> Hans

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

