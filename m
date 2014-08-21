Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384AbaHUOx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:53:58 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47587 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbaHUOx4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:53:56 -0400
Message-ID: <53F60808.10707@arm.com>
Date: Thu, 21 Aug 2014 15:54:00 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v3 03/11] drivers: base: add new class "cpu" to group
 cpu devices
References: <1406306692-7135-1-git-send-email-sudeep.holla@arm.com>	<1408618794-28497-1-git-send-email-sudeep.holla@arm.com>	<1408618794-28497-4-git-send-email-sudeep.holla@arm.com>	<CANq1E4Q4GRYUxrysUyTD5bO3di9M17i0H5V0fXb5+HrTrYY5aQ@mail.gmail.com>	<53F5E652.6050408@arm.com> <CANq1E4S-PJvJeORnf-GZxHQZxPLOZ-R+hv9mu0w2g2O6zdfuVw@mail.gmail.com>
In-Reply-To: <CANq1E4S-PJvJeORnf-GZxHQZxPLOZ-R+hv9mu0w2g2O6zdfuVw@mail.gmail.com>
X-OriginalArrivalTime: 21 Aug 2014 14:53:53.0493 (UTC) FILETIME=[B9D65050:01CFBD4F]
X-MC-Unique: 114082115535416701
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21/08/14 13:37, David Herrmann wrote:
> Hi
>
> On Thu, Aug 21, 2014 at 2:30 PM, Sudeep Holla <sudeep.holla@arm.com> wrote:
>> On 21/08/14 12:20, David Herrmann wrote:
>>> Why do we need a cpu-class if the same set of information is already
>>> available on the cpu-bus? Furthermore, classes are deprecated anyway.
>>> Everything you can do with a class can be solved with a bus. And we
>>> already have a bus for cpus.
>>>

Sorry I wasn't aware that classes are deprecated. IIUC its class_device
struct and related APIs that are deprecated not struct class. I may be
wrong but Greg would not have suggested to use class if it was deprecated.

>>
>> This was suggested[1] by GregKH. The main reason it was added is to
>> reuse the device attributes rather than creating the raw kobjects.
>>
>> It helps to move few other cpu related subsystems using raw kobjects to
>> the device attribute groups.
>
> So the only reason to add a class is to get attributes registered
> properly with the device? Just set dev->groups before calling
> device_add()? This works just fine on buses, too.
>

Do you mean to say create bus for each cpu and add cpu devices like
cache under that ? We can't reuse the cpu bus i.e cpu_subsys as we can't
add per-cpu devices with same name under /sys/bus/cpu/devices/

Also adding bus for each cpu device might be more complex than creating
cpu class.

That's the reason why I added checks to avoid creating link in the class
directory pointing to the device. It would be difficult to do
that with bus as it can't be unconditional.

Regards,
Sudeep


