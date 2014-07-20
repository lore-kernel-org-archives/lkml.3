Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750986AbaGTIBF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 04:01:05 -0400
Received: from smtp301.phy.lolipop.jp ([210.157.22.84]:52825 "EHLO
	smtp301.phy.lolipop.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbaGTIBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 04:01:03 -0400
X-Greylist: delayed 543 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jul 2014 04:01:03 EDT
Message-ID: <53CB7518.9080502@sakamocchi.jp>
Date: Sun, 20 Jul 2014 16:51:52 +0900
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: weiyj_lk@163.com, Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
CC: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] ALSA: bebob: Fix missing unlock on error in special_clk_ctl_put()
References: <1405831835-26499-1-git-send-email-weiyj_lk@163.com>
In-Reply-To: <1405831835-26499-1-git-send-email-weiyj_lk@163.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Wei,

Thanks for this patch, while I found the other issues in this file. I
would like to post new patches instead of yours, later.


Thanks

Takashi Sakamoto
o-takashi@sakamocchi.jp

(Jul 20 2014 13:50), weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Add the missing unlock before return from function
> special_clk_ctl_put() in the error handling case.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn> --- 
> sound/firewire/bebob/bebob_maudio.c | 4 +++- 1 file changed, 3
> insertions(+), 1 deletion(-)
> 
> diff --git a/sound/firewire/bebob/bebob_maudio.c
> b/sound/firewire/bebob/bebob_maudio.c index 6af50eb..6748515
> 100644 --- a/sound/firewire/bebob/bebob_maudio.c +++
> b/sound/firewire/bebob/bebob_maudio.c @@ -382,8 +382,10 @@ static
> int special_clk_ctl_put(struct snd_kcontrol *kctl, 
> mutex_lock(&bebob->mutex);
> 
> id = uval->value.enumerated.item[0]; -	if (id >=
> ARRAY_SIZE(special_clk_labels)) +	if (id >=
> ARRAY_SIZE(special_clk_labels)) { +		mutex_unlock(&bebob->mutex); 
> return 0; +	}
> 
> err = avc_maudio_set_special_clk(bebob, id, params->dig_in_fmt,
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTy3UIAAoJENbkvsBXhK8as9AH+wYN2lxFlzBdMhPgRigp/bkv
mw770Hpyb50TE3ILkIcGpgec1TFrK/QwQjUmunmJLQnvXPBNVNGiVaKsOhhHwmqG
7hDWp8swTSdxZQeSFWjjxAc+AntjEoUkOdiwclzT+1M1tO1vjZdRoXAos4o3G6Od
xKSl0xO4Qi+Wv6ib1p5yneOKEGZLmEZTLJY2PXXKhHQjybzYS1cRRlK9+afJYLhT
sEHPknz00OCbvFRAXIK0GMuaQzncZOFYA2Ovczei7Y+ugJuGJbvNfxhxYO6j7Zc6
j1dE79iBY0hhH32zdUn7zcWR8Zbxbpfv8oA0dkeQRisV3RB9F2P7bSKHtNj0cOw=
=Or5u
-----END PGP SIGNATURE-----
