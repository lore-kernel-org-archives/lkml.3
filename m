Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaANGsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 01:48:00 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:50309 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaANGry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 01:47:54 -0500
Date: Tue, 14 Jan 2014 08:47:52 +0200
From: Jack Morgenstein <jackm@dev.mellanox.co.il>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Or Gerlitz <ogerlitz@mellanox.com>, Rony Efraim <ronye@mellanox.com>,
        Hadar Hen Zion <hadarh@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net/mlx4_core: clean up cq_res_start_move_to()
Message-ID: <20140114084752.1db64b21@jpm-OptiPlex-GX620>
In-Reply-To: <1389099678.15032.19.camel@x41>
References: <1389099678.15032.19.camel@x41>
Organization: Mellanox
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This time, replying to the list as well.

-Jack
P.S. sorry for the delay, I was swamped.

On Tue, 07 Jan 2014 14:01:18 +0100
Paul Bolle <pebolle@tiscali.nl> wrote:

> +	} else {
> +		/* state == RES_CQ_HW */
> +		if (r->com.state != RES_CQ_ALLOCATED)

if (state != RES_CQ_HW || r->com.state != RES_CQ_ALLOCATED)
to protect against any bad calls to this function
(although I know that currently there are none).

This also preserves the behavior of the switch statement.

>  			err = -EINVAL;
> -		}
> +		else
> +			err = 0;
> +	}
>  
> -		if (!err) {
> -			r->com.from_state = r->com.state;
> -			r->com.to_state = state;
> -			r->com.state = RES_CQ_BUSY;
> -			if (cq)
> -				*cq = r;
> -		}
> +	if (!err) {
> +		r->com.from_state = r->com.state;
> +		r->com.to_state = state;
> +		r->com.state = RES_CQ_BUSY;

Please keep the "if" here.  Protects against (future) bad calls.

> +		*cq = r;
>  	}

