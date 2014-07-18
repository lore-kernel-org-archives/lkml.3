Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965978AbaGRRS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:18:29 -0400
Received: from mx01-fr.bfs.de ([193.174.231.67]:45995 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965820AbaGRRS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:18:27 -0400
Message-ID: <53C956D5.50809@bfs.de>
Date: Fri, 18 Jul 2014 19:18:13 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net, dcb314@hotmail.com,
        jason.wessel@windriver.com
Subject: Re: [PATCH 4/5] kernel/debug/kdb/kdb_bp.c: drop negativity check
 on unsigned value
References: <1405697692-23816-1-git-send-email-andrey.krieger.utkin@gmail.com>
In-Reply-To: <1405697692-23816-1-git-send-email-andrey.krieger.utkin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 18.07.2014 17:34, schrieb Andrey Utkin:
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80591
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
> ---
>  kernel/debug/kdb/kdb_bp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/debug/kdb/kdb_bp.c b/kernel/debug/kdb/kdb_bp.c
> index 70a5046..f27dfb8 100644
> --- a/kernel/debug/kdb/kdb_bp.c
> +++ b/kernel/debug/kdb/kdb_bp.c
> @@ -39,7 +39,7 @@ static char *kdb_rwtypes[] = {
>  
>  static char *kdb_bptype(kdb_bp_t *bp)
>  {
> -	if (bp->bp_type < 0 || bp->bp_type > 4)
> +	if (bp->bp_type > 4)
>  		return "";
>  
>  	return kdb_rwtypes[bp->bp_type];

i would expect a ckeck for the upper limit with ARRAY_SIZE(bp->bp_type) here.

re,
 wh
