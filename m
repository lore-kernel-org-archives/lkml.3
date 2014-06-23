Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbaFWRMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 13:12:41 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52396 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaFWRMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 13:12:39 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53A85FF9.2020303@roeck-us.net>
Date: Mon, 23 Jun 2014 10:12:25 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rob Herring <robh@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH v2] platform_get_irq: Revert to platform_get_resource
 if of_irq_get fails
References: <1403045462-24204-1-git-send-email-linux@roeck-us.net> <CAL_Jsq+Xi4UnFHouTqJQGyNVHpCcbNBRNgbQ3OY-+EsCDKFHLw@mail.gmail.com>
In-Reply-To: <CAL_Jsq+Xi4UnFHouTqJQGyNVHpCcbNBRNgbQ3OY-+EsCDKFHLw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 08:48 AM, Rob Herring wrote:
> On Tue, Jun 17, 2014 at 5:51 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> Commits 9ec36ca (of/irq: do irq resolution in platform_get_irq)
>> and ad69674 (of/irq: do irq resolution in platform_get_irq_byname)
>> change the semantics of platform_get_irq and platform_get_irq_byname
>> to always rely on devicetree information if devicetree is enabled
>> and if a devicetree node is attached to the device. The functions
>> now return an error if the devicetree data does not include interrupt
>> information, even if the information is available as platform resource
>> data.
>>
>> This causes mfd client drivers to fail if the interrupt number is
>> passed via platform resources. Therefore, if of_irq_get fails, try
>> platform_get_resource as method of last resort. This restores the
>> original functionality for drivers depending on platform resources
>> to get irq information.
>>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Rob Herring <robh@kernel.org>
>> Cc: Tony Lindgren <tony@atomide.com>
>> Cc: Grant Likely <grant.likely@linaro.org>
>> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>
> Acked-by: Rob Herring <robh@kernel.org>
>
> Greg should take this for 3.16.
>

Wound be great. In the meantime, I asked for the da9055 code to be re-tested,
since I suspect that it may be affected. There may be others, but I don't have
the time to track it all down.

Thanks,
Guenter

