Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934638AbaEFJ1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:27:50 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:61204 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934544AbaEFJ1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:27:48 -0400
MIME-Version: 1.0
In-Reply-To: <1399328773-6531-24-git-send-email-andi@firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org> <1399328773-6531-24-git-send-email-andi@firstfloor.org>
From: Nicolas Palix <nicolas.palix@imag.fr>
Date: Tue, 6 May 2014 11:27:27 +0200
X-Google-Sender-Auth: taLC8M4ygZbBkDv29pL42jMEPsE
Message-ID: <CAAxaTiOYTEQgibnpDBXdhNpJUAVrLFwxz0roq8Bin1rNnnsxgg@mail.gmail.com>
Subject: Re: [PATCH 23/24] net, diet: Add coccinelle script to convert drivers
 to ETHTOOL_OPS
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        tom.zanussi@linux.intel.com, Andi Kleen <ak@linux.intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

I saw you rejected almost the entire patch series.

However, is there any interest to enforce the use of SET_ETHTOOL_OPS ?
Are you likely to merge the patch 24/24 [1] ?

Regards,

[1] https://lkml.org/lkml/2014/5/5/679


On Tue, May 6, 2014 at 12:26 AM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Useful to remove unneeded driver code when ethtool is disabled.
>
> The patches doing this are submitted too, but let's add
> the script too so people can re-use it.
>
> Cc: Julia Lawall <Julia.Lawall@lip6.fr>
> Cc: Gilles Muller <Gilles.Muller@lip6.fr>
> Cc: Nicolas Palix <nicolas.palix@imag.fr>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  scripts/coccinelle/api/ethtool_ops.cocci | 9 +++++++++
>  1 file changed, 9 insertions(+)
>  create mode 100644 scripts/coccinelle/api/ethtool_ops.cocci
>
> diff --git a/scripts/coccinelle/api/ethtool_ops.cocci b/scripts/coccinelle/api/ethtool_ops.cocci
> new file mode 100644
> index 0000000..a7ee6ed
> --- /dev/null
> +++ b/scripts/coccinelle/api/ethtool_ops.cocci
> @@ -0,0 +1,9 @@
> +// Convert network drivers to use the SET_ETHTOOL_OPS macro
> +// This allows to compile out the ethtool code when not needed.
> +//
> +@@
> +struct ethtool_ops *ops;
> +struct net_device *dev;
> +@@
> +-      dev->ethtool_ops = ops;
> ++      SET_ETHTOOL_OPS(dev, ops);
> --
> 1.9.0
>



-- 
Nicolas Palix
Tel: +33 4 76 51 46 27
http://lig-membres.imag.fr/palix/
