Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbaHGGUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:20:54 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62009 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351AbaHGGUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:20:39 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E31AB0.6070604@roeck-us.net>
Date: Wed, 06 Aug 2014 23:20:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: kreijack@inwind.it
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>, Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH 5/5] Export the temperatures via hwmon
References: <1407359103-6012-1-git-send-email-kreijack@inwind.it> <1407359103-6012-6-git-send-email-kreijack@inwind.it> <20140806231803.GA5643@roeck-us.net> <53E31694.8050107@gmail.com>
In-Reply-To: <53E31694.8050107@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2014 11:03 PM, Goffredo Baroncelli wrote:
> On 08/07/2014 01:18 AM, Guenter Roeck wrote:
>> On Wed, Aug 06, 2014 at 09:05:03PM +0000, Goffredo Baroncelli wrote:
>>> From: Goffredo Baroncelli <kreijack@iniwnd.it>
>>>
>>> Export the temperature via the hwmon subsystem.
>>> See the list below for the sensors exported:
>>>
>>> $ cd /sys/devices/temperature/hwmon/hwmon0
>>> $ echo "name: $(cat name)"; for i in temp*; do echo "$i: $(cat $i)"; done
>>> name: therm_windtunnel
>>> temp1_input: 59312
>>> temp1_label: CPU
>>> temp2_input: 36750
>>> temp2_label: Case
>>> temp3_input: 37750
>>> temp3_label: Case2
>>>
>> Makes me wonder why you don't report the fan speed through hwmon.
>
> See the first email. Basically when I start to read the fan speed,
> it became irregular, so I stopped the test. I don't know
> if it is a my faulted hardware, or an hw design problem.
> The fan is a 2 wire fan.
>

Patch 4/5 is "Return the fan speed via sysfs: /sys/devices/temperature/fan_level".

So you are saying that returning the fan speed with a non-hwmon attribute works,
but returning it with a hwmon attribute doesn't ? Not really sure if I understand
your logic. Either fan_level doesn't return the fan speed (or an abstraction of it),
or something in your line of argument is inconsistent.

Guenter

