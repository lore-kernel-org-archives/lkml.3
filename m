Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760562AbaEMNF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:05:58 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:38439 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490AbaEMNF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:05:57 -0400
Message-ID: <1399986340.4137.14.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 1/1] net/wireless/util.c: replace memcpy by
 ether_addr_copy
From: Johannes Berg <johannes@sipsolutions.net>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        akpm <akpm@linux-foundation.org>
Date: Tue, 13 May 2014 15:05:40 +0200
In-Reply-To: <20140512195114.5fca94e46368be5daaa9e56b@skynet.be>
References: <20140512195114.5fca94e46368be5daaa9e56b@skynet.be>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-12 at 19:51 +0200, Fabian Frederick wrote:
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  net/wireless/util.c | 42 +++++++++++++++++++++---------------------
>  1 file changed, 21 insertions(+), 21 deletions(-)
> 
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index e5872ff..ab23b95 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -381,8 +381,8 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
>  	 *   1     0   BSSID SA    DA    n/a
>  	 *   1     1   RA    TA    DA    SA
>  	 */
> -	memcpy(dst, ieee80211_get_DA(hdr), ETH_ALEN);
> -	memcpy(src, ieee80211_get_SA(hdr), ETH_ALEN);
> +	ether_addr_copy(dst, ieee80211_get_DA(hdr));
> +	ether_addr_copy(src, ieee80211_get_SA(hdr));

I think this patch is mostly fine, but I'd like you to understand and
document (in the commit log) why it is, and fix the (potential future)
issue with "dst" as discussed in the other thread.

johannes

