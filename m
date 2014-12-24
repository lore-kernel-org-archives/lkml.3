Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbaLXAgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 19:36:33 -0500
Received: from regular1.263xmail.com ([211.150.99.135]:56779 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbaLXAgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 19:36:31 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: xjq@rock-chips.com
X-FST-TO: linux-arm-kernel@lists.infradead.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <539293d8a56c9e8666e792494c7c8ca5>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <549A0A83.7040606@rock-chips.com>
Date: Wed, 24 Dec 2014 08:36:19 +0800
From: Jianqun <xjq@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Dylan Reid <dgreid@chromium.org>, Jianqun Xu <jay.xu@rock-chips.com>
CC: xjq@rock-chips.com, Liam Girdwood <lgirdwood@gmail.com>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Mark Brown <broonie@kernel.org>, perex@perex.cz,
        Takashi Iwai <tiwai@suse.de>, Sonny Rao <sonnyrao@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [alsa-devel] [PATCH 2/2] ASoC: rockchip: i2s: set TDL and RDL
 to 16 bits
References: <1419325709-15374-1-git-send-email-jay.xu@rock-chips.com> <1419325709-15374-3-git-send-email-jay.xu@rock-chips.com> <CAEUnVG79MOHUufRnJVe98ZTC4vouUNAEWtPsryEKWLc+Qpdjuw@mail.gmail.com>
In-Reply-To: <CAEUnVG79MOHUufRnJVe98ZTC4vouUNAEWtPsryEKWLc+Qpdjuw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



在 12/24/2014 07:06 AM, Dylan Reid 写道:
> On Tue, Dec 23, 2014 at 1:08 AM, Jianqun Xu <jay.xu@rock-chips.com> wrote:
>> Set Transmit Data Level(TDL) and Receive Data Level(RDL) to 16 bits.
>> Without this setting, the TDL is default to be 0x00 (means 1 bit),
>> and the RDL is default to be 0x1f (means 16 bits).
> 
> My impression from the TRM was that TDL and RDL were measured in
> samples.  Are you sure it's 'bits'?
You are right, I'll modify the commit message next version, thank you
> 
>>
>> This patch is helpful to fix pop sound, tested on rk3288 board.
>>
>> Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
>> ---
>>  sound/soc/rockchip/rockchip_i2s.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
>> index c74ba37..1cd7efc 100644
>> --- a/sound/soc/rockchip/rockchip_i2s.c
>> +++ b/sound/soc/rockchip/rockchip_i2s.c
>> @@ -247,6 +247,10 @@ static int rockchip_i2s_hw_params(struct snd_pcm_substream *substream,
>>
>>         regmap_update_bits(i2s->regmap, I2S_TXCR, I2S_TXCR_VDW_MASK, val);
>>         regmap_update_bits(i2s->regmap, I2S_RXCR, I2S_RXCR_VDW_MASK, val);
>> +       regmap_update_bits(i2s->regmap, I2S_DMACR, I2S_DMACR_TDL_MASK,
>> +                          I2S_DMACR_TDL(16));
>> +       regmap_update_bits(i2s->regmap, I2S_DMACR, I2S_DMACR_RDL_MASK,
>> +                          I2S_DMACR_RDL(16));
>>
>>         return 0;
>>  }
>> --
>> 1.9.1
>>
>>
>> _______________________________________________
>> Alsa-devel mailing list
>> Alsa-devel@alsa-project.org
>> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
> 
> 
> 

-- 
Jianqun Xu

****************************************************************************
*IMPORTANT NOTICE:*This email is from Fuzhou Rockchip Electronics Co.,
Ltd .The contents of this email and any attachments may contain
information that is privileged, confidential and/or exempt from
disclosure under applicable law and relevant NDA. If you are not the
intended recipient, you are hereby notified that any disclosure,
copying, distribution, or use of the information is STRICTLY PROHIBITED.
Please immediately contact the sender as soon as possible and destroy
the material in its entirety in any format. Thank you.
****************************************************************************

