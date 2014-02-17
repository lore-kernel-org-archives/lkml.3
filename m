Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaBQNWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 08:22:55 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:39704 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbaBQNWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:22:53 -0500
Message-ID: <53020D1D.9020008@mev.co.uk>
Date: Mon, 17 Feb 2014 13:22:37 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>, gregkh@linuxfoundation.org
CC: hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Staging: comedi: addi-data: do not initialize statics
 to 0 in hwdrv_apci035.c
References: <1392540006-25972-1-git-send-email-chase.southwood@yahoo.com> <1392540092-26109-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1392540092-26109-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-16 08:41, Chase Southwood wrote:
> This patch for hwdrv_apci035.c removes a zero initialization from two
> static variables.  Static variables are initialized to zero by default,
> so doing so explicitly is not necessary.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> I purposely made this patch the last in the series, because while it is
> technically true that static variables need not be initialized to zero,
> and checkpatch doesn't much like the practice, I didn't know if, for
> readability's sake, you wanted these to stay in as-is. Since this is the
> last patch, feel free to drop it if you don't like it.
>
>   drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> index f02b714..10e02e5 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> @@ -106,8 +106,8 @@ static struct comedi_lrange range_apci035_ai = {
>   	}
>   };
>
> -static int i_WatchdogNbr = 0;
> -static int i_Temp = 0;
> +static int i_WatchdogNbr;
> +static int i_Temp;
>   static int i_Flag = 1;
>   /*
>   +----------------------------------------------------------------------------+
>

God knows why it's using these variables anyway.  The addi-data drivers 
that haven't been redone by Hartley are a complete mess!

FWIW, there's no extra harm in applying this patch!

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
