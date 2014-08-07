Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705AbaHGNLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:11:16 -0400
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:57595 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266AbaHGNLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:11:15 -0400
Date: Thu, 7 Aug 2014 09:10:12 -0400
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] drivers/atm/atmtcp.c: fix error return code
Message-ID: <20140807091012.793ef5c7@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <1407415749-19978-3-git-send-email-Julia.Lawall@lip6.fr>
References: <1407415749-19978-1-git-send-email-Julia.Lawall@lip6.fr>
	<1407415749-19978-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-NRLCMF-Spam-Score: () hits=-0.001
X-NRLCMF-Virus-Scanned: No virus found
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 Aug 2014 14:49:06 +0200
Julia Lawall <Julia.Lawall@lip6.fr> wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Convert a zero return value on error to a negative one, as returned
> elsewhere in the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
...
> 
> diff --git a/drivers/atm/atmtcp.c b/drivers/atm/atmtcp.c
> index 0e3f8f9..c8e4fb4 100644
> --- a/drivers/atm/atmtcp.c
> +++ b/drivers/atm/atmtcp.c
> @@ -299,6 +299,7 @@ static int atmtcp_c_send(struct atm_vcc *vcc,struct sk_buff *skb)
>  	out_vcc = find_vcc(dev, ntohs(hdr->vpi), ntohs(hdr->vci));
>  	read_unlock(&vcc_sklist_lock);
>  	if (!out_vcc) {
> +		result = -ESRCH;

This should probably be -EUNATCH to match the rest of the code.

>  		atomic_inc(&vcc->stats->tx_err);
>  		goto done;
>  	}
> 

