Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaKQIJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 03:09:32 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:36821 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaKQIJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 03:09:29 -0500
X-Originating-IP: 50.43.41.112
Date: Mon, 17 Nov 2014 00:09:19 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Iulia Manda <iulia.manda21@gmail.com>,
        Pravin B Shelar <pshelar@nicira.com>
Subject: Re: linux-next: manual merge of the tiny tree with the net-next tree
Message-ID: <20141117080919.GD18179@thin>
References: <20141117163503.6543cd21@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117163503.6543cd21@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 04:35:03PM +1100, Stephen Rothwell wrote:
> Hi Josh,
> 
> Today's linux-next merge of the tiny tree got a conflict in
> net/openvswitch/Kconfig between commit 8cd4313aa775 ("openvswitch: Fix
> build failure") from the net-next tree and commit b043d487e255 ("lib:
> Conditionally compile flex_array") from the tiny tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good to me.

> diff --cc net/openvswitch/Kconfig
> index b7d818c59423,1d979cecd66e..000000000000
> --- a/net/openvswitch/Kconfig
> +++ b/net/openvswitch/Kconfig
> @@@ -4,9 -4,8 +4,10 @@@
>   
>   config OPENVSWITCH
>   	tristate "Open vSwitch"
>  +	depends on INET
>   	select LIBCRC32C
>  +	select NET_MPLS_GSO
> + 	select FLEX_ARRAY
>   	---help---
>   	  Open vSwitch is a multilayer Ethernet switch targeted at virtualized
>   	  environments.  In addition to supporting a variety of features


