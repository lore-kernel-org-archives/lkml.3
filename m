Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab3CUEpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 00:45:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37165 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab3CUEpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 00:45:06 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <514A903A.9000909@jp.fujitsu.com>
Date: Thu, 21 Mar 2013 13:44:42 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>, <rjw@sisk.pl>
CC: <linux-acpi@vger.kernel.org>, <tangchen@cn.fujitsu.com>,
        <wency@cn.fujitsu.com>, <laijs@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Bug fix PATCH v2 1/2] ACPI,acpi_memhotplug: enable acpi_memory_info->enabled
 of memory device presented at boot-time
References: <514022BF.3080303@jp.fujitsu.com>  <1363186213.12845.174.camel@misato.fc.hp.com>  <514679BC.5020700@jp.fujitsu.com> <1363705437.11659.5.camel@misato.fc.hp.com> <514A4CCD.6000608@jp.fujitsu.com> <514A8E3C.1050902@jp.fujitsu.com>
In-Reply-To: <514A8E3C.1050902@jp.fujitsu.com>
Content-Type: multipart/mixed;
	boundary="------------020708080105030706050207"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------020708080105030706050207
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit

The mail's tab become spaces. So I attached origianl patch.

Thanks,
Yasuaki Ishimatsu

2013/03/21 13:36, Yasuaki Ishimatsu wrote:
> At http://marc.info/?l=linux-acpi&m=135769405622667&w=2 thread,
> Toshi Kani mentioned as follows:
>
> "I have a question about the change you made in commit 65479472 in
> acpi_memhotplug.c.  This change seems to require that
> acpi_memory_enable_device() calls add_memory() to add all memory ranges
> represented by memory device objects at boot-time, and keep the results
> be used for hot-remove.
>
> If I understand it right, this add_memory() call fails with EEXIST at
> boot-time since all memory ranges should have been added from EFI memory
> table (or e820) already.  This results all memory ranges be marked as !
> enabled & !failed.  I think this means that we cannot hot-delete any
> memory ranges presented at boot-time since acpi_memory_remove_memory()
> only calls remove_memory() when the enabled flag is set.  Is that
> correct?"
>
> Above mention is correct. Thus even if memory device supports hotplug,
> memory presented at boot-time cannot be hot removed since the memory
> device's acpi_memory_info->enabled is always 0.
>
> This patch changes to set 1 to "acpi_memory_info->enabled" of memory
> device presented at boot-time for hot removing the memory device.
>
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> ---
>
> v2 : Changed a based kernel from linux-3.9-rc2 to linux-pm.git/bleeding-edge.
>
> ---
>   drivers/acpi/acpi_memhotplug.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index d4f2eb8..ea78988 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -206,8 +206,8 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
>               continue;
>           }
>
> -        if (!result)
> -            info->enabled = 1;
> +        info->enabled = 1;
> +
>           /*
>            * Add num_enable even if add_memory() returns -EEXIST, so the
>            * device is bound to this driver.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--------------020708080105030706050207
Content-Type: text/x-patch;
	name="0001-ACPI-acpi_memhotplug-enable-acpi_memory_info-enabled.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-ACPI-acpi_memhotplug-enable-acpi_memory_info-enabled.pa";
	filename*1="tch"

At http://marc.info/?l=linux-acpi&m=135769405622667&w=2 thread,
Toshi Kani mentioned as follows:

"I have a question about the change you made in commit 65479472 in
acpi_memhotplug.c.  This change seems to require that
acpi_memory_enable_device() calls add_memory() to add all memory ranges
represented by memory device objects at boot-time, and keep the results
be used for hot-remove.

If I understand it right, this add_memory() call fails with EEXIST at
boot-time since all memory ranges should have been added from EFI memory
table (or e820) already.  This results all memory ranges be marked as !
enabled & !failed.  I think this means that we cannot hot-delete any
memory ranges presented at boot-time since acpi_memory_remove_memory()
only calls remove_memory() when the enabled flag is set.  Is that
correct?"

Above mention is correct. Thus even if memory device supports hotplug,
memory presented at boot-time cannot be hot removed since the memory
device's acpi_memory_info->enabled is always 0.

This patch changes to set 1 to "acpi_memory_info->enabled" of memory
device presented at boot-time for hot removing the memory device.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---

v2 : Changed a based kernel from linux-3.9-rc2 to linux-pm.git/bleeding-edge.

---
 drivers/acpi/acpi_memhotplug.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index d4f2eb8..ea78988 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -206,8 +206,8 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
 			continue;
 		}
 
-		if (!result)
-			info->enabled = 1;
+		info->enabled = 1;
+
 		/*
 		 * Add num_enable even if add_memory() returns -EEXIST, so the
 		 * device is bound to this driver.
-- 
1.7.1


--------------020708080105030706050207--
