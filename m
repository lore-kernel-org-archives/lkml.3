Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaERTu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 15:50:57 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:51748 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaERTu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 15:50:56 -0400
Date: Sun, 18 May 2014 21:50:42 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
cc: Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>, dc395x@twibble.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: dc395x.c:  Fix for possible null pointer dereference
In-Reply-To: <1400429349-11040-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Message-ID: <Pine.LNX.4.64.1405182147500.23804@axis700.grange>
References: <1400429349-11040-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:OmSRdHRABb0vjOLWYxsvjGicEzBpx3c1C19GQ6rIkpY
 oH/OhbbWmfId7W8eCF0BRwZm2AO9bv9oiuUe5zApD5T/kHNfNw
 6SGSaBhgxCP6c5duY4s/lOcUuRliZVjJWYXG+fPqhbPaC3Q0nx
 P8C6Tlk+Pf33w39ezhGtZGbClOO6+A4M7Kyf27+/RQYrikMLmo
 5FteVWy4dpfeYSG/KRhFzqe9sL4mSFwPbbnk85jrw0sER7T++h
 ND+pp5H7xOoaM+Af0SOv7zqV0F7/nPggvVNQTg44rwshKH5Wah
 CssNIlM+RZtqGtI9JiMYiSvWheJ8LIP30z6oXYReH2bJsb9zD9
 HPYvHlNGXmlWFceMkPpWsi+m+4OtQVdShjxCzUlJgSFmvw/58g
 n3CAn7RJmWKhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 May 2014, Rickard Strandqvist wrote:

> There is otherwise a risk of a possible null pointer dereference.
> 
> Was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/scsi/dc395x.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> index 83d9bf6..0d86bc7 100644
> --- a/drivers/scsi/dc395x.c
> +++ b/drivers/scsi/dc395x.c
> @@ -2637,7 +2637,7 @@ static struct ScsiReqBlk *msgin_qtag(struct AdapterCtlBlk *acb,
>  	struct ScsiReqBlk *srb = NULL;
>  	struct ScsiReqBlk *i;
>  	dprintkdbg(DBG_0, "msgin_qtag: (0x%p) tag=%i srb=%p\n",
> -		   srb->cmd, tag, srb);
> +		   srb ? srb->cmd : 0, tag, srb);

There's not just a risk, it is a NULL-pointer dereference, so, just remove 
it, e.g. like

> -	dprintkdbg(DBG_0, "msgin_qtag: (0x%p) tag=%i srb=%p\n",
> -		   srb->cmd, tag, srb);
> +	dprintkdbg(DBG_0, "msgin_qtag: tag=%i\n", tag);

Thanks
Guennadi

>  	if (!(dcb->tag_mask & (1 << tag)))
>  		dprintkl(KERN_DEBUG,
> -- 
> 1.7.10.4

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
