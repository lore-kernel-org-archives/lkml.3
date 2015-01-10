Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbbAJLOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 06:14:39 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:56259 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbbAJLOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 06:14:37 -0500
Message-ID: <54B10997.6090708@kernel.org>
Date: Sat, 10 Jan 2015 11:14:31 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Harald Geyer <harald@ccbib.org>
CC: Richard Weinberger <richard@nod.at>, knaack.h@gmx.de, lars@metafoo.de,
        pmeerw@pmeerw.net, sanjeev_sharma@mentor.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/3,RESEND] iio: dht11: Fix out-of-bounds read
References: <1417563176-31972-1-git-send-email-richard@nod.at> <54A53FBF.5000003@kernel.org> <7e4f6a70e48afe96457ebbcf07572224@imap.cosmopool.net> <54A680F8.30209@nod.at> <54A91DA1.6080107@kernel.org> <E1Y881p-0001Fp-NX@stardust.g4.wien.funkfeuer.at> <54AA97B9.7040703@nod.at> <E1Y8pWE-00012g-Ec@stardust.g4.wien.funkfeuer.at>
In-Reply-To: <E1Y8pWE-00012g-Ec@stardust.g4.wien.funkfeuer.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/15 12:15, Harald Geyer wrote:
> As we access i-1 we must not start with i=0.
> 
> From: Richard Weinberger <richard@nod.at>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> Acked-by: Hartmut Knaack <knaack.h@gmx.de>
> Acked-by: Harald Geyer <harald@ccbib.org>
> Reviewed-by: Sanjeev Sharma <sanjeev_sharma@mentor.com>
> ---
> Resending again to get the metadata right.
Putting a From: in doesn't work, you need to use git commit --amend --author to
fix it up.

Anyhow, applied and author fixed up.
> No Signed-off-by from me, because I didn't contribute anything.
> No changes since v1 except reordering.
> 
>  drivers/iio/humidity/dht11.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/iio/humidity/dht11.c b/drivers/iio/humidity/dht11.c
> index 623c145..f546eca 100644
> --- a/drivers/iio/humidity/dht11.c
> +++ b/drivers/iio/humidity/dht11.c
> @@ -88,7 +88,7 @@ static int dht11_decode(struct dht11 *dht11, int offset)
>  	unsigned char temp_int, temp_dec, hum_int, hum_dec, checksum;
>  
>  	/* Calculate timestamp resolution */
> -	for (i = 0; i < dht11->num_edges; ++i) {
> +	for (i = 1; i < dht11->num_edges; ++i) {
>  		t = dht11->edges[i].ts - dht11->edges[i-1].ts;
>  		if (t > 0 && t < timeres)
>  			timeres = t;
> 

