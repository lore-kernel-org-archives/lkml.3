Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3KVEhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 23:37:16 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:64613 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab3KVEhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 23:37:13 -0500
MIME-Version: 1.0
In-Reply-To: <CADTPrLS9iyvDkTLV5YyzJCiuGT2G0kTSbea8ZXzzT=E9RP71-Q@mail.gmail.com>
References: <528BE8B6.9080007@gmail.com> <CADTPrLS9iyvDkTLV5YyzJCiuGT2G0kTSbea8ZXzzT=E9RP71-Q@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 21 Nov 2013 21:36:51 -0700
Message-ID: <CAErSpo64MDU2VTqgahoPecfzCjv1rK=sACDDdK8UMxgsqToDDQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] Allow Link state changes for Hot-Plug
To: Rajat Jain <rajatjain.linux@gmail.com>
Cc: Linux-PCI <linux-pci@vger.kernel.org>,
        Linux-hotplug <linux-hotplug@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Paul Bolle <pebolle@tiscali.nl>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I haven't had a chance yet, sorry.

On Thu, Nov 21, 2013 at 6:16 AM, Rajat Jain <rajatjain.linux@gmail.com> wrote:
> Hello Bjorn / Folks,
>
> Was wondering if you got a chance to look at this patchset?
>
> Thanks & Best Regards,
>
> Rajat Jain
>
> On Tue, Nov 19, 2013 at 2:39 PM, Rajat Jain <rajatjain.linux@gmail.com> wrote:
>>
>> Hello,
>>
>> This patch set enables the use of PCI Express link up and link down events
>> for Hotplug or Unplug. The requirement of such a feature was originally
>> discussed here:
>>
>> http://www.spinics.net/lists/linux-pci/msg05783.html
>> http://www.spinics.net/lists/hotplug/msg05801.html
>>
>> Patch [1/4]: makes a function non-static for use by patch 2.
>> Patch [2/4]: Contains the bulk logic to allow link events to be used
>>              for hotplug and removal.
>> Patch [3/4]: Makes the pciehp_power_thread() lock free by making it
>>              look at a work info->req instead of slot->state.
>> Patch [4/4]: Introduce slot->hotplug_lock to serialize the hotplug
>>              operations.
>>
>> I'd appreciate if you could please review and provide me with any comments.
>>
>> Thanks,
>>
>> Rajat
>>
>> Rajat Jain (4):
>>   pciehp: Make check_link_active() non-static
>>   pciehp: Use link state change notifications for hot-plug and removal
>>   pciehp: Ensure all hotplug events are processed, even very fast ones.
>>   pciehp: Introduce hotplug_lock to serialize HP events on each slot
>>
>>  drivers/pci/hotplug/pciehp.h      |    6 ++
>>  drivers/pci/hotplug/pciehp_core.c |   10 +-
>>  drivers/pci/hotplug/pciehp_ctrl.c |  181 ++++++++++++++++++++++++++++++++++---
>>  drivers/pci/hotplug/pciehp_hpc.c  |   63 +++++++++----
>>  4 files changed, 229 insertions(+), 31 deletions(-)
>>
>> --
>> 1.7.9.5
>>
