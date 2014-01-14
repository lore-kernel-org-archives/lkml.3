Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaANLuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:50:23 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:48278 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbaANLuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:50:20 -0500
Message-ID: <52D52478.3060706@mev.co.uk>
Date: Tue, 14 Jan 2014 11:50:16 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] Staging: comedi: remove unnecessary braces in pcl711.c
References: <1389669196-15041-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1389669196-15041-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-14 03:13, Chase Southwood wrote:
> This patch for pcl711.c removes braces causing a checkpatch.pl warning.
> It also removes an empty else arm of an if-else statement.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
>
> I removed the "else" arm of this statement because it was empty, save for the "ignore" comment.  If it is instead preferred kernel style for this empty else to remain in, let me know and I will correct this patch accordingly.
>
>   drivers/staging/comedi/drivers/pcl711.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/pcl711.c b/drivers/staging/comedi/drivers/pcl711.c
> index f0fc123..6595788 100644
> --- a/drivers/staging/comedi/drivers/pcl711.c
> +++ b/drivers/staging/comedi/drivers/pcl711.c
> @@ -336,11 +336,8 @@ static int pcl711_ai_cmdtest(struct comedi_device *dev,
>   	err |= cfc_check_trigger_arg_is(&cmd->convert_arg, 0);
>   	err |= cfc_check_trigger_arg_is(&cmd->scan_end_arg, cmd->chanlist_len);
>
> -	if (cmd->stop_src == TRIG_NONE) {
> +	if (cmd->stop_src == TRIG_NONE)
>   		err |= cfc_check_trigger_arg_is(&cmd->stop_arg, 0);
> -	} else {
> -		/* ignore */
> -	}
>
>   	if (err)
>   		return 3;
>

Not sure if it's worth me reviewing these minor clean-up patches or not, 
but FWIW I approve of this patch.

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
