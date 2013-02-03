Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab3BCQDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 11:03:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:42935 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab3BCQDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 11:03:40 -0500
Message-ID: <510E8A93.6050300@infradead.org>
Date: Sun, 03 Feb 2013 08:04:35 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Florian Westphal <fw@strlen.de>
CC: netfilter-devel@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: fix missing dependencies for NETFILTER_XT_MATCH_CONNLABEL
References: <510DC976.7000008@infradead.org> <1359890647-25846-1-git-send-email-fw@strlen.de>
In-Reply-To: <1359890647-25846-1-git-send-email-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/13 03:24, Florian Westphal wrote:
> It was possible to set
> NF_CONNTRACK=n
> NF_CONNTRACK_LABELS=y
> 
> via NETFILTER_XT_MATCH_CONNLABEL=y:
> 
> warning: (NETFILTER_XT_MATCH_CONNLABEL) selects NF_CONNTRACK_LABELS which has
> unmet direct dependencies (NET && INET && NETFILTER && NF_CONNTRACK)
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index eb2c8eb..d4dd702 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -860,6 +860,7 @@ config NETFILTER_XT_MATCH_CONNBYTES
>  config NETFILTER_XT_MATCH_CONNLABEL
>  	tristate '"connlabel" match support'
>  	select NF_CONNTRACK_LABELS
> +	depends on NF_CONNTRACK
>  	depends on NETFILTER_ADVANCED
>  	---help---
>  	  This match allows you to test and assign userspace-defined labels names
> 


-- 
~Randy
