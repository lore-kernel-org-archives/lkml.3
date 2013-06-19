Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab3FSGPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 02:15:06 -0400
Received: from ozlabs.org ([203.10.76.45]:48954 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756353Ab3FSGPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 02:15:04 -0400
From: Michael Neuling <mikey@neuling.org>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
cc: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, jkenisto@linux.vnet.ibm.com,
        tony.luck@intel.com, mahesh@linux.vnet.ibm.com, cbouatmailru@gmail.com,
        anton@samba.org, ccross@android.com, keescook@chromium.org
Subject: Re: [PATCH v4 0/8] Nvram-to-pstore
In-reply-to: <20130605184756.25794.43872.stgit@aruna-ThinkPad-T420>
References: <20130605184756.25794.43872.stgit@aruna-ThinkPad-T420>
Comments: In-reply-to Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
   message dated "Thu, 06 Jun 2013 00:20:39 +0530."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Wed, 19 Jun 2013 16:15:03 +1000
Message-ID: <1822.1371622503@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com> wrote:
> Currently the kernel provides the contents of p-series NVRAM only as a
> simple stream of bytes via /dev/nvram, which must be interpreted in user
> space by the nvram command in the powerpc-utils package. This patch set
> exploits the pstore subsystem to expose each partition in NVRAM as a
> separate file in /dev/pstore. For instance, Oops messages will be stored
> in a file named [dmesg-nvram-2].
> 
> Changes from v3:
> 	- Change filename prefix for of-config and common partition
> 
> Changes from v2:
> 	- Fix renaming of pstore type ids in nvram.c
> 
> Changes from v1:
> 	- Reduce #ifdefs by and remove forward declarations of pstore callbacks
> 	- Handle return value of nvram_write_os_partition
> 	- Remove empty pstore callbacks and register pstore only when pstore
> 	  is configured

When booted on pHyp, I see /dev/nvram but not /dev/pstore, even if I
turn on CONFIG_PSTORE.  Is there something else I need to add?

Should we update pseries_defconfig to include CONFIG_PSTORE (which it
doesn't include currently)?  Maybe turn on panic/oops via
CONFIG_PSTORE_RAM too?

Other than that, the series looks clean.  It's passes my build and boot
tests.

I've not reviewed the contents of the patches.

Mikey

> ---
> 
> Aruna Balakrishnaiah (8):
>       powerpc/pseries: Remove syslog prefix in uncompressed oops text
>       powerpc/pseries: Add version and timestamp to oops header
>       powerpc/pseries: Introduce generic read function to read nvram-partitions
>       powerpc/pseries: Read/Write oops nvram partition via pstore
>       powerpc/pseries: Read rtas partition via pstore
>       powerpc/pseries: Distinguish between a os-partition and non-os partition
>       powerpc/pseries: Read of-config partition via pstore
>       powerpc/pseries: Read common partition via pstore
> 
> 
>  arch/powerpc/platforms/pseries/nvram.c |  353 +++++++++++++++++++++++++++-----
>  fs/pstore/inode.c                      |    9 +
>  include/linux/pstore.h                 |    4 
>  3 files changed, 313 insertions(+), 53 deletions(-)
> 
> -- 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 
