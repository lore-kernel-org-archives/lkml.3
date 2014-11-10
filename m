Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaKJHH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 02:07:56 -0500
Received: from smtp-out-039.synserver.de ([212.40.185.39]:1095 "EHLO
	smtp-out-039.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaKJHHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 02:07:54 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 16960
Message-ID: <54606446.7030907@metafoo.de>
Date: Mon, 10 Nov 2014 08:07:50 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>, Mark Brown <broonie@kernel.org>
CC: Mark Rutland <mark.rutland@arm.com>,
        GTA04 owners <gta04-owner@goldelico.com>, alsa-devel@alsa-project.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [alsa-devel] [PATCH 1/3] ASoC: twl4030: don't report EBUSY if
 no change requested.
References: <20141108002637.6561.19002.stgit@notabene.brown> <20141108003803.6561.42934.stgit@notabene.brown> <20141108092242.GB2722@sirena.org.uk> <20141110114518.715dcd4e@notabene.brown>
In-Reply-To: <20141110114518.715dcd4e@notabene.brown>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 01:45 AM, NeilBrown wrote:
> diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
> index b6b0cb399599..613b61cee081 100644
> --- a/sound/soc/codecs/twl4030.c
> +++ b/sound/soc/codecs/twl4030.c
> @@ -957,6 +957,16 @@ static int snd_soc_put_twl4030_opmode_enum_double(struct snd_kcontrol *kcontrol,
>   {
>   	struct snd_soc_codec *codec = snd_soc_kcontrol_codec(kcontrol);
>   	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
> +	struct snd_ctl_elem_value currentval;
>

snd_ctl_elem_value is a bit to big to be put onto the kernel stack. Just 
using twl4030_read() should be fine.
