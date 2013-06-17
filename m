Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab3FQPGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:06:48 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:39426 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3FQPGn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:06:43 -0400
X-AuditID: cbfec37c-b7f166d000004b4e-ae-51bf2602c14a
From: Shuah Khan <shuah.kh@samsung.com>
To: Joe Perches <joe@perches.com>
Cc: "pavel@ucw.cz" <pavel@ucw.cz>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v2] power: Include additional information in pm_print_times
Thread-topic: [PATCH v2] power: Include additional information in pm_print_times
Thread-index: AQHOaT7Eqajdn/3QCUmACb6B4NqIbA==
Date: Mon, 17 Jun 2013 15:06:41 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61726FF6@sisaex02sj>
References: <1371242124-11452-1-git-send-email-shuah.kh@samsung.com>
 <1371243301.31941.61.camel@joe-AO722>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9hP10mtf2BBvev8lk0L17PZjH7/mMW
	i1lT9jJZXN41h83ic+8RRou7p46yWfQv7GWy+PrTwYHDY+esu+wei/e8ZPLYP3cNu8eXVdeY
	PR4tbmH0WLH6O7vH501yAexRXDYpqTmZZalF+nYJXBk9sxYxFSwTq9g5+zN7A+MvwS5GTg4J
	AROJp0suskDYYhIX7q1n62Lk4hASWMYocbljCTtIQkigl0niRn84RGI+o8THpq+MIAk2AXWJ
	z693ABVxcIgIKErc3cIPEmYW+MYk8fd/NYgtLOAvceXLH2YQW0QgQOLG0w2sELaeRO/bp2wg
	NouAqsSEvX/BangF7CWePHnACLE3R+L93kdgxzECHff91BomiPniEs2tN6GOFpBYsuc8M4Qt
	KvHy8T9WkHMkgM7ZvtoKolxLYv3O41Ct2hJP3l1ghVglKPFj8j2WCYxis5BMnYWkZRaSlllI
	WhYwsqxiFCstTi4oTkpPrTDWK07MLS7NS9dLzs/dxAiJ1JodjPe+2hxiFOBgVOLh5RDZHyjE
	mlhWXJl7iFGCg1lJhDd24r5AId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYwJUkvrey+ZPDu9sp15
	5f7b81f4BDUV7YjJfrtr2as8xeiLy8oFcsOuFUuoO9mbXP/8bHIH+1QnX+26+066F/kXvGBa
	vWtP9Rr7M9PUjm77krjiTJFcz2v5sm+JeUu/arF9fpXavVs1SK7eorS77Z7Xkhd9Qhzixd1c
	6zdN9O6zcaxt3r/92h4lluKMREMt5qLiRABqVoIRsgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 02:55 PM, Joe Perches wrote:
> On Fri, 2013-06-14 at 14:35 -0600, Shuah Khan wrote:
>> Change __device_suspend() path to include driver name and the ops that
>> get run for a device. This additional information helps associate the
>> driver and the type of pm_ops the device uses in the suspend path very
>> quickly which will aid in debugging problems in suspend and resume paths.
>> Changed both start and end debug messages to include pm_ops information
>> and use dev_info() instead of pr_info().
>>
>> dmesg output before the change:
>>
>> [  164.390032] calling  1-1+ @ 69, parent: usb1
>> [  164.390035] call 1-1+ returned 0 after 0 usecs
>
>> dmesg output after the change:
>>
>> [   58.707002] usb usb1: calling type pm ops @ 57, parent: 0000:00:1d.0
>> [   58.707641] usb usb1: call type pm ops returned 0 after 611 usecs
>
>> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> []
>> +static ktime_t initcall_debug_start(struct device *dev, char *info)
> []
>> +		/* string in info has an extra space at the end */
>> +		dev_info(dev, "calling %s@ %i, parent: %s\n",
>> +			info, task_pid_nr(current),
>>   			dev->parent ? dev_name(dev->parent) : "none");
>
>>   static void initcall_debug_report(struct device *dev, ktime_t calltime,
> []
>> -		pr_info("call %s+ returned %d after %Ld usecs\n", dev_name(dev),
>> +		/* string in info has an extra space at the end */
>> +		dev_info(dev, "call %sreturned %d after %llu usecs\n", info,
>>   			error, (unsigned long long)ktime_to_ns(delta) >> 10);
>
> Perhaps align the "calling and "call" and include
> task_pid_nr(current)?
>
> [   58.707002] usb usb1: calling type pm ops @ 57, parent: 0000:00:1d.0
> [   58.707641] usb usb1: call type pm ops returned 0 after 611 usecs
>
> so it's:
>
> [   58.707002] usb usb1: enter 'type pm ops' @ 57, parent: 0000:00:1d.0
> [   58.707641] usb usb1: exit  'type pm ops' @ 57, parent: 0000:00:1d.0, error: 0 (611 usecs)
>
> or:
>
> [   58.707002] usb usb1: enter 'type pm ops' @ 57, parent: 0000:00:1d.0
> [   58.707641] usb usb1: exit  'type pm ops' @ 57, error:  0 (611 usecs)
>
>
>

Including parent id and task id in the debug_report makes sense to have 
a tighter association between start and end messages. Let me re-work it 
and send another revision of the patch. I will use Start/end or 
Begin/end pairing.

thanks,
-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
