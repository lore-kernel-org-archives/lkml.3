Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbbA1U10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:27:26 -0500
Received: from smtp105.biz.mail.bf1.yahoo.com ([98.139.221.43]:33004 "EHLO
	smtp105.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755690AbbA1U1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:27:22 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: b0hjRI8VM1mOk5m8Sw0MyWvRMxU6.bHpIcQIften6pzJaM.
 GfpBOnn49I4Cu879yQEa0P2Xg3mC7XmeN4QY7iH5RFLdDmBrlU4FMTBORi7Q
 vrIWjzJwwjMihjtU0LVdj3sxulW3hclMBmmByswVReLOJTkIgvlvWUQQs4Oo
 jQ61A0nAUaWx27jRDcSgUaNyU3vznr0cBNdw_pcwSRDLsSbKb25VXztPmZPN
 .bQXADqKA2Sk5.Kd6jtabwbD26LjiY1dXeugVYlaX4.g7bREgDfCWuJYmJvX
 0zmqSsfNZPpyicWqqo3M3m_iCoxBUYNM2Y0cOg2t3aNs6F8TC8B1qYaUlRCh
 qSQTpq7m.lgQZutCJ3sI7LFH_Rh7r79Rn24N3LwqjwSyBxPkLV9hOfvuZSwp
 0Gd4CXON6hYPYgzVRnTbe7TNJntjJnS_p3LG1yJV.pN.fcQ.F.UmIZSEvOno
 zQDajJ31znDEXUpNnWxcKBNl8WLaaa4szziuOFFOJktKx7N4VszQiwxZdz0d
 5MktnDIRnbJIbw.PhdMreniEklgoqR2diw_slbrfnjqSlKV0HI1gNEIW8h8D
 YPp1ScEbUWWnkplI0cAR5mAWUB3U9rbTAbEgSGQgj4TEcltsOw1i2.mvwT64
 Ac8By0.MIFZiMq1If7WYdwN9V
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <54C90DE8.1030600@schaufler-ca.com>
Date: Wed, 28 Jan 2015 08:27:20 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Smack: fix netfilter Makefile entry
References: <2504358.ZeqdfUXKpJ@wuerfel>
In-Reply-To: <2504358.ZeqdfUXKpJ@wuerfel>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/28/2015 8:12 AM, Arnd Bergmann wrote:
> The newly added Smack support for netfilter secmark has its own
> Kconfig symbol, but the actual implementation is conditionally
> built on another symbol.

A patch for this problem, 82b0b2c2b1e64ad6c5309a9eeba806af9812666b
is already available in:

	git://git.gitorious.org/smack-next/kernel.git smack-for-3.20-rebased

A pull request has sent to James Morris for inclusion in the security tree.

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
>
>

