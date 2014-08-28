Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965868AbaH1LTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 07:19:50 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57057 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965837AbaH1LTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 07:19:47 -0400
Message-ID: <53FF1054.508@linaro.org>
Date: Thu, 28 Aug 2014 13:19:48 +0200
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linus.walleij@linaro.org, gnurou@gmail.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH] ACPI: Add GPIO-signaled event emulator.
References: <1408546700-19309-1-git-send-email-tomasz.nowicki@linaro.org> <20140821104533.GM1660@lahna.fi.intel.com> <53F604B2.6020004@linaro.org> <1828087.V5efjsXTdI@vostro.rjw.lan>
In-Reply-To: <1828087.V5efjsXTdI@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.08.2014 00:39, Rafael J. Wysocki wrote:
> On Thursday, August 21, 2014 04:39:46 PM Tomasz Nowicki wrote:
>> Hi Mika,
>>
>> On 21.08.2014 12:45, Mika Westerberg wrote:
>>> On Wed, Aug 20, 2014 at 04:58:20PM +0200, Tomasz Nowicki wrote:
>
> [cut]
>
>>>> +
>>>> +static int gpio_evt_trigger(void *data, u64 val)
>>>> +{
>>>> +	struct gpio_pin_data *pin_data = (struct gpio_pin_data *)data;
>>>> +	int pin = pin_data->pin;
>>>> +
>>>> +	if (ACPI_FAILURE(acpi_execute_simple_method(pin_data->handle, NULL,
>>>> +						    pin <= 255 ? 0 : pin)))
>>>> +		pr_err(PREFIX "evaluating event method failed\n");
>>>
>>> acpi_execute_simple_method() passes one argument to the method. You
>>> can't use it with _Lxx or _Exx which don't expect any arguments.
>>> Otherwise you get this:
>>>
>>> [  122.258191] ACPI: \_SB_.GPO2._E12: Excess arguments - Caller passed 1, method requires 0 (20140724/nsarguments-263)
>> Right, I will fix it.
>
> OK, so here's my concern.
>
> If AML does any kind of tracking of state in _Exx/_Lxx, you'll likely totally
> confuse it by calling those things at random.
>
> I'm not sure I'm seeing a compelling reason to put this thing into the tree
> for this reason.

Yes you are right, but this emulator is only for debugging/development 
purposes and goes with clear statement "DANGER to use on production 
kernel", like APEI error injection feature.

IMO, this emulator would help with:
1. testing and developing AML methods
2. working on ACPI subsystems that need GPIO-signaled events without 
GPIO h/w

Regards,
Tomasz
