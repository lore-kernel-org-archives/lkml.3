Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab3KPQrw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 11:47:52 -0500
Received: from bitmer.com ([213.157.87.50]:47043 "EHLO bitmer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab3KPQrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 11:47:43 -0500
X-Greylist: delayed 2234 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Nov 2013 11:47:43 EST
Message-ID: <528798CF.4060609@bitmer.com>
Date: Sat, 16 Nov 2013 18:09:51 +0200
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>
CC: linux-omap@vger.kernel.org, linaro-networking@linaro.org,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 16/23] ASoC: omap: mcbsp, mcpdm, dmic: raw read and write
 endian fix
References: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org> <1384560086-11994-17-git-send-email-taras.kondratiuk@linaro.org>
In-Reply-To: <1384560086-11994-17-git-send-email-taras.kondratiuk@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2013 02:01 AM, Taras Kondratiuk wrote:
> From: Victor Kamensky <victor.kamensky@linaro.org>
> 
> All OMAP IP blocks expect LE data, but CPU may operate in BE mode.
> Need to use endian neutral functions to read/write h/w registers.
> I.e instead of __raw_read[lw] and __raw_write[lw] functions code
> need to use read[lw]_relaxed and write[lw]_relaxed functions.
> If the first simply reads/writes register, the second will byteswap
> it if host operates in BE mode.
> 
> Changes are trivial sed like replacement of __raw_xxx functions
> with xxx_relaxed variant.
> 
> Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
> Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
> ---
>  sound/soc/omap/mcbsp.c      |   12 ++++++------
>  sound/soc/omap/omap-dmic.c  |    4 ++--
>  sound/soc/omap/omap-mcpdm.c |    4 ++--
>  3 files changed, 10 insertions(+), 10 deletions(-)
> 
Looks ok to me by looking at the _relaxed definitions in
arch/arm/include/asm/io.h.

Acked-by: Jarkko Nikula <jarkko.nikula@bitmer.com>

