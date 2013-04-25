Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab3DYP6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 11:58:18 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:34614 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab3DYP6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 11:58:17 -0400
Message-ID: <5179526B.9030307@iki.fi>
Date: Thu, 25 Apr 2013 18:57:31 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [media] anysee: Initialize ret = 0 in anysee_frontend_attach()
References: <1366803406-17738-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1366803406-17738-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 82.128.187.254
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2013 02:36 PM, Geert Uytterhoeven wrote:
> drivers/media/usb/dvb-usb-v2/anysee.c: In function ‘anysee_frontend_attach’:
> drivers/media/usb/dvb-usb-v2/anysee.c:641: warning: ‘ret’ may be used uninitialized in this function
>
> And gcc is right (see the ANYSEE_HW_507T case), so initialize ret to zero
> to fix this.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>


> ---
>   drivers/media/usb/dvb-usb-v2/anysee.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
> index a20d691..3a1f976 100644
> --- a/drivers/media/usb/dvb-usb-v2/anysee.c
> +++ b/drivers/media/usb/dvb-usb-v2/anysee.c
> @@ -638,7 +638,7 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
>   {
>   	struct anysee_state *state = adap_to_priv(adap);
>   	struct dvb_usb_device *d = adap_to_d(adap);
> -	int ret;
> +	int ret = 0;
>   	u8 tmp;
>   	struct i2c_msg msg[2] = {
>   		{
>


-- 
http://palosaari.fi/
