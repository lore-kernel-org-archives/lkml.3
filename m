Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaG1Nhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:37:38 -0400
Received: from service87.mimecast.com ([91.220.42.44]:57226 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbaG1Nhb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:37:31 -0400
Message-ID: <53D65236.7080606@arm.com>
Date: Mon, 28 Jul 2014 14:37:58 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Sudeep Holla <sudeep.holla@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 1/9] drivers: base: add new class "cpu" to group cpu
 devices
References: <1403717444-23559-1-git-send-email-sudeep.holla@arm.com> <1406306692-7135-1-git-send-email-sudeep.holla@arm.com> <1406306692-7135-2-git-send-email-sudeep.holla@arm.com> <53D2AB54.5030809@codeaurora.org>
In-Reply-To: <53D2AB54.5030809@codeaurora.org>
X-OriginalArrivalTime: 28 Jul 2014 13:37:27.0630 (UTC) FILETIME=[128926E0:01CFAA69]
X-MC-Unique: 114072814372803301
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 25/07/14 20:09, Stephen Boyd wrote:
> On 07/25/14 09:44, Sudeep Holla wrote:
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
>>
>> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> Why can't we make a 'cache' bus that the cache devices hang off of? It
> doesn't make sense to me why we would want to have cache devices living
> on the cpu bus.
>

Yes we can group them under cache, but to support legacy sysfs path
under which various cpu related information including caches, we need
to have a workaround as in this patch.

Instead of having this fixup for each class like cache, having them
grouped under cpu is better IMO and hence I added caches to cpu class.
It also helps to move few other cpu related subsystems using raw
kobjects to the device attribute groups and corresponding APIs.

Regards,
Sudeep

