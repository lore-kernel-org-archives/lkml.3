Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbaDFRrk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 13:47:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499AbaDFRrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 13:47:37 -0400
Message-ID: <53419330.405@redhat.com>
Date: Sun, 06 Apr 2014 19:47:28 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?UTF-8?B?VmluY2VudCBTdGVobMOp?= <vincent.stehle@laposte.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH] cpts: Fix missing includes
References: <1396805660-9807-1-git-send-email-vincent.stehle@laposte.net>
In-Reply-To: <1396805660-9807-1-git-send-email-vincent.stehle@laposte.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2014 07:34 PM, Vincent Stehlé wrote:
> The ETH_HLEN and VLAN_HLEN definitions are not in if.h any more. Add the
> necessary includes to fix the following compilation errors:
>
>    drivers/net/ethernet/ti/cpts.c: In function ‘cpts_match’:
>    drivers/net/ethernet/ti/cpts.c:266:12: error: ‘ETH_HLEN’ undeclared (first use in this function)
>    drivers/net/ethernet/ti/cpts.c:266:12: note: each undeclared identifier is reported only once for each function it appears in
>    drivers/net/ethernet/ti/cpts.c:276:23: error: ‘VLAN_HLEN’ undeclared (first use in this function)
>
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>

Thanks, fix is already in net tree ...

https://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=79eb9d28c9b22fa419e2c3f1b2cc6e285720ae41

> diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
> index a3bbf59..2a2f82a 100644
> --- a/drivers/net/ethernet/ti/cpts.c
> +++ b/drivers/net/ethernet/ti/cpts.c
> @@ -19,6 +19,8 @@
>    */
>   #include <linux/err.h>
>   #include <linux/if.h>
> +#include <linux/if_ether.h>
> +#include <linux/if_vlan.h>
>   #include <linux/hrtimer.h>
>   #include <linux/module.h>
>   #include <linux/net_tstamp.h>
>
