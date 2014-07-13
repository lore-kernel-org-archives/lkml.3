Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbaGMPqs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 11:46:48 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57997 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbaGMPqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 11:46:42 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53C2A9E1.2080807@roeck-us.net>
Date: Sun, 13 Jul 2014 08:46:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: Wolfram Sang <wsa@the-dreams.de>, Randy Dunlap <rdunlap@infradead.org>,
        linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c: stub: Add support for SMBus block commands
References: <1404742983-27303-1-git-send-email-linux@roeck-us.net>	<20140708215453.0677d3ed@endymion.delvare>	<53BC4F15.9030608@roeck-us.net>	<20140712112019.618d8a03@endymion.delvare>	<53C14ECD.7050105@roeck-us.net>	<20140713092127.4bedfa18@endymion.delvare>	<53C2A016.2070906@roeck-us.net> <20140713171343.0a4ba58d@endymion.delvare>
In-Reply-To: <20140713171343.0a4ba58d@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2014 08:13 AM, Jean Delvare wrote:
> On Sun, 13 Jul 2014 08:04:54 -0700, Guenter Roeck wrote:
>> On 07/13/2014 12:21 AM, Jean Delvare wrote:
>>> Hi Guenter,
>>>
>>> On Sat, 12 Jul 2014 08:05:49 -0700, Guenter Roeck wrote:
>>>> Any idea how we could inject errors ? Error path testing would be quite useful.
>>>
>>> Good idea. This should probably be done with a sysfs attribute so that
>>> it can be turned on and off as desired. Off by default, of course. Some
>>> other subsystems already support error injection, you could check how
>>> they are doing it, do that we do not diverge needlessly.
>>>
>>> Do you think there is any value in failing with different error codes,
>>> or just -EIO is enough?
>>
>> How about writing the error code to return into the attribute ?
>> Write anything negative, and it is returned as error. Write 0,
>> and the driver works as normal.
>
> This is smart, I like it :)
>
>>> Do you think it should fail all the time when error injection is
>>> enabled, or is there a value in having only a certain % of commands
>>> fail?
>>
>> For my purposes I would want it to fail reliably. We could add some fanciness,
>> though: Provide a second attribute which specifies how many operations should
>> pass before the first failure.
>
> Let's start simple and just implement what you need.
>

I would actually benefit from both. The ability to return an error unconditionally
lets me test the first error path. The ability to return an error starting with the
n-th transfer lets me test the n-th error path.

Guenter

