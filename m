Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaGFX6h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 19:58:37 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54304 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382AbaGFX6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 19:58:36 -0400
X-Sasl-enc: UH+KM7FJRh4+6zuCmpQLbtXrZYe5k1BOqgo7RWQO3rvJ 1404691114
Date: Sun, 6 Jul 2014 16:58:18 -0700
From: Greg KH <greg@kroah.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] thunderbolt: Correct the size argument to devm_kzalloc
Message-ID: <20140706235818.GA18457@kroah.com>
References: <20140706161342.GA6267@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140706161342.GA6267@himangi-Dell>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2014 at 09:43:42PM +0530, Himangi Saraogi wrote:
> nhi->rx_rings does not have type as struct tb_ring *, as it is a
> double pointer so the elements of the array should have pointer type,
> not structure type.
> 
> The Coccinelle semantic patch that makes this change is as follows:
> 
> // <smpl>
> @disable sizeof_type_expr@
> type T;
> T **x;
> @@
> 
>   x =
>   <+...sizeof(
> - T
> + *x
>   )...+>
> // </smpl>
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
>  drivers/thunderbolt/nhi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Any reason you didn't cc: the developers in charge of this code so they
see it and can pick it up?  Otherwise it's just going to float around on
the mailing list, listless and sad.

greg k-h
