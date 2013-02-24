Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab3BXMej (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 07:34:39 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:64585 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab3BXMeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 07:34:37 -0500
From: Jack Morgenstein <jackm@dev.mellanox.co.il>
Organization: Mellanox
To: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH v2] IB/mlx4: silence GCC warning
Date: Sun, 24 Feb 2013 14:34:17 +0200
User-Agent: KMail/1.9.1
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
References: <1348836538.3626.21.camel@x61.thuisdomein> <511B9A1C.6000402@acm.org> <1361437377.1341.33.camel@x61.thuisdomein>
In-Reply-To: <1361437377.1341.33.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201302241434.17586.jackm@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 February 2013 11:02, Paul Bolle wrote:

> diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
> index 19e0637..512fde3 100644
> --- a/drivers/infiniband/hw/mlx4/qp.c
> +++ b/drivers/infiniband/hw/mlx4/qp.c
> @@ -1778,8 +1778,8 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
>  		}
>  
>  		vlan = rdma_get_vlan_id(&sgid);
> -		is_vlan = vlan < 0x1000;
>  	}
Nice try!
However, this approach does add the line below to processing for an IB port (ETH/RoCE port stays same, more or less).
Processing time is therefore increased (at least on the IB side) relative to just living with the warning.

Roland?

> +	is_vlan = vlan < 0x1000;  <=== Code line added to IB-side processing.

>  	ib_ud_header_init(send_size, !is_eth, is_eth, is_vlan, is_grh, 0, &sqp->ud_header);
>  
>  	if (!is_eth) {

-Jack
