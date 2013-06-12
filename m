Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab3FLQCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 12:02:24 -0400
Received: from multi.imgtec.com ([194.200.65.239]:53549 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112Ab3FLQCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 12:02:21 -0400
Message-ID: <51B89B8A.2070500@imgtec.com>
Date: Wed, 12 Jun 2013 17:02:18 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>
CC: James Hogan <james.hogan@imgtec.com>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v8] fs: imgdafs: Add IMG DAFS filesystem for metag
References: <1368112454-2330-1-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1368112454-2330-1-git-send-email-james.hogan@imgtec.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_06_12_17_02_19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On 09/05/13 16:14, James Hogan wrote:
> Add the IMG Debug Adapter File System (DAFS) for metag, which uses
> SWITCH operations to communicate with a file server on a host computer
> via a JTAG debug adapter.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>

Is this patch acceptable for v3.11?

Thanks
James

> ---
> v8:
>   * enabled building as a module (commit e605ff8 merged during v3.10
>     merge window exports the necessary symbols)
> 
> v7:
>   * use explicit sized types in da_stat and da_finddata (Al Viro)
>   * move IMGDAFS_SUPER_MAGIC to <linux/magic.h> (Al Viro)
>   * use fmode_t instead of int in a couple of places (Al Viro)
>   * removed "will unlock" comment (Al Viro)
>   * use kmalloc and init hi->mode explicitly (Al Viro)
>   * kmalloc instead of using dynamic array for path (Al Viro)
>   * use file_inode() helper in dafs_readdir (Al Viro)
> 
> v6:
>   * use file_inode() helper introduced in v3.9-rc1
>   * remove dafs_iops as it only contained directory methods
>   * add MODULE_ALIAS_FS()
> 
> v5:
>   * removed arch/metag changes (the arch/metag patchset it was
>     previously part of is now mainline with those changes)
> 
> v4:
>   * clean up fscall similarly to chancall in tty/metag_da
> 
> v2:
>   * fixed fserrno problem (Al Viro)
>   * renamed to imgdafs
> 
>  fs/Kconfig                 |   1 +
>  fs/Makefile                |   1 +
>  fs/imgdafs/Kconfig         |   6 +
>  fs/imgdafs/Makefile        |   7 +
>  fs/imgdafs/imgdafs.h       |  82 +++++
>  fs/imgdafs/inode.c         | 842 +++++++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/magic.h |   1 +
>  7 files changed, 940 insertions(+)
>  create mode 100644 fs/imgdafs/Kconfig
>  create mode 100644 fs/imgdafs/Makefile
>  create mode 100644 fs/imgdafs/imgdafs.h
>  create mode 100644 fs/imgdafs/inode.c

