Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364Ab3BSNLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 08:11:11 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:18646
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757000Ab3BSNLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 08:11:10 -0500
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dhz2dh2a8h668h839h947hd25he5bhf0ah10d2h1288h12a5h12a9h12bdh137ah13b6h1441h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1155h)
Message-ID: <5123799C.1080901@analog.com>
Date: Tue, 19 Feb 2013 14:09:48 +0100
From: Michael Hennerich <michael.hennerich@analog.com>
Reply-To: <michael.hennerich@analog.com>
Organization: Analog Devices Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] backlight: adp8860/adp8870: Fix resume
References: <1361278925-11107-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1361278925-11107-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 02:02 PM, Lars-Peter Clausen wrote:
> Clearing the NSTBY bit in the control register also automatically clears the
> BLEN bit. So we need to make sure to set it again during resume, otherwise the
> backlight will stay off.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
> ---
>   drivers/video/backlight/adp8860_bl.c | 2 +-
>   drivers/video/backlight/adp8870_bl.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
> index 6bb72c0..a77c9ca 100644
> --- a/drivers/video/backlight/adp8860_bl.c
> +++ b/drivers/video/backlight/adp8860_bl.c
> @@ -783,7 +783,7 @@ static int adp8860_i2c_suspend(struct i2c_client *client, pm_message_t message)
>   
>   static int adp8860_i2c_resume(struct i2c_client *client)
>   {
> -	adp8860_set_bits(client, ADP8860_MDCR, NSTBY);
> +	adp8860_set_bits(client, ADP8860_MDCR, NSTBY | BLEN);
>   
>   	return 0;
>   }
> diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
> index 63c882b..712c25a 100644
> --- a/drivers/video/backlight/adp8870_bl.c
> +++ b/drivers/video/backlight/adp8870_bl.c
> @@ -957,7 +957,7 @@ static int adp8870_i2c_suspend(struct i2c_client *client, pm_message_t message)
>   
>   static int adp8870_i2c_resume(struct i2c_client *client)
>   {
> -	adp8870_set_bits(client, ADP8870_MDCR, NSTBY);
> +	adp8870_set_bits(client, ADP8870_MDCR, NSTBY | BLEN);
>   
>   	return 0;
>   }


-- 
Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin,
Margaret Seif


