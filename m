Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab3FNQzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:55:04 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:28098 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3FNQzC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:55:02 -0400
X-AuditID: cbfec37b-b7f306d0000047de-c5-51bb4ae4f2b4
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg KH <gregkh@linuxfoundation.org>, "joe@perches.com" <joe@perches.com>
Cc: "pavel@ucw.cz" <pavel@ucw.cz>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH] power: Include additional information in pm_print_times
Thread-topic: [PATCH] power: Include additional information in pm_print_times
Thread-index: AQHOaR0F3iFbU9ddzEeUT9NYOzW7/A==
Date: Fri, 14 Jun 2013 16:54:59 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6156A8FE@sisaex02sj>
References: <1371227625-3141-1-git-send-email-shuah.kh@samsung.com>
 <20130614164546.GA26107@kroah.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t9hP90nXrsDDc43SVg0L17PZjH7/mMW
	i1lT9jJZXN41h83ic+8RRou7p46yWfQv7GWy+PrTwYHDY+esu+wei/e8ZPLYP3cNu8eXVdeY
	PR4tbmH0WLH6O7vH501yAexRXDYpqTmZZalF+nYJXBn/umoKpkhVPNzwgq2BcZNoFyMnh4SA
	icT/r79YIGwxiQv31rN1MXJxCAksY5R42tfCAuH0MklsmPWMGaRKSGA+o8Tu1bkgNpuAusTn
	1zvYQWwRAV+Jcw0bmEEamAWmMUk8/TORCSQhLOAjsW3dGriiI7+3MELYehLN0xvAbBYBVYn5
	Z2+BLeAVsJd4f+gEK8SyDImuZxfB4oxA530/tQZsJrOAuERz602oswUkluw5zwxhi0q8fPwP
	qJcDyFaU2L7aCqJcS2L9zuNQrdoST95dYIVYJSjxY/I9lgmMYrOQTJ2FpGUWkpZZSFoWMLKs
	YhQrLU4uKE5KT60w0itOzC0uzUvXS87P3cQIidXqHYx3v9ocYhTgYFTi4X2hsTtQiDWxrLgy
	9xCjBAezkgjvXVWgEG9KYmVValF+fFFpTmrxIUYmDk6pBka5yO5tbUKLdG1+3163Yr+6VSXj
	Sfue/6oNhYVrdogUWwgu4Wnamml86uxJpbO3SiZOMTkQ+uOiH+eXhHnBC4KudQnkHLEVTI66
	3Fa169LrRRM8Iq7qOc66cDWtq4f9YVWxay9HTjrPrueT75nmlbcyHZwj/mcy70Ivv3f+t4Nz
	S1jPXg68na/EUpyRaKjFXFScCAAGqUZyswIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 10:45 AM, Greg KH wrote:
> On Fri, Jun 14, 2013 at 10:33:45AM -0600, Shuah Khan wrote:
>> Change __device_suspend() path to include driver name and the ops that
>> get run for a device. This additional information helps associate driver
>> and the type of pm_ops the device uses in suspend path very quickly and
>> aid in debugging problems in suspend and resume paths. Added the additional
>> information at the end of the original message.
>>
>> dmesg output before the change:
>>
>> [  164.390032] calling  1-1+ @ 69, parent: usb1
>> [  164.390035] call 1-1+ returned 0 after 0 usecs
>>
>> [  164.390352] calling  00:0a+ @ 2457, parent: pnp0
>> [  164.390357] call 00:0a+ returned 0 after 3 usecs
>>
>> [  164.390361] calling  00:09+ @ 2457, parent: pnp0
>> [  164.496458] call 00:09+ returned 0 after 103500 usecs
>>
>> [  164.496494] calling  00:05+ @ 2457, parent: pnp0
>> [  164.496511] call 00:05+ returned 0 after 14 usecs
>>
>> dmesg output after the change:
>>
>> [  317.295499] calling 1-1+ @ 71, parent: usb1 driver: usb type pm ops
>> [  317.297671] call 1-1+ returned 0 after 2117 usecs
>>
>> [  318.134469] calling 00:0a+ @ 2941, parent: pnp0 driver: system legacy bus
>> [  318.134476] call 00:0a+ returned 0 after 5 usecs
>>
>> [  317.292894] calling 00:09+ @ 2941, parent: pnp0 driver: tpm_tis legacy bus pm ops
>> [  317.397315] call 00:09+ returned 0 after 101967 usecs
>>
>> [  317.397353] calling 00:05+ @ 2941, parent: pnp0 driver: rtc_cmos legacy bus pm ops
>> [  317.397369] call 00:05+ returned 0 after 13 usecs
>>
>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>> CC: Shuah Khan <shuahkhan@gmail.com>
>> ---
>>   drivers/base/power/main.c |   35 ++++++++++++++++++++---------------
>>   1 file changed, 20 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
>> index 5a9b656..900266d 100644
>> --- a/drivers/base/power/main.c
>> +++ b/drivers/base/power/main.c
>> @@ -157,14 +157,15 @@ void device_pm_move_last(struct device *dev)
>>   	list_move_tail(&dev->power.entry, &dpm_list);
>>   }
>>
>> -static ktime_t initcall_debug_start(struct device *dev)
>> +static ktime_t initcall_debug_start(struct device *dev, char *info)
>>   {
>>   	ktime_t calltime = ktime_set(0, 0);
>>
>>   	if (pm_print_times_enabled) {
>> -		pr_info("calling  %s+ @ %i, parent: %s\n",
>> +		pr_info("calling %s+ @ %i, parent: %s driver: %s %s\n",
>>   			dev_name(dev), task_pid_nr(current),
>
> As we have a 'struct device' here, why aren't we just using dev_info()
> instead?  That will get us the "proper" structured logging information,
> and the needed information that you are looking for as well, right?
>
> thanks,
>
> greg k-h
>

Good point.I see Joe saying the same thing. Will take care of it.

thanks,
-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
