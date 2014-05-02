Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaEBNAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 09:00:43 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:38410 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbaEBNAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 09:00:42 -0400
Date: Fri, 2 May 2014 14:00:31 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: matt.fleming@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, akpm@linux-foundation.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] earlyprintk=efi,keep fix
Message-ID: <20140502130031.GT26088@console-pimps.org>
References: <20140501131548.GA15258@darkstar.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501131548.GA15258@darkstar.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 May, at 09:15:48PM, Dave Young wrote:
> 
> earlyprintk=efi,keep will cause kernel hangs while freeing initmem like below:
> [    2.826089] VFS: Mounted root (ext4 filesystem) readonly on device 254:2.
> [    2.846592] devtmpfs: mounted
> [    2.856974] Freeing unused kernel memory: 880K (ffffffff817d4000 - ffffffff818b0000)
> 
> It is caused by efi earlyprintk use __init function which will be freed later.
> Such as early_efi_write is marked as __init, also it will use early_ioremap
> which is init function as well.
> 
> To fix this issue, I added early initcall early_efi_map_fb which maps the whole
> efi fb for later use. OTOH, adding a wrapper function early_efi_map which calls
> early_ioremap before ioremap is available.
> 
> With this patch applied efi boot ok with earlyprintk=efi,keep console=efi
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/x86/platform/efi/early_printk.c |   83 ++++++++++++++++++++++++++---------
>  1 file changed, 64 insertions(+), 19 deletions(-)

Thanks Dave, applied!

-- 
Matt Fleming, Intel Open Source Technology Center
