Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168AbaESFkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 01:40:09 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:56343 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaESFkH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 01:40:07 -0400
Date: Mon, 19 May 2014 07:39:47 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
        Sangbeom Kim <sbkim73@samsung.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Fix for possible null pointer dereference in dma.c
Message-ID: <20140519073947.66bb2c46@ipc1.ka-ro>
In-Reply-To: <1400191076-28279-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1400191076-28279-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Rickard Strandqvist wrote:
> There is otherwise a risk of a possible null pointer dereference.
> 
> Was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  sound/soc/samsung/dma.c |   10 ++++++----
>  1 fil ändrad, 6 tillägg(+), 4 borttagningar(-)
> 
> diff --git a/sound/soc/samsung/dma.c b/sound/soc/samsung/dma.c
> index dc09b71..b1f6757 100644
> --- a/sound/soc/samsung/dma.c
> +++ b/sound/soc/samsung/dma.c
> @@ -115,17 +115,19 @@ static void dma_enqueue(struct snd_pcm_substream *substream)
>  static void audio_buffdone(void *data)
>  {
>  	struct snd_pcm_substream *substream = data;
> -	struct runtime_data *prtd = substream->runtime->private_data;
> +	struct runtime_data *prtd = NULL;
>  
>  	pr_debug("Entered %s\n", __func__);
>  
> -	if (prtd->state & ST_RUNNING) {
> +	if(substream)
>
Missing space.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
