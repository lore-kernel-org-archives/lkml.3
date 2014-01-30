Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaA3ALM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 19:11:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60559 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbaA3ALL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 19:11:11 -0500
Date: Thu, 30 Jan 2014 01:11:08 +0100
From: Jan Kara <jack@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        rdunlap@infradead.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 1/1] fs: udf: parse_options: blocksize check
Message-ID: <20140130001108.GA24649@quack.suse.cz>
References: <20140129171316.ad5c50a7091e67b7ff1d329b@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140129171316.ad5c50a7091e67b7ff1d329b@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 29-01-14 17:13:16, Fabian Frederick wrote:
> Both affs and isofs check for blocksize integrity during
> parse_options.Do the same thing for udf.
> 
> Valid values : 512, 1024, 2048 or 4096 bytes.
  Thanks. Merged into my tree.

							Honza

> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/udf/super.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 3306b9f..ac76538 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -505,6 +505,7 @@ static int udf_parse_options(char *options, struct udf_options *uopt,
>  	while ((p = strsep(&options, ",")) != NULL) {
>  		substring_t args[MAX_OPT_ARGS];
>  		int token;
> +		unsigned n;
>  		if (!*p)
>  			continue;
>  
> @@ -516,7 +517,10 @@ static int udf_parse_options(char *options, struct udf_options *uopt,
>  		case Opt_bs:
>  			if (match_int(&args[0], &option))
>  				return 0;
> -			uopt->blocksize = option;
> +			n = option;
> +			if (n != 512 && n != 1024 && n != 2048 && n != 4096)
> +				return 0;
> +			uopt->blocksize = n;
>  			uopt->flags |= (1 << UDF_FLAG_BLOCKSIZE_SET);
>  			break;
>  		case Opt_unhide:
> -- 
> 1.8.1.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
