Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbaHUMaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:30:12 -0400
Received: from service87.mimecast.com ([91.220.42.44]:52088 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbaHUMaK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:30:10 -0400
Message-ID: <53F5E652.6050408@arm.com>
Date: Thu, 21 Aug 2014 13:30:10 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>
CC: Sudeep Holla <sudeep.holla@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v3 03/11] drivers: base: add new class "cpu" to group
 cpu devices
References: <1406306692-7135-1-git-send-email-sudeep.holla@arm.com>	<1408618794-28497-1-git-send-email-sudeep.holla@arm.com>	<1408618794-28497-4-git-send-email-sudeep.holla@arm.com> <CANq1E4Q4GRYUxrysUyTD5bO3di9M17i0H5V0fXb5+HrTrYY5aQ@mail.gmail.com>
In-Reply-To: <CANq1E4Q4GRYUxrysUyTD5bO3di9M17i0H5V0fXb5+HrTrYY5aQ@mail.gmail.com>
X-OriginalArrivalTime: 21 Aug 2014 12:30:04.0204 (UTC) FILETIME=[A2614EC0:01CFBD3B]
X-MC-Unique: 114082113300501701
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21/08/14 12:20, David Herrmann wrote:
> Hi
>
> On Thu, Aug 21, 2014 at 12:59 PM, Sudeep Holla <sudeep.holla@arm.com> wrote:
>> From: Sudeep Holla <sudeep.holla@arm.com>
>>
>> This patch creates a new class called "cpu" and assigns it to all the
>> cpu devices. This helps in grouping all the cpu devices and associated
>> child devices under the same class.
>>
>> This patch also:
>> 1. modifies the get_parent_device to return the legacy path
>>     (/sys/devices/system/cpu/..) for the cpu class devices to support
>>     existing sysfs ABI
>> 2. avoids creating link in the class directory pointing to the device as
>>     there would be per-cpu instance of these devices with the same name
>> 3. makes sure subsystem symlink continues pointing to cpu bus instead of
>>     cpu class for cpu devices
>
> This patch lacks any explanation _why_ you add a class for CPUs. With
> this patch applied, these directories are effectively the same:
>    /sys/bus/cpu/devices/
>    /sys/class/cpu/
>

Yes that's the intention, so that we don't break any existing sysfs/ABI

> Why do we need a cpu-class if the same set of information is already
> available on the cpu-bus? Furthermore, classes are deprecated anyway.
> Everything you can do with a class can be solved with a bus. And we
> already have a bus for cpus.
>

This was suggested[1] by GregKH. The main reason it was added is to
reuse the device attributes rather than creating the raw kobjects.

It helps to move few other cpu related subsystems using raw kobjects to
the device attribute groups.

Regards,
Sudeep

[1] https://lkml.org/lkml/2014/2/10/766

