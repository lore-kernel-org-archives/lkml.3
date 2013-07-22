Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab3GVIha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:37:30 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:42968 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933Ab3GVIh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:37:26 -0400
Date: Mon, 22 Jul 2013 10:37:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, dave@sr71.net,
        kosaki.motohiro@gmail.com, isimatu.yasuaki@jp.fujitsu.com,
        tangchen@cn.fujitsu.com, vasilis.liaskovitis@profitbricks.com
Subject: Re: [PATCH v2] mm/hotplug, x86: Disable ARCH_MEMORY_PROBE by default
Message-ID: <20130722083721.GC25976@gmail.com>
References: <1374256068-26016-1-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374256068-26016-1-git-send-email-toshi.kani@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Toshi Kani <toshi.kani@hp.com> wrote:

> CONFIG_ARCH_MEMORY_PROBE enables /sys/devices/system/memory/probe
> interface, which allows a given memory address to be hot-added as
> follows. (See Documentation/memory-hotplug.txt for more detail.)
> 
> # echo start_address_of_new_memory > /sys/devices/system/memory/probe
> 
> This probe interface is required on powerpc. On x86, however, ACPI
> notifies a memory hotplug event to the kernel, which performs its
> hotplug operation as the result. Therefore, regular users do not need
> this interface on x86. This probe interface is also error-prone and
> misleading that the kernel blindly adds a given memory address without
> checking if the memory is present on the system; no probing is done
> despite of its name. The kernel crashes when a user requests to online
> a memory block that is not present on the system. This interface is
> currently used for testing as it can fake a hotplug event.
> 
> This patch disables CONFIG_ARCH_MEMORY_PROBE by default on x86, adds
> its Kconfig menu entry on x86, and clarifies its use in Documentation/
> memory-hotplug.txt.

Could we please also fix it to never crash the kernel, even if stupid 
ranges are provided?

Thanks,

	Ingo
