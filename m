Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab3LNUoZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:44:25 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:45788 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab3LNUoX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:44:23 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 14 Dec 2013 12:44:15 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Neil Brown <neilb@suse.de>, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH] drivers: md: Mark the function btree_insert_fn() as
 static in btree.c
Message-ID: <20131214204414.GK17601@leaf>
References: <20131214125929.GA8200@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131214125929.GA8200@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 06:29:29PM +0530, Rashika Kheria wrote:
> This patch marks the function btree_insert_fn() as static in
> bcache/btree.c because it is not used outside this file.
> 
> Thus, it also eliminates the following warning in bcache/btree.c:
> drivers/md/bcache/btree.c:2220:5: warning: no previous prototype for ‘btree_insert_fn’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/md/bcache/btree.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 5e2765a..dc6e2be 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -2217,7 +2217,7 @@ struct btree_insert_op {
>  	struct bkey	*replace_key;
>  };
>  
> -int btree_insert_fn(struct btree_op *b_op, struct btree *b)
> +static int btree_insert_fn(struct btree_op *b_op, struct btree *b)
>  {
>  	struct btree_insert_op *op = container_of(b_op,
>  					struct btree_insert_op, op);
> -- 
> 1.7.9.5
> 
