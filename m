Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbbA1U7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:59:33 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:44719 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbbA1U73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:59:29 -0500
Message-ID: <54C927E3.6000006@cogentembedded.com>
Date: Wed, 28 Jan 2015 21:18:11 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Smack: fix netfilter Makefile entry
References: <2504358.ZeqdfUXKpJ@wuerfel>
In-Reply-To: <2504358.ZeqdfUXKpJ@wuerfel>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/28/2015 07:12 PM, Arnd Bergmann wrote:

> The newly added Smack support for netfilter secmark has its own
> Kconfig symbol, but the actual implementation is conditionally
> built on another symbol.

> It is possible for CONFIG_NETFILTER and SECURITY_SMACK to both
> be enabled, but NETWORK_SECMARK to be disabled, in which case
> we get a build error:

> ../security/smack/smack_netfilter.c: In function 'smack_ipv6_output':
> ../security/smack/smack_netfilter.c:36:6: error: 'struct sk_buff' has no member named 'secmark'
>     skb->secmark = skp->smk_secid;
>        ^
> ../security/smack/smack_netfilter.c: In function 'smack_ipv4_output':
> ../security/smack/smack_netfilter.c:55:6: error: 'struct sk_buff' has no member named 'secmark'
>     skb->secmark = skp->smk_secid;
>        ^
>
> This changes the Makefile to use the correct Kconfig symbol.

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 69f287ae6fc83 ("Smack: secmark support for netfilter")

> diff --git a/security/smack/Makefile b/security/smack/Makefile
> index 616cf93b368e..d4a376c84050 100644
> --- a/security/smack/Makefile
> +++ b/security/smack/Makefile
> @@ -5,4 +5,4 @@
>   obj-$(CONFIG_SECURITY_SMACK) := smack.o
>
>   smack-y := smack_lsm.o smack_access.o smackfs.o
> -smack-$(CONFIG_NETFILTER) += smack_netfilter.o
> +smack-$(SECURITY_SMACK_NETFILTER) += smack_netfilter.o

    CONFIG_ missing?

WBR, Sergei

