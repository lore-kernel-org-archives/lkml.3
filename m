Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514Ab3EUAzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 20:55:39 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:56946 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab3EUAzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 20:55:37 -0400
Message-ID: <519AC605.4070709@gmail.com>
Date: Mon, 20 May 2013 20:55:33 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, hughd@google.com, shli@kernel.org,
        kzak@redhat.com, jmoyer@redhat.com, riel@redhat.com,
        lwoodman@redhat.com, mgorman@suse.de, kosaki.motohiro@gmail.com
Subject: Re: [RFC PATCH 01/02] swap: discard while swapping only if SWAP_FLAG_DISCARD_CLUSTER
References: <cover.1369092449.git.aquini@redhat.com> <e3ae11727f13e1580ae66ce80845e9002ec90ea6.1369092449.git.aquini@redhat.com>
In-Reply-To: <e3ae11727f13e1580ae66ce80845e9002ec90ea6.1369092449.git.aquini@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/20/13 8:04 PM), Rafael Aquini wrote:
> Intruduce a new flag to make page-cluster fine-grained discards while swapping
> conditional, as they can be considered detrimental to some setups. However,
> keep allowing batched discards at sys_swapon() time, when enabled by the
> system administrator. 
> 
> Signed-off-by: Rafael Aquini <aquini@redhat.com>
> ---
>  include/linux/swap.h |  8 +++++---
>  mm/swapfile.c        | 12 ++++++++----
>  2 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 1701ce4..ab2e742 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -19,10 +19,11 @@ struct bio;
>  #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
>  #define SWAP_FLAG_PRIO_MASK	0x7fff
>  #define SWAP_FLAG_PRIO_SHIFT	0
> -#define SWAP_FLAG_DISCARD	0x10000 /* discard swap cluster after use */
> +#define SWAP_FLAG_DISCARD	0x10000 /* enable discard for swap areas */
> +#define SWAP_FLAG_DISCARD_CLUSTER 0x20000 /* discard swap clusters after use */

>From point of backward compatibility view, 0x10000 should be disable both discarding
when mount and when IO.
And, introducing new two flags, enable mount time discard and enable IO time discard.

IOW, Please consider newer kernel and older swapon(8) conbination.
Other than that, looks good to me.


