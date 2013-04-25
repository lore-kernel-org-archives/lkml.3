Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704Ab3DYVX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 17:23:58 -0400
Received: from relay2.sgi.com ([192.48.179.30]:36667 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759660Ab3DYVXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 17:23:45 -0400
Date: Thu, 25 Apr 2013 16:23:43 -0500
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russ Anderson <rja@sgi.com>, Robin Holt <holt@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH -v6 0/5] Shutdown from reboot_cpuid without stopping
 other cpus.
Message-ID: <20130425212343.GZ3658@sgi.com>
References: <1366802333-8890-1-git-send-email-holt@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366802333-8890-1-git-send-email-holt@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Please go ahead and kill this patch set.  It breaks with !CONFIG_SMP
and breaks on arm.  I spent time today getting an arm cross compiler
working and fixing up the build.  It indicates there is more work to
be done beyond your comments for the reboot_mode parameter.  I should
have a newer patch set tomorrow, but it will need to go through arm and
unicore32 reviews as it will affect both of them as well.

Robin

On Wed, Apr 24, 2013 at 06:18:48AM -0500, Robin Holt wrote:
> We recently noticed that reboot of a 1024 cpu machine takes approx 16
> minutes of just stopping the cpus.  The slowdown was tracked to commit
> f96972f.
> 
> The current implementation does all the work of hot removing the cpus
> before halting the system.  We are switching to just migrating to the
> reboot_cpu and then continuing with shutdown/reboot.
> 
> The patch set is broken into five parts.  The first two are planned for
> the stable release.  The others move the halt/shutdown/reboot related
> functions to their own kernel/reboot.c file and then introduce the kernel
> boot parameter.
> 
> 
> Changes since -v5.
>  - Moved the arch/x86 reboot= up to the generic kernel code.
> 
> Changes since -v4.
>  - Integrated Srivatsa S. Bhat creating cpu_hotplug_disable()
>    function
> 
>  - Integrated comments by Srivatsa S. Bhat.
> 
>  - Made one more comment consistent with others in function.
> 
> Changes since -v3.
>  - Added a tested-by for the original reporter.
> 
>  - Fix compile failure found by Joe Perches.
> 
>  - Integrated comments by Joe Perches.
