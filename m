Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaGBK4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:56:12 -0400
Received: from smtp.citrix.com ([66.165.176.89]:39694 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbaGBK4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:56:10 -0400
X-IronPort-AV: E=Sophos;i="5.01,587,1400025600"; 
   d="scan'208";a="149210309"
Message-ID: <1404298567.5562.13.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH net-next] xen-netback: Adding debugfs "io_ring_qX" files
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: Wei Liu <wei.liu2@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Date: Wed, 2 Jul 2014 11:56:07 +0100
In-Reply-To: <1404160411-23747-1-git-send-email-zoltan.kiss@citrix.com>
References: <1404160411-23747-1-git-send-email-zoltan.kiss@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-30 at 21:33 +0100, Zoltan Kiss wrote:
> This patch adds debugfs capabilities to netback. There used to be a similar
> patch floating around for classic kernel, but it used procfs. It is based on a
> very similar blkback patch.
> It creates xen-netback/[vifname]/io_ring_q[queueno] files, reading them output
> various ring variables etc. Writing "kick" into it imitates an interrupt
> happened, it can be useful to check whether the ring is just stalled due to a
> missed interrupt.

Shouldn't there be some CONFIG_XEN_DEBUG_FS ifdefs sprinkled around
here?

> 	if (tx_ring->sring) {
> +		struct xen_netif_tx_sring *sring = tx_ring->sring;
> +
> +		err = snprintf(buf + rv, XEN_NETBACK_DBG_IORING_BUF_SIZE - rv,
> +			       "TX queue %d: nr_ents %u\n", i,
> +			       tx_ring->nr_ents);
> +		if (err >= XEN_NETBACK_DBG_IORING_BUF_SIZE - rv)
> +			return XEN_NETBACK_DBG_IORING_BUF_SIZE;
> +		else
> +			rv += err;

Does debugfs not provide helpers which let this be done in some more
palatable way?

arch/x86/xen/p2m.c seems to use some useful seq_*/single_* helpers for
something very similar and it looks much cleaner.

> +	if (vif->xenvif_dbg_root)

No IS_ERR check?

And in backend_disconnect/connect too.

Ian.

