Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaHIX1O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 19:27:14 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53385 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaHIX1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 19:27:13 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E6AE48.4010609@roeck-us.net>
Date: Sat, 09 Aug 2014 16:27:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] vfio: Fix build failure seen if vfio is built as module
 and EEH is enabled
References: <1407603887-1419-1-git-send-email-linux@roeck-us.net>	 <1407612480.9800.1.camel@ul30vt.home> <53E6A078.6040907@roeck-us.net> <1407626290.9800.3.camel@ul30vt.home>
In-Reply-To: <1407626290.9800.3.camel@ul30vt.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2014 04:18 PM, Alex Williamson wrote:
> On Sat, 2014-08-09 at 15:28 -0700, Guenter Roeck wrote:
>> On 08/09/2014 12:28 PM, Alex Williamson wrote:
>>> On Sat, 2014-08-09 at 10:04 -0700, Guenter Roeck wrote:
>>>> The following build failure is seen with ppc:allmodconfig.
>>>>
>>>> ERROR: ".vfio_spapr_iommu_eeh_ioctl" [drivers/vfio/vfio_iommu_spapr_tce.ko] undefined!
>>>> ERROR: ".vfio_spapr_pci_eeh_open" [drivers/vfio/pci/vfio-pci.ko] undefined!
>>>> ERROR: ".vfio_spapr_pci_eeh_release" [drivers/vfio/pci/vfio-pci.ko] undefined!
>>>>
>>>> Simply exporting the missing symbols is insufficient, since drivers/vfio
>>>> can be built as module but drivers/vfio/vfio_spapr_eeh.c depends on
>>>> EEH which is boolean. The combination of obj-m for drivers/vfio and obj-y
>>>> for drivers/vfio/vfio_spapr_eeh.o results in the symbols being missed even
>>>> if exported.
>>>>
>>>> Export missing symbols and introduce new tristate configuration option
>>>> VFIO_EEH depending on both EEH and VFIO to fix the problem.
>>>>
>>>> Cc: Gavin Shan <gwshan@linux.vnet.ibm.com>
>>>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>>
>>> Please try:
>>>
>>> git://github.com/awilliam/linux-vfio.git next
>>>
>>> This will be part of the next linux-next build, should resolve the
>>> problem, and I plan to ask for a pull early this coming week.  Thanks,
>>>
>>
>> That should do for the most part, but it will select VFIO_SPAPR_EEH
>> even if EEH is not configured. You would need something like
>> 	select VFIO_SPAPR_EEH if (PPC_POWERNV || PPC_PSERIES) && EEH
>> to prevent that.
>
> Feel free to post a patch against this branch.  Thanks,
>

I'll wait for -next to see if there are any problems in practice.

Guenter

