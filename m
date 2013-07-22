Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab3GVRM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 13:12:57 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:12464 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab3GVRM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 13:12:56 -0400
Message-ID: <1374513120.16322.21.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2] mm/hotplug, x86: Disable ARCH_MEMORY_PROBE by default
From: Toshi Kani <toshi.kani@hp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, dave@sr71.net,
        kosaki.motohiro@gmail.com, isimatu.yasuaki@jp.fujitsu.com,
        tangchen@cn.fujitsu.com, vasilis.liaskovitis@profitbricks.com
Date: Mon, 22 Jul 2013 11:12:00 -0600
In-Reply-To: <20130722083721.GC25976@gmail.com>
References: <1374256068-26016-1-git-send-email-toshi.kani@hp.com>
	 <20130722083721.GC25976@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 10:37 +0200, Ingo Molnar wrote:
> * Toshi Kani <toshi.kani@hp.com> wrote:
> 
> > CONFIG_ARCH_MEMORY_PROBE enables /sys/devices/system/memory/probe
> > interface, which allows a given memory address to be hot-added as
> > follows. (See Documentation/memory-hotplug.txt for more detail.)
> > 
> > # echo start_address_of_new_memory > /sys/devices/system/memory/probe
> > 
> > This probe interface is required on powerpc. On x86, however, ACPI
> > notifies a memory hotplug event to the kernel, which performs its
> > hotplug operation as the result. Therefore, regular users do not need
> > this interface on x86. This probe interface is also error-prone and
> > misleading that the kernel blindly adds a given memory address without
> > checking if the memory is present on the system; no probing is done
> > despite of its name. The kernel crashes when a user requests to online
> > a memory block that is not present on the system. This interface is
> > currently used for testing as it can fake a hotplug event.
> > 
> > This patch disables CONFIG_ARCH_MEMORY_PROBE by default on x86, adds
> > its Kconfig menu entry on x86, and clarifies its use in Documentation/
> > memory-hotplug.txt.
> 
> Could we please also fix it to never crash the kernel, even if stupid 
> ranges are provided?

Yes, this probe interface can be enhanced to verify the firmware
information before adding a given memory address.  However, such change
would interfere its test use of "fake" hotplug, which is only the known
use-case of this interface on x86.

In order to verify if a given memory address is enabled at run-time (as
opposed to boot-time), we need to check with ACPI memory device objects
on x86.  However, system vendors tend to not implement memory device
objects unless their systems support memory hotplug.  Dave Hansen is
using this interface for his testing as a way to fake a hotplug event on
a system that does not support memory hotplug.

Thanks,
-Toshi



  


