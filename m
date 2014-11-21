Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaKUUD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:03:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38251 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaKUUD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:03:57 -0500
Date: Fri, 21 Nov 2014 15:03:54 -0500 (EST)
Message-Id: <20141121.150354.242152731394048793.davem@davemloft.net>
To: tinajohnson.1234@gmail.com
Cc: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH v2] drivers: atm: eni: Add pci_dma_mapping_error() call
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416479094-7764-1-git-send-email-tinajohnson.1234@gmail.com>
References: <1416479094-7764-1-git-send-email-tinajohnson.1234@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Nov 2014 12:03:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tina Johnson <tinajohnson.1234@gmail.com>
Date: Thu, 20 Nov 2014 15:54:54 +0530

> Added a pci_dma_mapping_error() call to check for mapping errors before
> further using the dma handle. In case of error, control goes to a new label
> where the incoming skb is freed. Unchecked dma handles were found using
> Coccinelle:
> 
> @rule1@
> expression e1;
> identifier x;
> @@
> 
> *x = pci_map_single(...);
>  ... when != pci_dma_mapping_error(e1,x)
> 
> Signed-off-by: Tina Johnson <tinajohnson.1234@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
> v2: *Removed jump to trouble label
>     *Added a new label dma_map_error

Applied, thanks.
