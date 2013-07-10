Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab3GJUmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 16:42:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45162 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab3GJUmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:42:19 -0400
Date: Wed, 10 Jul 2013 13:42:16 -0700 (PDT)
Message-Id: <20130710.134216.1407498845215548973.davem@davemloft.net>
To: gang.chen@asianux.com
Cc: sam@ravnborg.org, zhaohongjiang@huawei.com, gregkh@linuxfoundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] arch: sparc: kernel: check the memory length before
 use strcpy().
From: David Miller <davem@davemloft.net>
In-Reply-To: <51C53571.9070403@asianux.com>
References: <51C53571.9070403@asianux.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Gang <gang.chen@asianux.com>
Date: Sat, 22 Jun 2013 13:26:09 +0800

> 
> For the related next strcpy(), the destination length is less than 512,
> but the source maximize length may be 'OPROMMAXPARAM' (4096) which is
> more than 512.
> 
> One work flow may:
>   openprom_sunos_ioctl() ->  if (cmd == OPROMSETOPT)
>     getstrings() ->  will alloc buffer with size 'OPROMMAXPARAM'.
>     opromsetopt() ->  devide the buffer into 'var' and 'value'
>       of_set_property() -> pass
>         prom_setprop() -> pass
>           ldom_set_var()
> 
> And do not mind the additional 4 alignment buffer increasing, since
> 'sizeof(pkt) - sizeof(pkt.header)' is 4 alignment at least.
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Applied.
