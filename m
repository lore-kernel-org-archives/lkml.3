Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaHUPE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 11:04:56 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:57884 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaHUPEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 11:04:53 -0400
Message-ID: <53F60A92.4040702@linaro.org>
Date: Thu, 21 Aug 2014 17:04:50 +0200
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: rjw@rjwysocki.net, linus.walleij@linaro.org, gnurou@gmail.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH] ACPI: Add GPIO-signaled event emulator.
References: <1408546700-19309-1-git-send-email-tomasz.nowicki@linaro.org> <20140821104533.GM1660@lahna.fi.intel.com> <53F604B2.6020004@linaro.org> <20140821145405.GU1660@lahna.fi.intel.com>
In-Reply-To: <20140821145405.GU1660@lahna.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.08.2014 16:54, Mika Westerberg wrote:
> On Thu, Aug 21, 2014 at 04:39:46PM +0200, Tomasz Nowicki wrote:
>>>> +{
>>>> +	struct gpio_pin_data *pin_data, *temp;
>>>> +
>>>> +	list_for_each_entry_safe(pin_data, temp, &pin_data_list, list)
>>>> +		kfree(pin_data);
>>>
>>> I suppose you want to first remove the directory entries and then the
>>> pin data. Otherwise if you get pre-empted at this point and someone
>>> tries to use your debugfs files, bad things might happen.
>> Good catch!
>>
>>>
>>>> +
>>>> +	debugfs_remove_recursive(acpi_evt_debugfs_dir);
>>>
>>> Since this already removes everything below this dentry, why do you need
>>> to store the pointer in gpio_pin_parent_data?
>> Not sure I got the question.
>>
>> GPIO device instance (debugfs dir) is parent for all its pins (debugfs
>> nodes). I am using gpio_pin_parent_data as container to pass info for all
>> children so I can create debugfs node inside of parent related debugfs dir.
>>
>> pin_data_list, however, is used to keep pointers to allocated memory (one
>> for each pins). debugfs_remove_recursive won't free it.
>
> Yes but it removes the debugfs entries below so you don't need to store
> the children debugfs dentries.
>
I don't, gpio_pin_parent_data (local variable) keeps pointer to *parent 
debugfs dentries* only. gpio_pin_parent_data name might be misleading, I 
will rename it to gpio_parent_data in next version.

Regards,
Tomasz
