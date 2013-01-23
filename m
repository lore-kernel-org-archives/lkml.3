Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab3AWPIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:08:20 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:41935 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab3AWPIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:08:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id
	:subject:from:to:cc:date:in-reply-to:references:content-type
	:mime-version:content-transfer-encoding; q=dns; s=sasl; b=mcULkj
	sllSXgOpv49SdFg8zw2Wdb1xSHIejqPtKMDkZlKjawl9Pv7YgQD5+wLNHmRp8hZp
	VKtWbtLbZ9ZL+qQr4JomNKhHm+CVcAMMf/8wGAdwutqCEYtVVrlgISjaxlDelE3G
	LPzAOPr19t/A8rtg6GiiK6cg5KinuVmeIaBig=
Message-ID: <1358953697.8899.2.camel@orca.stoopid.dyndns.org>
Subject: Re: [PATCH 1/2] leds-lp5521: fix a build warning
From: Nathan Lynch <ntl@pobox.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Bryan Wu <cooloney@gmail.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Jan 2013 09:08:17 -0600
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E1C27D@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E1C27D@DQHE02.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2 (3.6.2-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: B800CFBA-656E-11E2-B4DC-0A4F0E5B5709-04752483!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-23 at 08:07 +0000, Kim, Milo wrote:
> This patch removes a build warning below.(ARCH=x86_64)
> 
> drivers/leds/leds-lp5521.c: In function lp5521_firmware_loaded:
> drivers/leds/leds-lp5521.c:257:4: warning: format %d expects argument of type in
> t, but argument 3 has type size_t [-Wformat]
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/leds/leds-lp5521.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
> index 80adfb4..74946f4 100644
> --- a/drivers/leds/leds-lp5521.c
> +++ b/drivers/leds/leds-lp5521.c
> @@ -253,7 +253,7 @@ static void lp5521_firmware_loaded(struct lp55xx_chip *chip)
>  	const struct firmware *fw = chip->fw;
>  
>  	if (fw->size > LP5521_PROGRAM_LENGTH) {
> -		dev_err(&chip->cl->dev, "firmware data size overflow: %d\n",
> +		dev_err(&chip->cl->dev, "firmware data size overflow: %zd\n",
>  			fw->size);

Documentation/printk-formats.txt says %zu is to be used for size_t.

Same comment goes for patch 2/2.


