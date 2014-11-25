Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaKYUkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:40:03 -0500
Received: from smtp-out-210.synserver.de ([212.40.185.210]:1034 "EHLO
	smtp-out-210.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaKYUkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:40:00 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 14617
Message-ID: <5474E91E.6000401@metafoo.de>
Date: Tue, 25 Nov 2014 21:39:58 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, broonie@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: provide dummy regmap_exit()
References: <1416946910-23329-1-git-send-email-olof@lixom.net>
In-Reply-To: <1416946910-23329-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 09:21 PM, Olof Johansson wrote:
> Fixes build error:
>
> sound/soc/soc-core.c: In function 'snd_soc_component_exit_regmap':
> sound/soc/soc-core.c:2644:2: error: implicit declaration of function 'regmap_exit' [-Werror=implicit-function-declaration]
>    regmap_exit(component->regmap);
>
> Due to the other regmap functions providing appropriate stubs when
> !CONFIG_REGMAP, but this one is missing. Add it.
>
> Signed-off-by: Olof Johansson <olof@lixom.net>

I did a different patch for this I was just about to send. This looks good 
as well I guess, but ...

> ---
>   include/linux/regmap.h |    5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/include/linux/regmap.h b/include/linux/regmap.h
> index 4419b99..efb58a0 100644
> --- a/include/linux/regmap.h
> +++ b/include/linux/regmap.h
> @@ -737,6 +737,11 @@ static inline struct regmap *dev_get_regmap(struct device *dev,
>   	return NULL;
>   }
>
> +static inline void regmap_exit(struct regmap *map)
> +{
> +	return;

... but we really don't need the return here.

> +}
> +
>   static inline struct device *regmap_get_device(struct regmap *map)
>   {
>   	WARN_ONCE(1, "regmap API is disabled");
>

