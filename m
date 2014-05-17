Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964942AbaEQRTe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 13:19:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964842AbaEQRTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 13:19:32 -0400
Date: Sat, 17 May 2014 19:18:56 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Wolfram Sang <wsa@the-dreams.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Leilei Shang <shangll@marvell.com>, Daniel Drake <dsd@laptop.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] i2c: busses: i2c-pxa.c:  Fix for possible null pointer
 dereference
Message-ID: <20140517171855.GC1939@mguzik.redhat.com>
References: <1400346848-25098-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1400346848-25098-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 07:14:08PM +0200, Rickard Strandqvist wrote:
> There is otherwise a risk of a possible null pointer dereference.
> 
> Was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/i2c/busses/i2c-pxa.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
> index bbe6dfb..dbe5ebe 100644
> --- a/drivers/i2c/busses/i2c-pxa.c
> +++ b/drivers/i2c/busses/i2c-pxa.c
> @@ -1269,7 +1269,9 @@ eremap:
>  eclk:
>  	kfree(i2c);
>  emalloc:
> -	release_mem_region(res->start, resource_size(res));
> +	if(res) {
> +		release_mem_region(res->start, resource_size(res));
> +	}
>  	return ret;
>  }
>  

This looks incorrect.

request_mem_region, which I believe is a prerequisite for this function
may not be called when you jump here.

-- 
Mateusz Guzik
