Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaIIIB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:01:29 -0400
Received: from smtprelay03.ispgateway.de ([80.67.31.37]:59528 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaIIIB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:01:28 -0400
Message-ID: <540EB3CE.6010700@ladisch.de>
Date: Tue, 09 Sep 2014 10:01:18 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Subhransu S. Prusty" <subhransu.s.prusty@intel.com>
CC: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, vinod.koul@intel.com
Subject: Re: [PATCH] x86_64: Add memcpy32_toio to write to PCI MMIO
References: <1410164046-15577-1-git-send-email-subhransu.s.prusty@intel.com>
In-Reply-To: <1410164046-15577-1-git-send-email-subhransu.s.prusty@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subhransu S. Prusty wrote:
> This is needed because the hardware

Which hardware?  Every x86-64 CPU ever built by AMD, Intel, and VIA?

> does not support 64-bit moveq insructions while writing to PCI MMIO.

> +#ifndef CONFIG_X86_64
> +#define MEMCPY_TOIO memcpy_toio
> +#else
> +#define MEMCPY_TOIO memcpy32_toio
> +#endif

This does not change any code that uses memcpy_toio().

> +	for (i = 0; i < count/sizeof(u32); i++)
> +		writel(*src_32++, dst_32++);

This breaks when count is not a multiple of four.


Regards,
Clemens
