Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbbAETj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:39:57 -0500
Received: from relay2.sgi.com ([192.48.180.65]:60786 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753924AbbAETj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:39:56 -0500
Date: Mon, 5 Jan 2015 13:39:49 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc: sgi-gru: gruhandles.c:  Remove unused function
Message-ID: <20150105193949.GA18878@sgi.com>
References: <1420130807-29468-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420130807-29468-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Dimitri Sivanich <sivanich@sgi.com>

On Thu, Jan 01, 2015 at 05:46:47PM +0100, Rickard Strandqvist wrote:
> Remove the function tfh_restart() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/misc/sgi-gru/gruhandles.c |    6 ------
>  drivers/misc/sgi-gru/gruhandles.h |    1 -
>  2 files changed, 7 deletions(-)
> 
> diff --git a/drivers/misc/sgi-gru/gruhandles.c b/drivers/misc/sgi-gru/gruhandles.c
> index 2f30bad..1ee8e82 100644
> --- a/drivers/misc/sgi-gru/gruhandles.c
> +++ b/drivers/misc/sgi-gru/gruhandles.c
> @@ -196,12 +196,6 @@ void tfh_write_restart(struct gru_tlb_fault_handle *tfh,
>  	start_instruction(tfh);
>  }
>  
> -void tfh_restart(struct gru_tlb_fault_handle *tfh)
> -{
> -	tfh->opc = TFHOP_RESTART;
> -	start_instruction(tfh);
> -}
> -
>  void tfh_user_polling_mode(struct gru_tlb_fault_handle *tfh)
>  {
>  	tfh->opc = TFHOP_USER_POLLING_MODE;
> diff --git a/drivers/misc/sgi-gru/gruhandles.h b/drivers/misc/sgi-gru/gruhandles.h
> index 3f998b9..3d7bd36 100644
> --- a/drivers/misc/sgi-gru/gruhandles.h
> +++ b/drivers/misc/sgi-gru/gruhandles.h
> @@ -524,7 +524,6 @@ int tfh_write_only(struct gru_tlb_fault_handle *tfh, unsigned long paddr,
>  	int gaa, unsigned long vaddr, int asid, int dirty, int pagesize);
>  void tfh_write_restart(struct gru_tlb_fault_handle *tfh, unsigned long paddr,
>  	int gaa, unsigned long vaddr, int asid, int dirty, int pagesize);
> -void tfh_restart(struct gru_tlb_fault_handle *tfh);
>  void tfh_user_polling_mode(struct gru_tlb_fault_handle *tfh);
>  void tfh_exception(struct gru_tlb_fault_handle *tfh);
>  
> -- 
> 1.7.10.4
