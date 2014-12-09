Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaLISK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 13:10:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37075 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbaLISK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 13:10:57 -0500
Date: Tue, 09 Dec 2014 13:10:53 -0500 (EST)
Message-Id: <20141209.131053.2026868499542642866.davem@davemloft.net>
To: m-karicheri2@ti.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, grant.likely@linaro.org, sandeep_n@ti.com,
        santosh.shilimkar@kernel.org
Subject: Re: [PATCH v7 2/3] net: Add Keystone NetCP ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417556503-22290-3-git-send-email-m-karicheri2@ti.com>
References: <1417556503-22290-1-git-send-email-m-karicheri2@ti.com>
	<1417556503-22290-3-git-send-email-m-karicheri2@ti.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Dec 2014 10:10:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>
Date: Tue, 2 Dec 2014 16:41:42 -0500

> +static void set_pkt_info_le(u32 buff, u32 buff_len, u32 ndesc,
> +			    struct knav_dma_desc *desc)
> +{
> +	desc->buff_len = cpu_to_le32(buff_len);
> +	desc->buff = cpu_to_le32(buff);
> +	desc->next_desc = cpu_to_le32(ndesc);
> +}

The members of knav_dma_desc are "u32", so you are going to get tons of
static checker warnings from trying to assign cpu_to_le32()'s result
(which is a le32) into them.
