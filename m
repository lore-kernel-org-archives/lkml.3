Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaFNJoL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 05:44:11 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbaFNJoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 05:44:08 -0400
Message-ID: <539C1964.4050504@nod.at>
Date: Sat, 14 Jun 2014 11:44:04 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Real Name <enjoymindful@gmail.com>,
        user-mode-linux-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] delete unnecessary bootmem struct page array
References: <1401773445-25256-1-git-send-email-enjoymindful@gmail.com>
In-Reply-To: <1401773445-25256-1-git-send-email-enjoymindful@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Am 03.06.2014 07:30, schrieb Real Name:
> From: Honggang Li <enjoymindful@gmail.com>
> 
> The patch based on linux-next-2014-06-02.
> 
> The old init_maps function does two things:
> 1) allocates and initializes one struct page array for bootmem
> 2) count the number of total pages
> 
> After removed the source code related to the unnecessary array, the name 
> 'init_maps' is some kind of improper named, as it just count the number of
> total page numbers. So, I renamed the function as 'mem_total_pages'.
> 
> I tested the patch through repeat reboot the uml kernel many times.
> [real@name linux-next]$ make ARCH=um defconfig
> [real@name linux-next]$ make ARCH=um linux
> [real@name linux-next]$ file linux
> linux: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32, not stripped
> [real@name linux-next]$ ./linux ubda=/home/real/linux-next/Fedora20-AMD64-root_fs mem=256m && sync && echo 1
> [real@name linux-next]$ ./linux ubda=/home/real/linux-next/Fedora20-AMD64-root_fs mem=256m && sync && echo 2
> (repeat reboot the uml kernel many times..)

Can you please include in the changelog the commit sha1 which made the old init_maps() obsolete?
I had a look at the pre-git linux tree, looks like init_maps() wasn't touched for more than 10 years.

Thanks,
//richard

> Honggang Li (1):
>   delete unnecessary bootmem struct page array
> 
>  arch/um/include/shared/mem_user.h |  2 +-
>  arch/um/kernel/physmem.c          | 32 ++++++--------------------------
>  arch/um/kernel/um_arch.c          |  7 +------
>  3 files changed, 8 insertions(+), 33 deletions(-)
> 
