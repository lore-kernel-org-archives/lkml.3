Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965065AbaD3TwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 15:52:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186AbaD3TwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 15:52:13 -0400
Date: Wed, 30 Apr 2014 12:52:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <dyoung@redhat.com>
Cc: matt.fleming@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] earlyprintk=efi,keep fix
Message-Id: <20140430125211.cb33039fc1248c953bcc13dc@linux-foundation.org>
In-Reply-To: <20140430021303.GA12316@darkstar.redhat.com>
References: <20140430021303.GA12316@darkstar.redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2014 10:13:03 +0800 Dave Young <dyoung@redhat.com> wrote:

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
> To fix this issue, I added one early initcall efi_ioremap_fb which will map the whole
> efi fb for later use. OTOH, adding a wrapper function efi_ioremap which will call
> early_ioremap before ioremap is available.
> 
> With this patch applied efi boot ok with earlyprintk=efi,keep console=efi
> 

CONFIG_DEBUG_SECTION_MISMATCH should have detected this, but
CONFIG_DEBUG_SECTION_MISMATCH doesn't seem to work any more. 
scripts/Makefile.modpost appears to be trying to pass -S to modpost if
CONFIG_DEBUG_SECTION_MISMATCH, but I'm not seeing any warnings.  The
CONFIG_DEBUG_SECTION_MISMATCH Kconfig help is not useful.  What did we
do?

Shudder.  I'll assume Matt will handle this patch?
