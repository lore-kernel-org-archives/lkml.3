Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934458AbaKMWJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:09:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934044AbaKMWJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:09:34 -0500
Date: Thu, 13 Nov 2014 14:09:33 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pieter Smith <pieter@boesman.nl>
Cc: "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        Dmitry Eremin <dmitry.eremin@intel.com>, Li Xi <lixi@ddn.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Peng Tao <bergwolf@gmail.com>, Josh Triplett <josh@joshtriplett.org>,
        Oleg Drokin <green@linuxhacker.ru>,
        Andrew Perepechko <andrew_perepechko@xyratex.com>,
        JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>,
        Jinshan Xiong <jinshan.xiong@intel.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Lai Siyao <lai.siyao@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 05/56] fs/lustre: support compiling out splice
Message-ID: <20141113220933.GB546@kroah.com>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
 <1415913813-362-6-git-send-email-pieter@boesman.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415913813-362-6-git-send-email-pieter@boesman.nl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 10:22:42PM +0100, Pieter Smith wrote:
> Compile out splice support from lustre file-system when the splice-family of
> syscalls is not supported by the system (i.e. CONFIG_SYSCALL_SPLICE is
> undefined).
> 
> Signed-off-by: Pieter Smith <pieter@boesman.nl>
> ---
>  drivers/staging/lustre/lustre/llite/file.c           | 10 +++++++---
>  drivers/staging/lustre/lustre/llite/llite_internal.h |  2 ++
>  drivers/staging/lustre/lustre/llite/vvp_io.c         |  2 ++
>  3 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
> index fd1b75a3..98573da 100644
> --- a/drivers/staging/lustre/lustre/llite/file.c
> +++ b/drivers/staging/lustre/lustre/llite/file.c
> @@ -1126,10 +1126,12 @@ restart:
>  				down_read(&lli->lli_trunc_sem);
>  			}
>  			break;
> +#ifdef CONFIG_SYSCALL_SPLICE
>  		case IO_SPLICE:
>  			vio->u.splice.cui_pipe = args->u.splice.via_pipe;
>  			vio->u.splice.cui_flags = args->u.splice.via_flags;
>  			break;
> +#endif /* #ifdef CONFIG_SYSCALL_SPLICE */

Not worth the #ifdef mess, sorry.

