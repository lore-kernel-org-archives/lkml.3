Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaESGDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:03:25 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:51883 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbaESGDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:03:23 -0400
Date: Mon, 19 May 2014 08:03:18 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Robert Richter <rric@kernel.org>, kernel-janitors@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        oprofile-list@lists.sf.net, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] s390/irq: make return of 0 explicit
Message-ID: <20140519060318.GA4459@osiris>
References: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr>
 <1400473875-22228-14-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400473875-22228-14-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051906-0342-0000-0000-000008CF700F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 06:31:15AM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Delete unnecessary local variable whose value is always 0 and that hides
> the fact that the result is always 0.
> 
> A simplified version of the semantic patch that fixes this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  arch/s390/oprofile/hwsampler.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/oprofile/hwsampler.c b/arch/s390/oprofile/hwsampler.c
> index 276f2e2..28b2760 100644
> --- a/arch/s390/oprofile/hwsampler.c
> +++ b/arch/s390/oprofile/hwsampler.c
> @@ -212,10 +212,8 @@ static void init_all_cpu_buffers(void)
>  static int prepare_cpu_buffers(void)
>  {
>  	int cpu;
> -	int rc;
>  	struct hws_cpu_buffer *cb;
> 
> -	rc = 0;
>  	for_each_online_cpu(cpu) {
>  		cb = &per_cpu(sampler_cpu_buffer, cpu);
>  		atomic_set(&cb->ext_params, 0);
> @@ -231,7 +229,7 @@ static int prepare_cpu_buffers(void)
>  		cb->stop_mode = 0;
>  	}
> 
> -	return rc;
> +	return 0;
>  }

Thanks Julia,

I applied a slightly different version which also turns prepare_cpu_buffers
into a void returning function.

