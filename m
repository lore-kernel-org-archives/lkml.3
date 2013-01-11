Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3AKOxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:53:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253Ab3AKOxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:53:05 -0500
Date: Fri, 11 Jan 2013 09:52:56 -0500
From: Peter Jones <pjones@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] ibft: add a missing break statement
Message-ID: <20130111145256.GA14496@fenchurch.internal.datastacks.com>
References: <20130111064807.GA13207@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130111064807.GA13207@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 09:48:07AM +0300, Dan Carpenter wrote:
> The code works the same with or without the break.  It just looks a bit
> cleaner to not fall through.

Yeah, you're clearly right.

For those reading this, so you don't have to go check yourselves, the
line after the end of this diff is also a break; there's no further code
in that case.

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Peter Jones <pjones@redhat.com>

> 
> diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
> index 3ee852c..c4b187c 100644
> --- a/drivers/firmware/iscsi_ibft.c
> +++ b/drivers/firmware/iscsi_ibft.c
> @@ -503,6 +503,7 @@ static umode_t __init ibft_check_tgt_for(void *data, int type)
>  	case ISCSI_BOOT_TGT_NIC_ASSOC:
>  	case ISCSI_BOOT_TGT_CHAP_TYPE:
>  		rc = S_IRUGO;
> +		break;
>  	case ISCSI_BOOT_TGT_NAME:
>  		if (tgt->tgt_name_len)
>  			rc = S_IRUGO;

-- 
        Peter
