Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaDXMWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:22:13 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:57683 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbaDXMWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:22:11 -0400
X-IronPort-AV: E=Sophos;i="4.97,918,1389744000"; 
   d="scan'208";a="123077875"
Message-ID: <535901F0.3010908@citrix.com>
Date: Thu, 24 Apr 2014 13:22:08 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Julien Grall <julien.grall@linaro.org>
CC: <stefano.stabellini@eu.citrix.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <ian.campbell@citrix.com>, <konrad.wilk@oracle.com>
Subject: Re: [PATCH] arm/xen: Remove definiition of virt_to_pfn in asm/xen/page.h
References: <1397836474-10478-1-git-send-email-julien.grall@linaro.org>
In-Reply-To: <1397836474-10478-1-git-send-email-julien.grall@linaro.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/04/14 16:54, Julien Grall wrote:
> virt_to_pfn has been defined in asm/memory.h by the commit e26a9e0 "ARM: Better
> virt_to_page() handling"
> 
> This will result of a compilation warning when CONFIG_XEN is enabled.
> 
> arch/arm/include/asm/xen/page.h:80:0: warning: "virt_to_pfn" redefined [enabled by default]
>  #define virt_to_pfn(v)          (PFN_DOWN(__pa(v)))
>  ^
> In file included from arch/arm/include/asm/page.h:163:0,
>                  from arch/arm/include/asm/xen/page.h:4,
>                  from include/xen/page.h:4,
>                  from arch/arm/xen/grant-table.c:33:
> 
> The definition in memory.h is nearly the same (it directly expand PFN_DOWN),
> so we can safely drop virt_to_pfn in xen include.


This breaks the arm build for me.

/local/davidvr/work/k.org/tip/drivers/block/xen-blkfront.c: In function
‘setup_blkring’:
/local/davidvr/work/k.org/tip/drivers/block/xen-blkfront.c:1236:2:
error: implicit declaration of function ‘virt_to_pfn’
[-Werror=implicit-function-declaration]
  err = xenbus_grant_ring(dev, virt_to_mfn(info->ring.sring));
  ^

David
