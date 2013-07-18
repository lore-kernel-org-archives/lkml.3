Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab3GRP21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:28:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:19818 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756756Ab3GRP2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:28:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,694,1367996400"; 
   d="scan'208";a="270140454"
Message-ID: <51E80973.9000308@intel.com>
Date: Thu, 18 Jul 2013 08:27:47 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, tangchen@cn.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Subject: Re: [PATCH] mm/hotplug, x86: Disable ARCH_MEMORY_PROBE by default
References: <1374097503-25515-1-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1374097503-25515-1-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 02:45 PM, Toshi Kani wrote:
> +CONFIG_ARCH_MEMORY_PROBE is supported on powerpc only. On x86, this config
> +option is disabled by default since ACPI notifies a memory hotplug event to
> +the kernel, which performs its hotplug operation as the result. Please
> +enable this option if you need the "probe" interface on x86.

There's no prompt for this and no way to override what you've done here
without hacking Kconfig/.config files.

It's also completely wrong to say "CONFIG_ARCH_MEMORY_PROBE is supported
on powerpc only."  It works just fine on x86.  In fact, I was just using
it today without ACPI being around.

I'd really prefer you don't do this.  Do you really have random
processes on your system poking at random sysfs files and then
complaining when things break?
