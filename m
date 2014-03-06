Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaCFT3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 14:29:24 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60078 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaCFT3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 14:29:22 -0500
Date: Thu, 06 Mar 2014 14:29:19 -0500 (EST)
Message-Id: <20140306.142919.763823800315842610.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH 1/6] Drivers: net: hyperv: Enable scatter gather I/O
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394104390-23477-1-git-send-email-kys@microsoft.com>
References: <1394104358-23438-1-git-send-email-kys@microsoft.com>
	<1394104390-23477-1-git-send-email-kys@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Mar 2014 11:29:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Thu,  6 Mar 2014 03:13:05 -0800

> @@ -140,21 +140,125 @@ static void netvsc_xmit_completion(void *context)
>  		dev_kfree_skb_any(skb);
>  }
>  
> +static u32 fill_pg_buf(struct page *page, u32 offset, u32 len,
> +			struct hv_page_buffer *pb)
> +{
> +	int j = 0;
> +	/*
> +	 * Deal with compund pages by ignoring unused part
> +	 * of the page.
> +	 */
> +	page += offset  >> PAGE_SHIFT;
> +	offset &= ~PAGE_MASK;

Please put an empty line between local variable declarations and
the code.

Please format comments:

	/* Like
	 * this.
	 */

> +	while (len > 0) {
> +		unsigned long bytes;
> +		bytes = PAGE_SIZE - offset;

Empty line between local variable declarations and code.

> +	/*
> +	 * The packet is laid out thus:
> +	 * 1. hdr
> +	 * 2. skb linear data
> +	 * 3. skb fragment data
> +	 */

Fix comment formatting as explained above.

> +	if (hdr != NULL) {
> +		slots_used += fill_pg_buf(virt_to_page(hdr),
> +					offset_in_page(hdr),
> +					len, &pb[slots_used]);
> +	}

Single statment basic blocks do not need surrounding braces.

> +	/*
> +	 * We will atmost need two pages to describe the rndis
> +	 * header. We can only transmit MAX_PAGE_BUFFER_COUNT number
> +	 * of pages in a single packet.
> +	 */

Comment formatting.
