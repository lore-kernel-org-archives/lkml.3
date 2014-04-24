Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbaDXQrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:47:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60754 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758569AbaDXQrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:47:46 -0400
Date: Thu, 24 Apr 2014 12:47:44 -0400 (EDT)
Message-Id: <20140424.124744.1296959126932595844.davem@davemloft.net>
To: santosh.shilimkar@ti.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        sandeep_n@ti.com, robh+dt@kernel.org, grant.likely@linaro.org
Subject: Re: [PATCH 2/2] net: Add Keystone NetCP ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398201675-17379-3-git-send-email-santosh.shilimkar@ti.com>
References: <1398201675-17379-1-git-send-email-santosh.shilimkar@ti.com>
	<1398201675-17379-3-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Apr 2014 09:47:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Tue, 22 Apr 2014 17:21:15 -0400

> +struct netcp_tx_pipe {
> +	struct netcp_device	*netcp_device;
> +	void	*dma_queue;

Indent *dma_queue the same as the other struct members.

> +	unsigned		dma_queue_id;

Use explicit "unsigned int".

> +	unsigned		dma_chan_id;

Likewise.

> +struct netcp_addr {
> +	struct netcp_intf	*netcp;
> +	unsigned char		addr[MAX_ADDR_LEN];

If this is just an ethernet driver, ETH_ALEN is more appropriate here.

> +	unsigned		tx_compl_qid;

Explicit "unsigned int" please.  I'm not going to point out all of the other
instances, audit your entire submission for this problem please.

> +static inline u32 *netcp_push_psdata(struct netcp_packet *p_info,
> +				     unsigned bytes)
> +{
> +	u32		*buf;
> +	unsigned	 words;

Do not use tabs between the type and the variable name in local variable
declarations.

Please audit for and fix this in your entire submission.

> +static inline u32 hwval_to_host(bool big_endian, u32 hwval)
> +{
> +	if (big_endian)
> +		return be32_to_cpu(hwval);
> +	else
> +		return le32_to_cpu(hwval);
> +}

You're much better off having a set of methods, one for big endian and
one for little endian, that just straight line codes the appropriate endian
accesses.

These conditionals peppered all over the place are just ugly.
