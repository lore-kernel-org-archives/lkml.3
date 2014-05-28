Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbaE1J5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:57:25 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:60715 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753065AbaE1J5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:57:23 -0400
Message-ID: <1401271041.28714.22.camel@x220>
Subject: Re: linux-next: build failure after merge of the final tree
From: Paul Bolle <pebolle@tiscali.nl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 28 May 2014 11:57:21 +0200
In-Reply-To: <20140528194629.0757af1b@canb.auug.org.au>
References: <20140528194629.0757af1b@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2014 09:57:21.0504 (UTC) FILETIME=[37DF7E00:01CF7A5B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-28 at 19:46 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c:203:34: error: 'struct ieee80211_hdr' has no member named 'addr1'
>            ieee->dev->name, header->addr1);
>                                   ^
> 
> I can't easily see what caused this, so I just disabled the staging
> tree driver:

That may be related to my "staging: rtl8192u: rename
CONFIG_IEEE80211_CRYPT_TKIP" (see https://lkml.org/lkml/2014/5/26/531 .)
My message states it was compile tested, but that would be on x86_64.
Did it only break on powerpc or did powerpc hit this first?

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 28 May 2014 19:43:17 +1000
> Subject: [PATCH] staging: rtl8192u: diable broken driver
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/staging/rtl8192u/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/rtl8192u/Kconfig b/drivers/staging/rtl8192u/Kconfig
> index 3ee9d0d00fb6..ea5d02d8cca2 100644
> --- a/drivers/staging/rtl8192u/Kconfig
> +++ b/drivers/staging/rtl8192u/Kconfig
> @@ -2,6 +2,7 @@ config RTL8192U
>  	tristate "RealTek RTL8192U Wireless LAN NIC driver"
>  	depends on PCI && WLAN && USB
>  	depends on m
> +	depends on BROKEN
>  	select WIRELESS_EXT
>  	select WEXT_PRIV
>  	select CRYPTO
> -- 
> 2.0.0.rc4

Thanks,


Paul Bolle

