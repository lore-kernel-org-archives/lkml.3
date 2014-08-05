Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaHETNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 15:13:44 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63441 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbaHETNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 15:13:42 -0400
Message-ID: <53E12CE2.7080305@kernel.dk>
Date: Tue, 05 Aug 2014 13:13:38 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Philippe De Muyter <phdm@macqel.be>
CC: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] partitions: aix.c: off by one bug
References: <20140805080959.GA13605@mwanda>
In-Reply-To: <20140805080959.GA13605@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 02:09 AM, Dan Carpenter wrote:
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
> 

Applied, thanks.

-- 
Jens Axboe

