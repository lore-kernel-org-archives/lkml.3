Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab3IKVMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 17:12:22 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:50363 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab3IKVMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 17:12:21 -0400
Date: Wed, 11 Sep 2013 23:02:04 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Christopher Brannon <chris@the-brannons.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        w.d.hubbs@gmail.com, kirk@reisers.ca, dan.carpenter@oracle.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, raphael.scarv@gmail.com
Subject: Re: [PATCH] staging: speakup: kobjects.c: Use correct values when
 changing voice.
Message-ID: <20130911210204.GI17803@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Christopher Brannon <chris@the-brannons.com>,
	devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
	w.d.hubbs@gmail.com, kirk@reisers.ca, dan.carpenter@oracle.com,
	andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, raphael.scarv@gmail.com
References: <1378919127-28259-1-git-send-email-chris@the-brannons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1378919127-28259-1-git-send-email-chris@the-brannons.com>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christopher Brannon, le Wed 11 Sep 2013 10:05:27 -0700, a écrit :
> When a new voice is selected, we set volume and pitch appropriate for
> the voice.  We need to use the numeric index corresponding to the
> voice when indexing into the volume and pitch tables, rather than
> the raw user input that was used to select the voice.
> Note that using the raw input can also lead to an invalid memory read
> in the case of invalid or malicious user input.
> 
> Signed-off-by: Christopher Brannon <chris@the-brannons.com>

Acked-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

> ---
>  drivers/staging/speakup/kobjects.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/speakup/kobjects.c b/drivers/staging/speakup/kobjects.c
> index 61a3f7a..f31afa2 100644
> --- a/drivers/staging/speakup/kobjects.c
> +++ b/drivers/staging/speakup/kobjects.c
> @@ -651,7 +651,10 @@ ssize_t spk_var_store(struct kobject *kobj, struct kobj_attribute *attr,
>  		* If voice was just changed, we might need to reset our default
>  		* pitch and volume.
>  		*/
> -		if (param->var_id == VOICE) {
> +		if (param->var_id == VOICE && synth &&
> +		    (ret == 0 || ret == -ERESTART)) {
> +			var_data = param->data;
> +			value = var_data->u.n.value;
>  			spk_reset_default_value("pitch", synth->default_pitch,
>  				value);
>  			spk_reset_default_value("vol", synth->default_vol,
> -- 
> 1.8.1.5
> 

-- 
Samuel
Hi ! I'm a .signature virus ! Copy me into your ~/.signature, please !
