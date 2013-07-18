Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab3GRQ1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:27:47 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:36831 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315Ab3GRQ1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:27:46 -0400
Message-ID: <1374164815.24916.84.camel@misato.fc.hp.com>
Subject: Re: [PATCH] mm/hotplug, x86: Disable ARCH_MEMORY_PROBE by default
From: Toshi Kani <toshi.kani@hp.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, tangchen@cn.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Date: Thu, 18 Jul 2013 10:26:55 -0600
In-Reply-To: <51E80973.9000308@intel.com>
References: <1374097503-25515-1-git-send-email-toshi.kani@hp.com>
	 <51E80973.9000308@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-18 at 08:27 -0700, Dave Hansen wrote:
> On 07/17/2013 02:45 PM, Toshi Kani wrote:
> > +CONFIG_ARCH_MEMORY_PROBE is supported on powerpc only. On x86, this config
> > +option is disabled by default since ACPI notifies a memory hotplug event to
> > +the kernel, which performs its hotplug operation as the result. Please
> > +enable this option if you need the "probe" interface on x86.
> 
> There's no prompt for this and no way to override what you've done here
> without hacking Kconfig/.config files.
> 
> It's also completely wrong to say "CONFIG_ARCH_MEMORY_PROBE is supported
> on powerpc only."  It works just fine on x86.  In fact, I was just using
> it today without ACPI being around.

This statement has been there in the document (no change), and I
consider "supported" and "may work" are two different things.

> I'd really prefer you don't do this.  Do you really have random
> processes on your system poking at random sysfs files and then
> complaining when things break?

I am afraid that the "probe" interface does not provide the level of
quality suitable for regular users.  It takes any value and blindly
extends the page table.  Also, we are not aware of the use of this
interface on x86.  Would you elaborate why you need this interface on
x86?  Is it for your testing, or is it necessary for end-users?  If the
former, can you modify .config file to enable it?

Thanks,
-Toshi   



