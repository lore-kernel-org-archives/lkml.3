Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaHKLJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:09:53 -0400
Received: from smtp-out-205.synserver.de ([212.40.185.205]:1045 "EHLO
	smtp-out-205.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaHKLJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:09:52 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 11193
Message-ID: <53E8A47A.4030808@metafoo.de>
Date: Mon, 11 Aug 2014 13:09:46 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: dapm: Fix uninitialized variable in snd_soc_dapm_get_enum_double()
References: <1407511775-26479-1-git-send-email-geert+renesas@glider.be>
In-Reply-To: <1407511775-26479-1-git-send-email-geert+renesas@glider.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 05:29 PM, Geert Uytterhoeven wrote:
> If soc_dapm_read() fails, reg_val will be uninitialized, and bogus
> values will be written later:
>
> sound/soc/soc-dapm.c: In function 'snd_soc_dapm_get_enum_double':
> sound/soc/soc-dapm.c:2862:15: warning: 'reg_val' may be used uninitialized in this function [-Wmaybe-uninitialized]
>    unsigned int reg_val, val;
>                 ^
>
> Return early on error to fix this.
>
> Introduced by commit ce0fc93ae56e2ba50ff8c220d69e4e860e889320 ("ASoC:
> Add DAPM support at the component level").
> ---
> Is this correct? Please review.

Yes, thanks.

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>


