Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab3JNIxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:53:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54598 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab3JNIxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:53:16 -0400
Date: Mon, 14 Oct 2013 10:53:08 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Felipe Pena <felipensp@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Markus Pargmann <mpa@pengutronix.de>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v2] sound: soc: fsl: Fix memory leak in
 imx-audmux.c
Message-ID: <20131014085308.GZ30088@pengutronix.de>
References: <1381617306-18764-1-git-send-email-felipensp@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381617306-18764-1-git-send-email-felipensp@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:52:05 up 50 days, 18:22, 37 users,  load average: 0.03, 0.06,
 0.14
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 07:35:06PM -0300, Felipe Pena wrote:
> When audmux_clk is used and clk_prepare_enable function succeed,
> the memory alloc'd to buf variable is leaked
> 
> Signed-off-by: Felipe Pena <felipensp@gmail.com>

Looks good.

Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>

If you send a v2 please next time also write what changed to the
previous version.

Sascha

> ---
>  sound/soc/fsl/imx-audmux.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/sound/soc/fsl/imx-audmux.c b/sound/soc/fsl/imx-audmux.c
> index d3bf71a..ac86993 100644
> --- a/sound/soc/fsl/imx-audmux.c
> +++ b/sound/soc/fsl/imx-audmux.c
> @@ -66,13 +66,10 @@ static ssize_t audmux_read_file(struct file *file, char __user *user_buf,
>  				size_t count, loff_t *ppos)
>  {
>  	ssize_t ret;
> -	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	char *buf;
>  	int port = (int)file->private_data;
>  	u32 pdcr, ptcr;
>  
> -	if (!buf)
> -		return -ENOMEM;
> -
>  	if (audmux_clk) {
>  		ret = clk_prepare_enable(audmux_clk);
>  		if (ret)
> @@ -85,6 +82,10 @@ static ssize_t audmux_read_file(struct file *file, char __user *user_buf,
>  	if (audmux_clk)
>  		clk_disable_unprepare(audmux_clk);
>  
> +	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
>  	ret = snprintf(buf, PAGE_SIZE, "PDCR: %08x\nPTCR: %08x\n",
>  		       pdcr, ptcr);
>  
> -- 
> 1.7.10.4
> 
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
