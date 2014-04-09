Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920AbaDIK5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 06:57:39 -0400
Received: from smtp-out-069.synserver.de ([212.40.185.69]:1046 "EHLO
	smtp-out-115.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758311AbaDIK5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 06:57:38 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 12816
Message-ID: <5345279F.6070005@metafoo.de>
Date: Wed, 09 Apr 2014 12:57:35 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: core: Fix Sparse incompatible types warning
References: <1397028108-10976-1-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1397028108-10976-1-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 09:21 AM, Krzysztof Kozlowski wrote:
> Fix following Sparse warning:
> sound/soc/soc-core.c:252:20: error: incompatible types in comparison expression (different type sizes)
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>   sound/soc/soc-core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
> index 051c006281f5..41f6178249df 100644
> --- a/sound/soc/soc-core.c
> +++ b/sound/soc/soc-core.c
> @@ -249,7 +249,7 @@ static ssize_t codec_reg_write_file(struct file *file,
>   	struct snd_soc_codec *codec = file->private_data;
>   	int ret;
>
> -	buf_size = min(count, (sizeof(buf)-1));
> +	buf_size = min(count, (size_t)(sizeof(buf)-1));

But shouldn't the type of sizeof already be size_t?
