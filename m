Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab3CDVGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:06:13 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38600 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758751Ab3CDVGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:06:09 -0500
Date: Mon, 4 Mar 2013 22:05:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: netfilter: nfnetlink: Fixed warning for
 nfnl_get_lock
Message-ID: <20130304210551.GA22306@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alexandru Gheorghiu <gheorghiuandru@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1362426192-2921-1-git-send-email-gheorghiuandru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1362426192-2921-1-git-send-email-gheorghiuandru@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 09:43:11PM +0200, Alexandru Gheorghiu wrote:
> Removed unused function nfnl_get_lock which fixed the following warning:
> net/netfilter/nfnetlink.c:65:22: warning: ‘nfnl_get_lock’ defined but not used [-Wunused-function]
> 
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
> ---
>  net/netfilter/nfnetlink.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> index d578ec2..44aa0a7 100644
> --- a/net/netfilter/nfnetlink.c
> +++ b/net/netfilter/nfnetlink.c
> @@ -62,11 +62,6 @@ void nfnl_unlock(__u8 subsys_id)
>  }
>  EXPORT_SYMBOL_GPL(nfnl_unlock);
> 
> -static struct mutex *nfnl_get_lock(__u8 subsys_id)
> -{
> -	return &table[subsys_id].mutex;
> -}
> -

I see the same warning here, gcc (Debian 4.7.2-5) 4.7.2.

Actually this function *is* used a bit further in the same file in
nfnetlink_rcv_msg().

But gcc complains for some reason of which I don't even have the
slightest idea. However, if you declare the above function "static
inline..." the warning is gone.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
