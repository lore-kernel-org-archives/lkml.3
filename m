Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbaHEMps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:45:48 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:2969 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbaHEMpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:45:46 -0400
X-IronPort-AV: E=Sophos;i="5.01,804,1400025600"; 
   d="scan'208";a="159484135"
Date: Tue, 5 Aug 2014 13:45:45 +0100
From: Wei Liu <wei.liu2@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <Ian.Campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH net-next 1/2] xen-netback: Using a new state bit instead
 of carrier
Message-ID: <20140805124545.GD11230@zion.uk.xensource.com>
References: <1407165658-20146-1-git-send-email-zoltan.kiss@citrix.com>
 <1407165658-20146-2-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1407165658-20146-2-git-send-email-zoltan.kiss@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 04:20:57PM +0100, Zoltan Kiss wrote:
> This patch introduces a new state bit VIF_STATUS_CONNECTED to track whether the
> vif is in a connected state. Using carrier will not work with the next patch
> in this series, which aims to turn the carrier temporarily off if the guest
> doesn't seem to be able to receive packets.
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: xen-devel@lists.xenproject.org 
> 
> v2:
> - rename the bitshift type to "enum state_bit_shift" here, not in the next patch
> 
> diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
> index 28c9822..4a92fc1 100644
> --- a/drivers/net/xen-netback/common.h
> +++ b/drivers/net/xen-netback/common.h
> @@ -198,6 +198,11 @@ struct xenvif_queue { /* Per-queue data for xenvif */
>  	struct xenvif_stats stats;
>  };
>  
> +enum state_bit_shift {
> +	/* This bit marks that the vif is connected */
> +	VIF_STATUS_CONNECTED

This bit shift applies to vif.  In the following patch you introduce two
more bits specifically for queues. IMHO we should avoid mixing things
up. What about having two enums

  enum vif_state_bit_shift {}
  enum queue_state_bit_shift {}

?

Wei.
