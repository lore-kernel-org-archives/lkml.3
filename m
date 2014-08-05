Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161AbaHEKKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:10:23 -0400
Received: from smtp2.macqel.be ([109.135.2.61]:64720 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933145AbaHEKKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:10:22 -0400
Date: Tue, 5 Aug 2014 12:10:11 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Fabian Frederick <fabf@skynet.be>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] partitions: aix.c: off by one bug
Message-ID: <20140805101010.GA24281@frolo.macqel>
References: <20140805080959.GA13605@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805080959.GA13605@mwanda>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 11:09:59AM +0300, Dan Carpenter wrote:
> The lvip[] array has "state->limit" elements so the condition here
> should be >= instead of >.
> 
> Fixes: 6ceea22bbbc8 ('partitions: add aix lvm partition support files')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/block/partitions/aix.c b/block/partitions/aix.c
> index 0a6ed54..f3ed7b2 100644
> --- a/block/partitions/aix.c
> +++ b/block/partitions/aix.c
> @@ -253,7 +253,7 @@ int aix_partition(struct parsed_partitions *state)
>  				continue;
>  			}
>  			lv_ix = be16_to_cpu(p->lv_ix) - 1;
> -			if (lv_ix > state->limit) {
> +			if (lv_ix >= state->limit) {
>  				cur_lv_ix = -1;
>  				continue;
>  			}

Acked-by: Philippe De Muyter <phdm@macqel.be>

Thanks

Did you encounter the bug in real life, or only by code review ?

If this has a real risk to happen, a pr_warn would be welcome.

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
