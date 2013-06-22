Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161623Ab3FVA6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 20:58:32 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:24392 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161523Ab3FVA6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 20:58:30 -0400
X-AuditID: cbfec37b-b7f306d0000047de-ed-51c4f6b442a2
From: Shuah Khan <shuah.kh@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "pavel@ucw.cz" <pavel@ucw.cz>, "len.brown@intel.com" <len.brown@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "joe@perches.com" <joe@perches.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCHv v3] power: Include additional information in pm_print_times
Thread-topic: [PATCHv v3] power: Include additional information in
 pm_print_times
Thread-index: AQHOa5INUOX6+S75906ZF4yA9Bsfdg==
Date: Sat, 22 Jun 2013 00:58:28 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6172EFEE@sisaex02sj>
References: <1371497795-20084-1-git-send-email-shuah.kh@samsung.com>
 <2534796.mOHH0DCD2A@vostro.rjw.lan>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9hP92t344EGrz8ymzRvHg9m8Xs+49Z
	LGZN2ctkcXnXHDaLz71HGC3unjrKZtG/sJfJ4utPBwcOj52z7rJ7LN7zkslj/9w17B5fVl1j
	9ni0uIXRY8Xq7+wenzfJBbBHcdmkpOZklqUW6dslcGVMWzqDueCYRMWKJd0sDYy3hLsYOTkk
	BEwkXnz7ywZhi0lcuLceyObiEBJYxigxccJDRginl0ni3a7/rCBVQgLzGSUWXigEsdkE1CU+
	v97BDmKLCKhKbHnynx2kgVngH5PExyudTCAJYYEAif+TJ7FAFAVLzPv1jRHC1pNYO3s12GoW
	oOa9s5+ADeIVsJd4d2ciO8SyLIkb15eD9TICnff91BqwmcwC4hLNrTdZIM4WkFiy5zwzhC0q
	8fLxP6BDOYBsRYntq60gyrUk1u88DtWqLfHk3QVWiFWCEj8m32OZwCg2C8nUWUhaZiFpmYWk
	ZQEjyypGsdLi5ILipPTUCiO94sTc4tK8dL3k/NxNjJBord7BePerzSFGAQ5GJR7eA6lHAoVY
	E8uKK3MPMUpwMCuJ8LIHAYV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwRorued711K0psbviyfWW
	ZSfWxJx48c7j9Od+V1fm5X2OPbxCzcyzhG4+SVt39cOEFUqJTr9X7lT9WJ3Nvvhvfoa4xi0Z
	/QnyJ86dulV0NrXvvsHvlpu3qw8tnqX0T+Hy6adLPvtHzoxdxu/Bq5i1Ia1L4pTGDTdrvbf2
	LbslE3d9jXXVm1h2UImlOCPRUIu5qDgRADC3uXC0AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 06:15 PM, Rafael J. Wysocki wrote:
> On Monday, June 17, 2013 01:36:35 PM Shuah Khan wrote:
>> Change __device_suspend() path to include driver name and the ops that
>> get run for a device. This additional information helps associate the
>> driver and the type of pm_ops the device uses in the suspend path very
>> quickly, which will aid in debugging problems in suspend and resume paths.
>> Changed both start and end debug messages to include pm_ops information
>> and use dev_info() instead of pr_info(). Changed the end message to include
>> parent device information and have the same format as the start message.
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
>> [  545.985394] usb 1-1: Start: type pm ops @ 68, parent: usb1
>> [  545.987650] usb 1-1: End  : type pm ops @ 68, parent: usb1 time(2184 usecs) err(0)
>>
>> [  545.982544] system 00:0a: Start: legacy bus pm ops @ 2391, parent: pnp0
>> [  545.982554] system 00:0a: End  : legacy bus pm ops @ 2391, parent: pnp0 time(4 usecs) err(0)
>>
>> [  545.982569] tpm_tis 00:09: Start: legacy bus pm ops @ 2391, parent: pnp0
>> [  546.087017] tpm_tis 00:09: End  : legacy bus pm ops @ 2391, parent: pnp0 time(101936 usecs) err(0)
>>
>> [  546.087069] rtc_cmos 00:05: Start: legacy bus pm ops @ 2391, parent: pnp0
>> [  546.087084] rtc_cmos 00:05: End  : legacy bus pm ops @ 2391, parent: pnp0 time(11 usecs) err(0)
>>
>
> I was about to apply your patch, but then I noticed something that might cause
> problems to happen.
>
> Namely, there are tools that use these messages to create suspend/resume time
> charts and they will stop working after the proposed changes.
>
> Please keep the existing formatting the way it is and only append the additional
> information at the end of each line.
>
> Thanks,
> Rafael
>

Hi Rafael,

Yes changing the format would cause problems for scripts that rely on 
the exact format. Would you like to pick the v2 version of the patch 
that appends the additional information at the end, instead of changing 
the format? Here is the link. If you would like me to resend it, I can 
do that.

https://lkml.org/lkml/2013/6/14/448

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
