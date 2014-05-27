Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaE0W5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 18:57:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56279 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaE0W5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 18:57:05 -0400
Message-ID: <53851835.3060706@infradead.org>
Date: Tue, 27 May 2014 15:56:53 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>, linux-kernel@vger.kernel.org,
        lxc-devel@lists.linuxcontainers.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@wittsend.com>, Marian Marinov <mm@1h.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Michael J Coss <michael.coss@alcatel-lucent.com>
Subject: Re: [RFC PATCH 1/2] loop: Add loop filesystem
References: <1401227936-15698-1-git-send-email-seth.forshee@canonical.com> <1401227936-15698-2-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1401227936-15698-2-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 02:58 PM, Seth Forshee wrote:
> Add limited capability for use of loop devices in containers via
> a loopfs psuedo fs. When mounted this filesystem will contain
> only a loop-control device node. This can be used to request free
> loop devices which will be "owned" by that mount. Device nodes
> appear automatically for these devices, and the same device will
> not be given to another loopfs mount. Privileged loop ioctls
> (for encrypted loop) will be allowed within the namespace which
> mounted the loopfs.
> 
> Privileged block ioctls are not permitted, so features such as
> partitions are not supported for unprivileged users.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/block/loop.c       | 110 +++++++++++---
>  drivers/block/loop.h       |   2 +
>  fs/Makefile                |   1 +
>  fs/loopfs/Makefile         |   6 +
>  fs/loopfs/inode.c          | 349 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/loopfs.h     |  46 ++++++
>  include/uapi/linux/magic.h |   1 +
>  7 files changed, 495 insertions(+), 20 deletions(-)
>  create mode 100644 fs/loopfs/Makefile
>  create mode 100644 fs/loopfs/inode.c
>  create mode 100644 include/linux/loopfs.h
> 

> diff --git a/fs/loopfs/Makefile b/fs/loopfs/Makefile
> new file mode 100644
> index 000000000000..01aedfb2f841
> --- /dev/null
> +++ b/fs/loopfs/Makefile
> @@ -0,0 +1,6 @@
> +#
> +# Makefile for the loopfs virtual filesystem
> +#
> +
> +obj-$(CONFIG_BLK_DEV_LOOP)		+= loopfs.o
> +loopfs-$(CONFIG_BLK_DEV_LOOP)		:= inode.o

I guess that you need to update the BLK_DEV_LOOP entry in
drivers/block/Kconfig to mention this?


-- 
~Randy
