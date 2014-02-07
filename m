Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaBGRXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:23:11 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:33536 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaBGRXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:23:08 -0500
X-Originating-IP: 50.43.14.201
Date: Fri, 7 Feb 2014 09:22:58 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/3] sound: Remove unused function in
 pci/lx6464es/lx_core.c
Message-ID: <20140207172258.GC7298@jtriplet-mobl1>
References: <512472c7d96cf1c239ba3d0bc517891a7c2f9da1.1391791103.git.rashika.kheria@gmail.com>
 <099f48122fb7ac04f0224f76ed1a9d6e6ef8652d.1391791103.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <099f48122fb7ac04f0224f76ed1a9d6e6ef8652d.1391791103.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 10:14:03PM +0530, Rashika Kheria wrote:
> Remove unused function in pci/lx6464es/lx_core.c.
> 
> This eliminates the following warning in pci/lx6464es/lx_core.c:
> sound/pci/lx6464es/lx_core.c:144:5: warning: no previous prototype for ‘lx_plx_mbox_read’ [-Wmissing-prototypes]
> sound/pci/lx6464es/lx_core.c:172:5: warning: no previous prototype for ‘lx_plx_mbox_write’ [-Wmissing-prototypes]
> sound/pci/lx6464es/lx_core.c:494:5: warning: no previous prototype for ‘lx_dsp_es_check_pipeline’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  sound/pci/lx6464es/lx_core.c |   84 ------------------------------------------
>  1 file changed, 84 deletions(-)
> 
> diff --git a/sound/pci/lx6464es/lx_core.c b/sound/pci/lx6464es/lx_core.c
> index 626ecad..df4044d 100644
> --- a/sound/pci/lx6464es/lx_core.c
> +++ b/sound/pci/lx6464es/lx_core.c
> @@ -141,63 +141,6 @@ void lx_plx_reg_write(struct lx6464es *chip, int port, u32 data)
>  	iowrite32(data, address);
>  }
>  
> -u32 lx_plx_mbox_read(struct lx6464es *chip, int mbox_nr)
> -{
> -	int index;
> -
> -	switch (mbox_nr) {
> -	case 1:
> -		index = ePLX_MBOX1;    break;
> -	case 2:
> -		index = ePLX_MBOX2;    break;
> -	case 3:
> -		index = ePLX_MBOX3;    break;
> -	case 4:
> -		index = ePLX_MBOX4;    break;
> -	case 5:
> -		index = ePLX_MBOX5;    break;
> -	case 6:
> -		index = ePLX_MBOX6;    break;
> -	case 7:
> -		index = ePLX_MBOX7;    break;
> -	case 0:			/* reserved for HF flags */
> -		snd_BUG();
> -	default:
> -		return 0xdeadbeef;
> -	}
> -
> -	return lx_plx_reg_read(chip, index);
> -}
> -
> -int lx_plx_mbox_write(struct lx6464es *chip, int mbox_nr, u32 value)
> -{
> -	int index = -1;
> -
> -	switch (mbox_nr) {
> -	case 1:
> -		index = ePLX_MBOX1;    break;
> -	case 3:
> -		index = ePLX_MBOX3;    break;
> -	case 4:
> -		index = ePLX_MBOX4;    break;
> -	case 5:
> -		index = ePLX_MBOX5;    break;
> -	case 6:
> -		index = ePLX_MBOX6;    break;
> -	case 7:
> -		index = ePLX_MBOX7;    break;
> -	case 0:			/* reserved for HF flags */
> -	case 2:			/* reserved for Pipe States
> -				 * the DSP keeps an image of it */
> -		snd_BUG();
> -		return -EBADRQC;
> -	}
> -
> -	lx_plx_reg_write(chip, index, value);
> -	return 0;
> -}
> -
> -
>  /* rmh */
>  
>  #ifdef CONFIG_SND_DEBUG
> @@ -491,33 +434,6 @@ int lx_dsp_read_async_events(struct lx6464es *chip, u32 *data)
>  #define CSES_BROADCAST      0x0002
>  #define CSES_UPDATE_LDSV    0x0004
>  
> -int lx_dsp_es_check_pipeline(struct lx6464es *chip)
> -{
> -	int i;
> -
> -	for (i = 0; i != CSES_TIMEOUT; ++i) {
> -		/*
> -		 * le bit CSES_UPDATE_LDSV est Ã  1 dÃ©s que le macprog
> -		 * est pret. il re-passe Ã  0 lorsque le premier read a
> -		 * Ã©tÃ© fait. pour l'instant on retire le test car ce bit
> -		 * passe a 1 environ 200 Ã  400 ms aprÃ©s que le registre
> -		 * confES Ã  Ã©tÃ© Ã©crit (kick du xilinx ES).
> -		 *
> -		 * On ne teste que le bit CE.
> -		 * */
> -
> -		u32 cses = lx_dsp_reg_read(chip, eReg_CSES);
> -
> -		if ((cses & CSES_CE) == 0)
> -			return 0;
> -
> -		udelay(1);
> -	}
> -
> -	return -ETIMEDOUT;
> -}
> -
> -
>  #define PIPE_INFO_TO_CMD(capture, pipe)					\
>  	((u32)((u32)(pipe) | ((capture) ? ID_IS_CAPTURE : 0L)) << ID_OFFSET)
>  
> -- 
> 1.7.9.5
> 
