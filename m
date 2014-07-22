Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbaGVHxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:53:38 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43147 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaGVHxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:53:36 -0400
Date: Tue, 22 Jul 2014 10:53:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net, dcb314@hotmail.com,
        jason.wessel@windriver.com, wharms@bfs.de
Subject: Re: [PATCH] kernel/debug/kdb/kdb_bp.c: fix argument range check
Message-ID: <20140722075207.GN25880@mwanda>
References: <1405705224-32171-1-git-send-email-andrey.krieger.utkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405705224-32171-1-git-send-email-andrey.krieger.utkin@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 08:40:24PM +0300, Andrey Utkin wrote:
> Dropped negativity check; enhanced upper limit check as proposed by
> Walter Harms <wharms@bfs.de>
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80591
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
> ---
>  kernel/debug/kdb/kdb_bp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/debug/kdb/kdb_bp.c b/kernel/debug/kdb/kdb_bp.c
> index 70a5046..371150f 100644
> --- a/kernel/debug/kdb/kdb_bp.c
> +++ b/kernel/debug/kdb/kdb_bp.c
> @@ -39,7 +39,7 @@ static char *kdb_rwtypes[] = {
>  
>  static char *kdb_bptype(kdb_bp_t *bp)
>  {
> -	if (bp->bp_type < 0 || bp->bp_type > 4)
> +	if (bp->bp_type >= ARRAY_SIZE(kdb_rwtypes))
>  		return "";

I like this version of the patch because it silences the static checker
warning like the first one does but it also makes the code more
readable.

regards,
dan carpenter

