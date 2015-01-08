Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbbAHHzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 02:55:44 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:45774 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbbAHHzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 02:55:42 -0500
Date: Thu, 8 Jan 2015 08:55:24 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@ezchip.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-ia64@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 1/3] module_arch_freeing_init(): new hook for archs
 before module->module_init freed.
Message-ID: <20150108075524.GA24522@samfundet.no>
References: <1420678687-30548-1-git-send-email-rusty@rustcorp.com.au>
 <1420678687-30548-2-git-send-email-rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420678687-30548-2-git-send-email-rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Thu 08 Jan 2015 11:28:05 +1030 or thereabout, Rusty Russell wrote:
> Archs have been abusing module_free() to clean up their arch-specific
> allocations.  Since module_free() is also (ab)used by BPF and trace code,
> let's keep it to simple allocations, and provide a hook called before
> that.
> 
> This means that avr32, ia64, parisc and s390 no longer need to implement
> their own module_free() at all.  avr32 doesn't need module_finalize()
> either.

At a glance it looks sane.

> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Chris Metcalf <cmetcalf@ezchip.com>
> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
> Cc: Helge Deller <deller@gmx.de>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-ia64@vger.kernel.org
> Cc: linux-parisc@vger.kernel.org
> Cc: linux-s390@vger.kernel.org

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/kernel/module.c   | 13 +------------
>  arch/ia64/kernel/module.c    |  6 ++----
>  arch/parisc/kernel/module.c  |  6 +-----
>  arch/s390/kernel/module.c    | 10 +++-------
>  arch/tile/kernel/module.c    |  2 +-
>  include/linux/moduleloader.h |  2 ++
>  kernel/module.c              |  7 +++++++
>  7 files changed, 17 insertions(+), 29 deletions(-)

<snipp diff>

-- 
HcE
