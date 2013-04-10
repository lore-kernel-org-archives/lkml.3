Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936047Ab3DJR0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:26:14 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:46370 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934849Ab3DJR0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:26:13 -0400
Date: Wed, 10 Apr 2013 13:26:05 -0400 (EDT)
From: Eric Paris <eparis@redhat.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: viro@zeniv.linux.org.uk, yongjun wei <yongjun_wei@trendmicro.com.cn>,
        linux-kernel@vger.kernel.org
Message-ID: <170253117.11083340.1365614765343.JavaMail.root@redhat.com>
In-Reply-To: <CAPgLHd-M-q-xf+mp3VTAabxXS3bOjZ4g8EWLeE2NdjC2O7qCSA@mail.gmail.com>
References: <CAPgLHd-M-q-xf+mp3VTAabxXS3bOjZ4g8EWLeE2NdjC2O7qCSA@mail.gmail.com>
Subject: Re: [PATCH -next] audit: remove duplicated include from audit.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: audit: remove duplicated include from audit.c
Thread-Index: Hnw2l3jhYl01E8T1er7ugWf7fQUFkg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

net/netlink.h includes linux/netlink.h but linux/netlink.h does not include net/netlink.h

since the audit code uses the nlmsg_* functions provided in net/netlink.h it seems we need this include.

since the audit code uses netlink_unicast provided in linux/netlink.h it seems we need that include.

I don't see duplication even if by chance one of them would have included the other...

----- Original Message -----
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove duplicated include.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  kernel/audit.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 488f85f..9377913 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -58,7 +58,6 @@
>  #ifdef CONFIG_SECURITY
>  #include <linux/security.h>
>  #endif
> -#include <net/netlink.h>
>  #include <linux/freezer.h>
>  #include <linux/tty.h>
>  #include <linux/pid_namespace.h>
> 
> 
