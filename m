Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbaHVJNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 05:13:04 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:61220 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbaHVJNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:13:00 -0400
MIME-Version: 1.0
In-Reply-To: <53F5E652.6050408@arm.com>
References: <1406306692-7135-1-git-send-email-sudeep.holla@arm.com>
 <1408618794-28497-1-git-send-email-sudeep.holla@arm.com> <1408618794-28497-4-git-send-email-sudeep.holla@arm.com>
 <CANq1E4Q4GRYUxrysUyTD5bO3di9M17i0H5V0fXb5+HrTrYY5aQ@mail.gmail.com> <53F5E652.6050408@arm.com>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 22 Aug 2014 11:12:39 +0200
Message-ID: <CAPXgP130hg8uwdmSKAAAKZzxncT-VXYYXvmN-ta7wcXQXgXEmw@mail.gmail.com>
Subject: Re: [PATCH v3 03/11] drivers: base: add new class "cpu" to group cpu devices
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: David Herrmann <dh.herrmann@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 2:30 PM, Sudeep Holla <sudeep.holla@arm.com> wrote:
> On 21/08/14 12:20, David Herrmann wrote:
>> On Thu, Aug 21, 2014 at 12:59 PM, Sudeep Holla <sudeep.holla@arm.com>
>> wrote:
>>>
>>> From: Sudeep Holla <sudeep.holla@arm.com>
>>>
>>> This patch creates a new class called "cpu" and assigns it to all the
>>> cpu devices. This helps in grouping all the cpu devices and associated
>>> child devices under the same class.
>>>
>>> This patch also:
>>> 1. modifies the get_parent_device to return the legacy path
>>>     (/sys/devices/system/cpu/..) for the cpu class devices to support
>>>     existing sysfs ABI
>>> 2. avoids creating link in the class directory pointing to the device as
>>>     there would be per-cpu instance of these devices with the same name
>>> 3. makes sure subsystem symlink continues pointing to cpu bus instead of
>>>     cpu class for cpu devices
>>
>>
>> This patch lacks any explanation _why_ you add a class for CPUs. With
>> this patch applied, these directories are effectively the same:
>>    /sys/bus/cpu/devices/
>>    /sys/class/cpu/
>>
>
> Yes that's the intention, so that we don't break any existing sysfs/ABI
>
>
>> Why do we need a cpu-class if the same set of information is already
>> available on the cpu-bus? Furthermore, classes are deprecated anyway.
>> Everything you can do with a class can be solved with a bus. And we
>> already have a bus for cpus.
>>
>
> This was suggested[1] by GregKH. The main reason it was added is to
> reuse the device attributes rather than creating the raw kobjects.
>
> It helps to move few other cpu related subsystems using raw kobjects to
> the device attribute groups.

No, nothing should ever create a bus and a class with the same name.
This is not supported by userspace tools.

Your problem needs to be addressed by adding things to the existing
"cpu" bus, not by adding a new class.

Kay
