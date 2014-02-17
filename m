Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaBQNKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 08:10:23 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:39638 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbaBQNKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:10:22 -0500
Message-ID: <53020A12.1090607@mev.co.uk>
Date: Mon, 17 Feb 2014 13:09:38 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>, gregkh@linuxfoundation.org
CC: hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: kcomedilib: replace deprecated simple_strtoul()
 with kstrtouint()
References: <1392436780-31184-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1392436780-31184-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-15 03:59, Chase Southwood wrote:
> Since simple_strtoul() has been deprecated, replace it with kstrtouint().
> Also, since return code checking for this new function is enforced, add a
> check to ensure that the conversion has succeeded.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
>   drivers/staging/comedi/kcomedilib/kcomedilib_main.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/kcomedilib/kcomedilib_main.c b/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
> index 7dc5a18..8923e65 100644
> --- a/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
> +++ b/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
> @@ -41,7 +41,8 @@ struct comedi_device *comedi_open(const char *filename)
>   	if (strncmp(filename, "/dev/comedi", 11) != 0)
>   		return NULL;
>
> -	minor = simple_strtoul(filename + 11, NULL, 0);
> +	if (kstrtouint(filename + 11, 0, &minor))
> +		return NULL;
>
>   	if (minor >= COMEDI_NUM_BOARD_MINORS)
>   		return NULL;
>

Looks good!

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
