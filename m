Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbaFIFuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 01:50:03 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:48200 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaFIFt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 01:49:56 -0400
Date: Mon, 9 Jun 2014 13:49:49 +0800
From: Real Name <enjoymindful@gmail.com>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: richard@nod.at, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] delete unnecessary bootmem struct page array
Message-ID: <20140609054949.GB2465@name>
References: <1401773445-25256-1-git-send-email-enjoymindful@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401773445-25256-1-git-send-email-enjoymindful@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Richard
 Any comment about this patch?
thanks

On Tue, Jun 03, 2014 at 01:30:44PM +0800, Real Name wrote:
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
> 
> Honggang Li (1):
>   delete unnecessary bootmem struct page array
> 
>  arch/um/include/shared/mem_user.h |  2 +-
>  arch/um/kernel/physmem.c          | 32 ++++++--------------------------
>  arch/um/kernel/um_arch.c          |  7 +------
>  3 files changed, 8 insertions(+), 33 deletions(-)
> 
> -- 
> 1.8.3.1
> 
