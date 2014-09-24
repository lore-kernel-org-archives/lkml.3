Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaIXU6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:58:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaIXU6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:58:32 -0400
Date: Wed, 24 Sep 2014 13:58:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>,
        Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] genalloc: fix device node resource counter
Message-Id: <20140924135831.ec76a8c60294a93e2da3b7af@linux-foundation.org>
In-Reply-To: <1411588260-29825-1-git-send-email-vladimir_zapolskiy@mentor.com>
References: <1411588260-29825-1-git-send-email-vladimir_zapolskiy@mentor.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014 22:51:00 +0300 Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com> wrote:

> The change balances a usage counter of np_pool device_node, which is
> incremented on preceding of_parse_phandle() call.
> 
> ...
>
> --- a/lib/genalloc.c
> +++ b/lib/genalloc.c
> @@ -637,6 +637,7 @@ struct gen_pool *of_get_named_gen_pool(struct device_node *np,
>  	if (!np_pool)
>  		return NULL;
>  	pdev = of_find_device_by_node(np_pool);
> +	of_node_put(np_pool);
>  	if (!pdev)
>  		return NULL;
>  	return dev_get_gen_pool(&pdev->dev);

Looks good, thanks.

However...  when fixing a bug, please always describe the end-user
visible effects of that bug.  Amongst other things this is to help me
and others decide which kernel version(s) need the patch.

I'm assuming that the effect will be, at worst, a memory leak at the
rate of one device_node per hot-unplug event and is hence a very minor
thing?

