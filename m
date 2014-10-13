Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaJMOdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 10:33:22 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39425 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaJMOdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 10:33:21 -0400
Message-ID: <543BE40F.1050509@gmail.com>
Date: Mon, 13 Oct 2014 22:39:11 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oleg Drokin <oleg.drokin@intel.com>
CC: Andreas Dilger <andreas.dilger@intel.com>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Liang Zhen <liang.zhen@intel.com>,
        Denis Pithon <denis.pithon@gmail.com>, Patrick Farrell <paf@cray.com>,
        Masanari Iida <standby24x7@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: lustre: ptlrpc: sec.c:  Replacing strncat
 with strlcat to avoid overwrite size
References: <1413129333-19863-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1413129333-19863-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/14 23:55, Rickard Strandqvist wrote:
> Changed from using strncat with strlcat to avoid overwrite the max size.
> Take the opportunity to change a snprint to strlcpy.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/lustre/lustre/ptlrpc/sec.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec.c b/drivers/staging/lustre/lustre/ptlrpc/sec.c
> index 5cff7ee..d276e98 100644
> --- a/drivers/staging/lustre/lustre/ptlrpc/sec.c
> +++ b/drivers/staging/lustre/lustre/ptlrpc/sec.c
> @@ -209,7 +209,7 @@ EXPORT_SYMBOL(sptlrpc_flavor2name_bulk);
>  
>  char *sptlrpc_flavor2name(struct sptlrpc_flavor *sf, char *buf, int bufsize)
>  {
> -	snprintf(buf, bufsize, "%s", sptlrpc_flavor2name_base(sf->sf_rpc));
> +	strlcpy(buf, sptlrpc_flavor2name_base(sf->sf_rpc), bufsize);
>  
>  	/*
>  	 * currently we don't support customized bulk specification for
> @@ -220,10 +220,9 @@ char *sptlrpc_flavor2name(struct sptlrpc_flavor *sf, char *buf, int bufsize)
>  
>  		bspec[0] = '-';
>  		sptlrpc_flavor2name_bulk(sf, &bspec[1], sizeof(bspec) - 1);
> -		strncat(buf, bspec, bufsize);
> +		strlcat(buf, bspec, bufsize);
>  	}
>  
> -	buf[bufsize - 1] = '\0';
>  	return buf;
>  }
>  EXPORT_SYMBOL(sptlrpc_flavor2name);
> 

At least for me, it is OK.

Acked-by: Chen Gang <gang.chen.5i5j@gmail.com>

Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
