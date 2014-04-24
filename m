Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbaDXMtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:49:15 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:47789 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbaDXMtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:49:12 -0400
Message-ID: <53590845.1090405@linaro.org>
Date: Thu, 24 Apr 2014 13:49:09 +0100
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: stefano.stabellini@eu.citrix.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        ian.campbell@citrix.com, konrad.wilk@oracle.com
Subject: Re: [PATCH] arm/xen: Remove definiition of virt_to_pfn in asm/xen/page.h
References: <1397836474-10478-1-git-send-email-julien.grall@linaro.org> <535901F0.3010908@citrix.com>
In-Reply-To: <535901F0.3010908@citrix.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 04/24/2014 01:22 PM, David Vrabel wrote:
> On 18/04/14 16:54, Julien Grall wrote:
>> virt_to_pfn has been defined in asm/memory.h by the commit e26a9e0 "ARM: Better
>> virt_to_page() handling"
>>
>> This will result of a compilation warning when CONFIG_XEN is enabled.
>>
>> arch/arm/include/asm/xen/page.h:80:0: warning: "virt_to_pfn" redefined [enabled by default]
>>  #define virt_to_pfn(v)          (PFN_DOWN(__pa(v)))
>>  ^
>> In file included from arch/arm/include/asm/page.h:163:0,
>>                  from arch/arm/include/asm/xen/page.h:4,
>>                  from include/xen/page.h:4,
>>                  from arch/arm/xen/grant-table.c:33:
>>
>> The definition in memory.h is nearly the same (it directly expand PFN_DOWN),
>> so we can safely drop virt_to_pfn in xen include.
> 
> 
> This breaks the arm build for me.
> 
> /local/davidvr/work/k.org/tip/drivers/block/xen-blkfront.c: In function
> ‘setup_blkring’:
> /local/davidvr/work/k.org/tip/drivers/block/xen-blkfront.c:1236:2:
> error: implicit declaration of function ‘virt_to_pfn’
> [-Werror=implicit-function-declaration]
>   err = xenbus_grant_ring(dev, virt_to_mfn(info->ring.sring));
>   ^

I don't have any issue to build the following branch with this patch on:
	- v3.15-rc2
	- xentip master
	- xentip for-linus-3.16

Regards,

-- 
Julien Grall
