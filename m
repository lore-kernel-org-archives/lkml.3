Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaI2AC5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 20:02:57 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42802 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaI2AC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 20:02:56 -0400
X-Originating-IP: 50.43.15.134
Date: Sun, 28 Sep 2014 17:02:44 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: Re: [PATCH V2 linux-next] jffs2: fix sparse warning: unexpected
 unlock
Message-ID: <20140929000243.GA1353@thin>
References: <1411932392-7751-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411932392-7751-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 09:26:32PM +0200, Fabian Frederick wrote:
> fs/jffs2/summary.c:846:5: warning: context imbalance in 'jffs2_sum_write_sumnode' - unexpected unlock
> 
> Suggested-by: Brian Norris <computersforpeace@gmail.com>
> Suggested-by: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> V2: use __must_hold instead of __releases / __acquires
> (suggested by Brian Norris and Josh Triplett)
> 
>  fs/jffs2/summary.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/jffs2/summary.c b/fs/jffs2/summary.c
> index c522d09..bc53854 100644
> --- a/fs/jffs2/summary.c
> +++ b/fs/jffs2/summary.c
> @@ -844,6 +844,7 @@ static int jffs2_sum_write_data(struct jffs2_sb_info *c, struct jffs2_eraseblock
>  /* Write out summary information - called from jffs2_do_reserve_space */
>  
>  int jffs2_sum_write_sumnode(struct jffs2_sb_info *c)
> +	__must_hold(&c->erase_completion_block)
>  {
>  	int datasize, infosize, padsize;
>  	struct jffs2_eraseblock *jeb;
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sparse" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
