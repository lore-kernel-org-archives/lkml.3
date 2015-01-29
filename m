Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbbA2BPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:15:08 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:65402 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752965AbbA2BPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:15:06 -0500
Message-ID: <1422491816.3621.84.camel@x220>
Subject: Re: [PATCH] Smack: fix netfilter Makefile entry
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 29 Jan 2015 01:36:56 +0100
In-Reply-To: <2504358.ZeqdfUXKpJ@wuerfel>
References: <2504358.ZeqdfUXKpJ@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jan 2015 00:36:56.0361 (UTC) FILETIME=[AF585990:01D03B5B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-28 at 17:12 +0100, Arnd Bergmann wrote:
> The newly added Smack support for netfilter secmark has its own
> Kconfig symbol, but the actual implementation is conditionally
> built on another symbol.
> 
> It is possible for CONFIG_NETFILTER and SECURITY_SMACK to both
> be enabled, but NETWORK_SECMARK to be disabled, in which case
> we get a build error:
> 
> ../security/smack/smack_netfilter.c: In function 'smack_ipv6_output':
> ../security/smack/smack_netfilter.c:36:6: error: 'struct sk_buff' has no member named 'secmark'
>    skb->secmark = skp->smk_secid;
>       ^
> ../security/smack/smack_netfilter.c: In function 'smack_ipv4_output':
> ../security/smack/smack_netfilter.c:55:6: error: 'struct sk_buff' has no member named 'secmark'
>    skb->secmark = skp->smk_secid;
>       ^
> 
> This changes the Makefile to use the correct Kconfig symbol.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 69f287ae6fc83 ("Smack: secmark support for netfilter")
> 
> diff --git a/security/smack/Makefile b/security/smack/Makefile
> index 616cf93b368e..d4a376c84050 100644
> --- a/security/smack/Makefile
> +++ b/security/smack/Makefile
> @@ -5,4 +5,4 @@
>  obj-$(CONFIG_SECURITY_SMACK) := smack.o
>  
>  smack-y := smack_lsm.o smack_access.o smackfs.o
> -smack-$(CONFIG_NETFILTER) += smack_netfilter.o
> +smack-$(SECURITY_SMACK_NETFILTER) += smack_netfilter.o

You probably wanted to use:
    CONFIG_SECURITY_SMACK_NETFILTER


Paul Bolle

