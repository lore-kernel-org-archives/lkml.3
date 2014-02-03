Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaBCI0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 03:26:21 -0500
Received: from mail.active-venture.com ([67.228.131.205]:49897 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaBCI0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 03:26:20 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52EF52A8.4080400@roeck-us.net>
Date: Mon, 03 Feb 2014 00:26:16 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: monstr@monstr.eu
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 10/10] watchdog: xilinx: Enable this driver for Zynq
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com> <f7bdfada576e93eaab8f6dc2ecd881da8f43911c.1391177880.git.michal.simek@xilinx.com> <52EBB897.6040300@roeck-us.net> <52EF3ECF.4010006@monstr.eu>
In-Reply-To: <52EF3ECF.4010006@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2014 11:01 PM, Michal Simek wrote:
> On 01/31/2014 03:52 PM, Guenter Roeck wrote:
>> On 01/31/2014 06:18 AM, Michal Simek wrote:
>>> Enable this driver for Zynq.
>>> Move it to architecture independent Kconfig part.
>>>
>>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>>> ---
>>>
>>> Build tested by zero day testing system.
>>> ---
>>>    drivers/watchdog/Kconfig | 22 +++++++++-------------
>>>    1 file changed, 9 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
>>> index 9db5d3c..6120403 100644
>>> --- a/drivers/watchdog/Kconfig
>>> +++ b/drivers/watchdog/Kconfig
>>> @@ -111,6 +111,15 @@ config WM8350_WATCHDOG
>>>          Support for the watchdog in the WM8350 AudioPlus PMIC.  When
>>>          the watchdog triggers the system will be reset.
>>>
>>> +config XILINX_WATCHDOG
>>> +    tristate "Xilinx Watchdog timer"
>>> +    select WATCHDOG_CORE
>>
>> This needs to depend on HAS_IOMEM.
>
> Are you sure?
> I have no problem to do this change.
> Zero day testing system doesn't report any problem with it.
>
> I have checked dependencies and only score, tile and um has NO_IOMEM option
> enables. And below in log is tile with allyesconfig that's why I believe
> this driver has been also tested without any issue.
>

https://lkml.org/lkml/2014/1/31/123

I would have assumed the same applies here, but if you are sure that it doesn't I am fine.

Thanks,
Guenter

