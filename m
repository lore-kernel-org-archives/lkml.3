Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454Ab3DAXkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 19:40:32 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49682 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab3DAXk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 19:40:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>, linux-acpi@vger.kernel.org,
        tangchen@cn.fujitsu.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ACPI,acpi_memhotplug: Remove acpi_memory_info->failed bit
Date: Tue, 02 Apr 2013 01:48:02 +0200
Message-ID: <7171436.IWIKuTHVjL@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <5153878B.2050307@jp.fujitsu.com>
References: <514022BF.3080303@jp.fujitsu.com> <4310971.etCm8Nd6PX@vostro.rjw.lan> <5153878B.2050307@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 28, 2013 08:58:03 AM Yasuaki Ishimatsu wrote:
> Hi Rafael,
> 
> 2013/03/26 22:41, Rafael J. Wysocki wrote:
> > On Tuesday, March 26, 2013 08:57:05 AM Yasuaki Ishimatsu wrote:
> >> 2013/03/23 5:24, Toshi Kani wrote:
> >>> On Fri, 2013-03-22 at 10:53 +0900, Yasuaki Ishimatsu wrote:
> >>>> acpi_memory_info has enabled bit and failed bit for controlling memory
> >>>> hotplug. But we don't need to keep both bits.
> >>>>
> >>>> The patch removes acpi_memory_info->failed bit.
> >>>>
> >>>> Signed-off-by: yasuaki ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> >>>
> >>> Thanks for the update.  It looks good.  For the series:
> >>>
> >>> Acked-by: Toshi Kani <toshi.kani@hp.com>
> >>
> >> Thanks!
> >
> > Both patches applied to linux-pm.git/linux-next.
> 
> Thank you for applying both patches.
> If you don't mind, I hope these patches are merged into linux-3.9
> since this is bug fix.

I honestly don't think that [2/2] is 3.9 material, but I can push [1/2]
for 3.9 provided that you also regard it as material for 3.8-stable.

Thanks,
Rafael


> >>>> ---
> >>>>
> >>>> v3 : Continue to memory hot remove when (!info->enabled) case.
> >>>> v2 : Changed a based kernel from linux-3.9-rc2 to linux-pm.git/bleeding-edge.
> >>>>
> >>>> ---
> >>>>     drivers/acpi/acpi_memhotplug.c |   15 ++-------------
> >>>>     1 files changed, 2 insertions(+), 13 deletions(-)
> >>>>
> >>>> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> >>>> index ea78988..5e6301e 100644
> >>>> --- a/drivers/acpi/acpi_memhotplug.c
> >>>> +++ b/drivers/acpi/acpi_memhotplug.c
> >>>> @@ -73,7 +73,6 @@ struct acpi_memory_info {
> >>>>     	unsigned short caching;	/* memory cache attribute */
> >>>>     	unsigned short write_protect;	/* memory read/write attribute */
> >>>>     	unsigned int enabled:1;
> >>>> -	unsigned int failed:1;
> >>>>     };
> >>>>
> >>>>     struct acpi_memory_device {
> >>>> @@ -201,10 +200,8 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
> >>>>     		 * returns -EEXIST. If add_memory() returns the other error, it
> >>>>     		 * means that this memory block is not used by the kernel.
> >>>>     		 */
> >>>> -		if (result && result != -EEXIST) {
> >>>> -			info->failed = 1;
> >>>> +		if (result && result != -EEXIST)
> >>>>     			continue;
> >>>> -		}
> >>>>
> >>>>     		info->enabled = 1;
> >>>>
> >>>> @@ -238,16 +235,8 @@ static int acpi_memory_remove_memory(struct acpi_memory_device *mem_device)
> >>>>     	nid = acpi_get_node(mem_device->device->handle);
> >>>>
> >>>>     	list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
> >>>> -		if (info->failed)
> >>>> -			/* The kernel does not use this memory block */
> >>>> -			continue;
> >>>> -
> >>>>     		if (!info->enabled)
> >>>> -			/*
> >>>> -			 * The kernel uses this memory block, but it may be not
> >>>> -			 * managed by us.
> >>>> -			 */
> >>>> -			return -EBUSY;
> >>>> +			continue;
> >>>>
> >>>>     		if (nid < 0)
> >>>>     			nid = memory_add_physaddr_to_nid(info->start_addr);
> >>>>
> >>>
> >>>
> >>
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
