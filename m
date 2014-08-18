Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaHRJGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:06:51 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:58623 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaHRJGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:06:49 -0400
Message-ID: <53F1C226.5090107@linaro.org>
Date: Mon, 18 Aug 2014 11:06:46 +0200
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
CC: Alexandre Courbot <gnurou@gmail.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [RFC] ACPI: Add GPIO-signaled event simulator.
References: <1406217076-17150-1-git-send-email-tomasz.nowicki@linaro.org> <CACRpkdZmKJmaTRBpDrzd7+EhPuFeScr6jEHC8+0z6-4knjFqkA@mail.gmail.com>
In-Reply-To: <CACRpkdZmKJmaTRBpDrzd7+EhPuFeScr6jEHC8+0z6-4knjFqkA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.08.2014 14:36, Linus Walleij wrote:
> On Thu, Jul 24, 2014 at 5:51 PM, Tomasz Nowicki
> <tomasz.nowicki@linaro.org> wrote:
>
>> GPIO signaled events is quite new thing in Linux kernel.
>> AFAIK, there are not many board which can take advantage of it.
>> However, GPIO events are very useful feature during work on ACPI
>> subsystems.
>
> Overall this seems like a pretty nice debug feature.
>
>> This commit emulates GPIO h/w behaviour and consists on read/write
>> operation to debugfs file. GPIO device instance is still required in DSDT
>> table along with _AEI resources and event methods.
>>
>> Reading from file provides pin to GPIO device map e.g. :
>> $ cat /sys/kernel/debug/acpi/gpio_event
>> GPIO device name: /__SB.GPI0
>> Available GPIO pin map:
>> /__SB.GPI0 <-> pin 0x100
>>
>> Based on that, user can trigger method corresponding to device pin number:
>> $ echo "/__SB.GPI0 0x100" > /sys/kernel/debug/acpi/gpio_event
>
> I need input from Rafael and Mika as to whether this is a
> good interface.
>
> It seems a bit confusing for me: why do you have to extract
> a number from one file and then insert the same magic number
> somewhere else?

Good point! Available GPIO event pins should be listed as debugfs node, 
then user would write e.g. 1 to one particular. Sounds simpler.

Regards,
Tomasz Nowicki
