Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab3ETOBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:01:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524Ab3ETOBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:01:02 -0400
Date: Mon, 20 May 2013 15:57:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: akpm@linux-foundation.org, jlayton@redhat.com,
        lucas.demarchi@profusion.mobi, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, bfields@fieldses.org,
        viro@zeniv.linux.org.uk, bharrosh@panasas.com, devel@openvz.org
Subject: Re: [RFC PATCH] kmod: add ability to swap root in usermode helper
Message-ID: <20130520135716.GA10084@redhat.com>
References: <20130520070017.7957.9224.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130520070017.7957.9224.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20, Stanislav Kinsbursky wrote:
>
> Usermode helper executes all binaries in global "init" root context. This
> doesn't allow to call to call the binary from other root (for example in a
> container).
> Currently, containerized NFS server requires an ability to execute a binary in
> a other context, than "init" root (UMH is used for client recovery tracking).
> This patch adds root swap to ____call_usermodehelper(), if non-NULL root was
> passed as a part of subprocess_info data,

Why do we need the new member/arguments?

> @@ -215,6 +216,9 @@ static int ____call_usermodehelper(void *data)
>  	 */
>  	set_user_nice(current, 0);
>
> +	if (sub_info->root)
> +		set_fs_root(current->fs, sub_info->root);

Can't subprocess_info->init() do this? You can pass root as ->data.

IOW, unless I missed something, nfs can do this without any changes
in kmod.c.

Oleg.

