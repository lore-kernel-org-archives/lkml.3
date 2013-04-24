Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab3DXUpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 16:45:10 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57899 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598Ab3DXUpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 16:45:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130424061807.7341.909.stgit@aruna-ThinkPad-T420>
References: <20130424061807.7341.909.stgit@aruna-ThinkPad-T420>
Date: Wed, 24 Apr 2013 13:45:06 -0700
X-Google-Sender-Auth: 8LqKWRx_dg9z0ppABr3GndUG6Ko
Message-ID: <CAGXu5jLrtMFXh28b2uV6+U8vdXRfLxmjKRo8i5YF8bmkeK_sKg@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] powerpc/pseries: Nvram-to-pstore
From: Kees Cook <keescook@chromium.org>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, paulus@samba.org,
        LKML <linux-kernel@vger.kernel.org>, benh@kernel.crashing.org,
        jkenisto@linux.vnet.ibm.com, Tony Luck <tony.luck@intel.com>,
        ananth@in.ibm.com, mahesh@linux.vnet.ibm.com,
        Colin Cross <ccross@android.com>, anton@samba.org,
        Anton Vorontsov <cbouatmailru@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 11:19 PM, Aruna Balakrishnaiah
<aruna@linux.vnet.ibm.com> wrote:
> Currently the kernel provides the contents of p-series NVRAM only as a
> simple stream of bytes via /dev/nvram, which must be interpreted in user
> space by the nvram command in the powerpc-utils package. This patch set
> exploits the pstore subsystem to expose each partition in NVRAM as a
> separate file in /dev/pstore. For instance Oops messages will stored in a
> file named [dmesg-nvram-2].
>
> Changes from v1:
>         - Reduce #ifdefs by and remove forward declarations of pstore callbacks
>         - Handle return value of nvram_write_os_partition
>         - Remove empty pstore callbacks and register pstore only when pstore
>           is configured
>
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

This series looks good! Other than the naming conventions (are these
new pstore types really PPC-only?) I think it's a fine addition.

Thanks!

-Kees

--
Kees Cook
Chrome OS Security
