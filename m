Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab3JBNaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 09:30:17 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53316 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab3JBNaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 09:30:14 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <524C1FE1.4050207@roeck-us.net>
Date: Wed, 02 Oct 2013 06:30:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Chris Murphy <bugzilla@colorremedies.com>,
        Josh Boyer <jwboyer@fedoraproject.org>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: applesmc oops in 3.10/3.11
References: <20130927175926.GA6267@roeck-us.net> <B6E9FB4C-665C-454E-9DEB-B95B85C1D0E0@colorremedies.com> <524615B1.6000106@roeck-us.net> <4FFB3671-DDB4-40F7-BA5D-C9AA9391BDA9@colorremedies.com> <524A4384.4040403@roeck-us.net> <20131002035156.GA566@roeck-us.net> <20131002095339.GA2716@polaris.bitmath.org>
In-Reply-To: <20131002095339.GA2716@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 02:53 AM, Henrik Rydberg wrote:
>>> Patch added on top of 3.12.0-0.rc3.git0.1.fc20.x86_64 and built. But after ~dozen reboots, I'm not triggering the problem. The only items in dmesg with smc in it:
>>>
>>> [   13.799819] applesmc: key=261 fan=2 temp=14 index=14 acc=1 lux=2 kbd=1
>>> [   13.833402] input: applesmc as /devices/platform/applesmc.768/input/input10
>>>
>>
>> One thing I have seen in all logs is the earlier "send_byte fail" message, so
>> I think that is a pre-requisite.
>
> Not necessarily - it could be that the patch actually fixes the root
> cause. One possible scenario is that on recent SMCs, some of the
> commands produce more data than we actually read. This would
> eventually lead to both data corruption and overflow somwhere in the
> SMC internals.  If the original SMC error is interpreted as a read
> buffer overflow, then that problem should be fixed with this patch.
>

Good point.

But shouldn't we at least get the "flushed %d bytes" warning message in this case ?

Thanks,
Guenter

