Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab3HQARw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:17:52 -0400
Received: from mail-gh0-f177.google.com ([209.85.160.177]:49781 "EHLO
	mail-gh0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096Ab3HQARt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 20:17:49 -0400
X-Greylist: delayed 7620 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Aug 2013 20:17:49 EDT
Message-ID: <520E8C13.5020406@gmail.com>
Date: Fri, 16 Aug 2013 16:31:15 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl,
        kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
        tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        liwanp@linux.vnet.ibm.com
Subject: Re: [PATCH] mm/hotplug: Remove stop_machine() from try_offline_node()
References: <1376336071-9128-1-git-send-email-toshi.kani@hp.com>  <520C2D04.8060408@gmail.com> <1376584540.10300.416.camel@misato.fc.hp.com>
In-Reply-To: <1376584540.10300.416.camel@misato.fc.hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> This patch removes the use of stop_machine() in try_offline_node() and
>>> adds comments to try_offline_node() and remove_memory() that
>>> lock_device_hotplug() is required.
>>
>> This patch need more verbose explanation. check_cpu_on_node() traverse cpus
>> and cpu hotplug seems to use cpu_hotplug_driver_lock() instead of lock_device_hotplug().
>
> As described:
>
> | lock_device_hotplug() serializes hotplug & online/offline operations.
> | The lock is held in common sysfs online/offline interfaces and ACPI
> | hotplug code paths.
>
> And here are their code paths.
>
> - CPU & Mem online/offline via sysfs online
> 	store_online()->lock_device_hotplug()
>
> - Mem online via sysfs state:
> 	store_mem_state()->lock_device_hotplug()
>
> - ACPI CPU & Mem hot-add:
> 	acpi_scan_bus_device_check()->lock_device_hotplug()
>
> - ACPI CPU & Mem hot-delete:
> 	acpi_scan_hot_remove()->lock_device_hotplug()

O.K.


