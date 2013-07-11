Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3GKQas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:30:48 -0400
Received: from drsnuggles.stderr.nl ([94.142.244.14]:46482 "EHLO
	drsnuggles.stderr.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab3GKQap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:30:45 -0400
Date: Thu, 11 Jul 2013 17:43:22 +0200
From: Matthijs Kooijman <matthijs@stdin.nl>
To: Julien Delacou <julien.delacou.st@gmail.com>
Cc: Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        Julien Delacou <julien.delacou@stericsson.com>
Subject: Re: [PATCH] staging: dwc2: fix value used in dwc2_set_all_params
Message-ID: <20130711154322.GJ10217@login.drsnuggles.stderr.nl>
Mail-Followup-To: Julien Delacou <julien.delacou.st@gmail.com>,
	Paul Zimmerman <paulz@synopsys.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Grant Likely <grant.likely@linaro.org>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Julien Delacou <julien.delacou@stericsson.com>
References: <1373545450-5251-1-git-send-email-julien.delacou.st@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373545450-5251-1-git-send-email-julien.delacou.st@gmail.com>
X-PGP-Fingerprint: 7F6A 9F44 2820 18E2 18DE  24AA CF49 D0E6 8A2F AFBC
X-PGP-Key: http://www.stderr.nl/static/files/gpg_pubkey.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-Score: -2.6 (--)
X-Spam-Report: Spamchecked on "mail.drsnuggles.stderr.nl"
	pts  rule name              description
	---- ---------------------- -------------------------------------------
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 02:24:10PM +0200, Julien Delacou wrote:
> From: Julien Delacou <julien.delacou@stericsson.com>
> 
> This fix uses 'value' parameter as it should be instead
> of hardcoded -1.
Woops!

> Signed-off-by: Julien Delacou <julien.delacou@stericsson.com>
> Acked-by: Paul Zimmerman <paulz@synopys.com>
Reviewed-by: Matthijs Kooijman <matthijs@stdin.nl>

> ---
>  drivers/staging/dwc2/hcd.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/dwc2/hcd.c b/drivers/staging/dwc2/hcd.c
> index 2ed54b1..ca38aaa 100644
> --- a/drivers/staging/dwc2/hcd.c
> +++ b/drivers/staging/dwc2/hcd.c
> @@ -2690,7 +2690,7 @@ void dwc2_set_all_params(struct dwc2_core_params *params, int value)
>  	int i;
>  
>  	for (i = 0; i < size; i++)
> -		p[i] = -1;
> +		p[i] = value;
>  }
>  EXPORT_SYMBOL_GPL(dwc2_set_all_params);
>  
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
