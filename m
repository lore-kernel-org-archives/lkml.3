Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbaGHSmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:42:03 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:58655 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbaGHSmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:42:01 -0400
MIME-Version: 1.0
In-Reply-To: <1404704477-19448-2-git-send-email-linus.luessing@web.de>
References: <1404704477-19448-1-git-send-email-linus.luessing@web.de>
	<1404704477-19448-2-git-send-email-linus.luessing@web.de>
Date: Tue, 8 Jul 2014 11:41:59 -0700
Message-ID: <CAHA+R7NjR4yovAskx3yym_wyXCOZRqSd81=+mnF_1wwUfPEn1Q@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] bridge: adding stubs for multicast exports
From: Cong Wang <cwang@twopensource.com>
To: =?UTF-8?Q?Linus_L=C3=BCssing?= <linus.luessing@web.de>
Cc: netdev <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
	<bridge@lists.linux-foundation.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        b.a.t.m.a.n@lists.open-mesh.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 6, 2014 at 8:41 PM, Linus Lüssing <linus.luessing@web.de> wrote:
> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index fd22789..e0c575c 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -36,8 +36,22 @@ extern void brioctl_set(int (*ioctl_hook)(struct net *, unsigned int, void __use
>
>  typedef int br_should_route_hook_t(struct sk_buff *skb);
>  extern br_should_route_hook_t __rcu *br_should_route_hook;
> +
> +#if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_BRIDGE_IGMP_SNOOPING)

Nit: CONFIG_BRIDGE_IGMP_SNOOPING depends CONFIG_BRIDGE,
so you can just check CONFIG_BRIDGE_IGMP_SNOOPING.
