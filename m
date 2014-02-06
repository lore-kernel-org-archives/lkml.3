Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbaBFKuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 05:50:50 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:52964
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755706AbaBFKus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 05:50:48 -0500
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839h947hd25he5bhf0ah10d2h1288h12a5h12a9h12bdh137ah13b6h1441h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24d7h2516h2545h1155h)
Message-ID: <52F36713.1070107@analog.com>
Date: Thu, 6 Feb 2014 11:42:27 +0100
From: Michael Hennerich <michael.hennerich@analog.com>
Reply-To: <michael.hennerich@analog.com>
Organization: Analog Devices Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, "'Mike Frysinger'" <vapier@gentoo.org>
Subject: Re: [PATCH 03/12] backlight: adp8870: Remove unnecessary OOM messages
References: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com> <000401cf2313$f2297df0$d67c79d0$%han@samsung.com>
In-Reply-To: <000401cf2313$f2297df0$d67c79d0$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.44.2.88]
X-OriginatorOrg: analog.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 09:17 AM, Jingoo Han wrote:
> The site-specific OOM messages are unnecessary, because they
> duplicate the MM subsystem generic OOM message.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
> ---
>   drivers/video/backlight/adp8870_bl.c |    4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
> index 6370720..251af4d 100644
> --- a/drivers/video/backlight/adp8870_bl.c
> +++ b/drivers/video/backlight/adp8870_bl.c
> @@ -246,10 +246,8 @@ static int adp8870_led_probe(struct i2c_client *client)
>   
>   	led = devm_kzalloc(&client->dev, pdata->num_leds * sizeof(*led),
>   				GFP_KERNEL);
> -	if (led == NULL) {
> -		dev_err(&client->dev, "failed to alloc memory\n");
> +	if (led == NULL)
>   		return -ENOMEM;
> -	}
>   
>   	ret = adp8870_write(client, ADP8870_ISCLAW, pdata->led_fade_law);
>   	if (ret)


-- 
Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin,
Margaret Seif


