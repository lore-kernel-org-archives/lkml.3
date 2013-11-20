Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab3KTXx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 18:53:29 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43117 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab3KTXx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 18:53:27 -0500
X-Originating-IP: 173.246.103.110
Date: Wed, 20 Nov 2013 15:53:16 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Greg Price <price@MIT.EDU>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christopher Li <sparse@chrisli.org>,
        Joe Perches <joe@perches.com>, Erico Nunes <nunes.erico@gmail.com>,
        linux-sparse@vger.kernel.org, dwmw2 <dwmw2@infradead.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Clarify error on directive in macro arguments (Re:
 [PATCH] jffs2: fix sparse errors: directive in argument list)
Message-ID: <20131120235316.GB25026@jtriplet-mobl1>
References: <20131118013349.GM13318@ZenIV.linux.org.uk>
 <20131118020746.GX16018@ringworld.MIT.EDU>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118020746.GX16018@ringworld.MIT.EDU>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 09:07:46PM -0500, Greg Price wrote:
> From: Greg Price <price@mit.edu>
> Date: Sun, 17 Nov 2013 17:57:41 -0800
> Subject: [PATCH] Clarify error on directive in macro arguments
> 
> Preprocessor directives in the arguments of a real function
> are innocuous and in some contexts common.  If a developer
> doesn't realize that a "function" is implemented as a macro,
> they may mistake this error for a false alarm.
> 
> See http://www.spinics.net/lists/kernel/msg1636974.html
> and http://www.spinics.net/lists/kernel/msg1636976.html
> for an example.
> 
> Easy enough to clarify that this is a macro, so do it.
> 
> Signed-off-by: Greg Price <price@mit.edu>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Good call.

>  pre-process.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/pre-process.c b/pre-process.c
> index d521318..db58a97 100644
> --- a/pre-process.c
> +++ b/pre-process.c
> @@ -204,7 +204,7 @@ static struct token *collect_arg(struct token *prev, int vararg, struct position
>  		if (next->pos.newline && match_op(next, '#')) {
>  			if (!next->pos.noexpand) {
>  				sparse_error(next->pos,
> -					     "directive in argument list");
> +					     "directive in macro argument list");
>  				preprocessor_line(stream, p);
>  				__free_token(next);	/* Free the '#' token */
>  				continue;
> -- 
> 1.8.3.2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sparse" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
