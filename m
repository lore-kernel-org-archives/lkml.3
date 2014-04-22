Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbaDVTRC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:17:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48493 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbaDVTQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:16:58 -0400
Date: Tue, 22 Apr 2014 12:16:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH 1/4] idr: proper invalid argument handling
Message-Id: <20140422121656.14d5e5534ae4888119787471@linux-foundation.org>
In-Reply-To: <1398161781-12105-2-git-send-email-laijs@cn.fujitsu.com>
References: <1398161781-12105-1-git-send-email-laijs@cn.fujitsu.com>
	<1398161781-12105-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014 18:16:18 +0800 Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> When the arguments passed by the caller are invalid, WARN_ON_ONCE()
> is proper than BUG_ON() which may crash the kernel.
> 
> ida_remove()/idr_remove() add checks for "id < 0".
> BUG_ON() in ida_simple_remove() is simply removed, due to
> ida_remove() already checks for "id < 0".
> 
> In idr_alloc(), it still returns -ENOSPC when "start == end",
> but it returns -EINVAL when "max < start" while old code returns
> -ENOSPC. -EINVAL is proper here, the caller must passed wrong
> arguments.
> 
> ida_simple_get()'s argument-checks are changed as the same as
> idr_alloc().

This patch doesn't apply.

> @@ -551,10 +553,7 @@ void idr_remove(struct idr *idp, int id)
>  	struct idr_layer *p;
>  	struct idr_layer *to_free;
>  
> -	if (id < 0)
> -		return;
> -
> -	if (id > idr_max(idp->layers)) {
> +	if (id < 0 || id > idr_max(idp->layers)) {
>  		idr_remove_warning(id);
>  		return;
>  	}

3.15-rc2's idr_remove() has a call to sub_remove() in there, but
whatever-kernel-you're-using does not.


