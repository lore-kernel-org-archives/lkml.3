Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468Ab3HOStt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 14:49:49 -0400
Received: from smtp2.Stanford.EDU ([171.67.219.82]:43336 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753467Ab3HOStr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 14:49:47 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Aug 2013 14:49:47 EDT
Message-ID: <520D212F.7030400@localhost>
Date: Thu, 15 Aug 2013 11:42:55 -0700
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.10.6-rt3
References: <20130812163413.GI23040@linutronix.de>
In-Reply-To: <20130812163413.GI23040@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 09:34 AM, Sebastian Andrzej Siewior wrote:
> Dear RT folks!
>
> I'm pleased to announce the v3.10.6-rt3 patch set.

I'm getting this when trying to build:

drivers/md/bcache/request.c: In function 'cached_dev_write_complete':
drivers/md/bcache/request.c:1008:2: error: implicit declaration of 
function 'up_read_non_owner' [-Werror=implicit-function-declaration]
   up_read_non_owner(&dc->writeback_lock);
   ^
drivers/md/bcache/request.c: In function 'request_write':
drivers/md/bcache/request.c:1034:2: error: implicit declaration of 
function 'down_read_non_owner' [-Werror=implicit-function-declaration]
   down_read_non_owner(&dc->writeback_lock);
   ^
cc1: some warnings being treated as errors

Does not look like *_read_non_owner exist in rwsem_rt.h...
-- Fernando


> Changes since v3.10.6-rt2
> - the queue can be imported with git quiltimport
> - powerpc compiles again. Thanks to Paul Gortmaker for the patch.
> - added three patches from v3.8 which fall the wagon on their way to
>    3.10. One of them enables RT-FULL on ARM :)
> - removed all cpsw patches from the queue. They made it upstream. My
>    nfsboot setup seems not to work, lets look at this later.
> - make arm/spear compile. Thanks to Felipe Balbi for the patch.
> - Add a patch from Corey Minyard to no longer use deprecated
>    CONFIG_NO_HZ.
> - add the one patch which I added to the last 3.8-rt to get get list_bl
>    work again on !SMP && !DEBUG_SPINLOCK
> - Spell "preemptible" properly in "Preemptible Kernel (Basic RT)" menu
>    item. Thanks to Uwe Kleine-König for the patch.
> - a patch from John Kacur to avoid a warning in the hpsa.
> - a patch for the ppc5200 where the compiler thinks a variable isn't
>    initialized and stops compililing due to -Werror
>
> Known issues:
>
>        - SLAB support not working
>
>        - The cpsw network driver shows some issues.
>
>        - ARM & PPC don't fall apart once booted. More testing doesn't
>          hurt.
>
>        - bcache with CONFIG_DEBUG_LOCK_ALLOC enabled does not compile.
...
