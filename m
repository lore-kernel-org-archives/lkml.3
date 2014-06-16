Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbaFPUU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:20:29 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:46398 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaFPUU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:20:28 -0400
X-CheckPoint: {539F5188-2-2100090A-C0000000}
Message-ID: <539F5188.6060004@tilera.com>
Date: Mon, 16 Jun 2014 16:20:24 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>, <linux-kernel@vger.kernel.org>
CC: <julia.lawall@lip6.fr>
Subject: Re: [PATCH] tile: use ARRAY_SIZE
References: <20140616201224.GA18320@himangi-Dell>
In-Reply-To: <20140616201224.GA18320@himangi-Dell>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/16/2014 4:12 PM, Himangi Saraogi wrote:
> ARRAY_SIZE is more concise to use when the size of an array is divided
> by the size of its type or the size of its first element.
>
> The semantic patch that makes this change is as follows:
>
> // <smpl>
> @i@
> @@
>
> @@
> type T;
> T[] E;
> @@
>
> - (sizeof(E)/sizeof(T))
> + ARRAY_SIZE(E)
> // </smpl>
>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
> Not compile tested.
>   arch/tile/kernel/traps.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, taken into the tile tree.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

