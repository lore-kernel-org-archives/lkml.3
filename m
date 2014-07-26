Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaGZP5w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 11:57:52 -0400
Received: from csmtp2.one.com ([91.198.169.22]:43207 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbaGZP5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 11:57:50 -0400
X-Greylist: delayed 538 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jul 2014 11:57:50 EDT
Message-ID: <53D3CE2E.3040103@bitmath.org>
Date: Sat, 26 Jul 2014 17:50:06 +0200
From: Henrik Rydberg <rydberg@bitmath.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
CC: Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Benson Leung <bleung@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: synaptics - properly initialize slots for semi-MT
References: <20140726002751.GA16660@core.coreip.homeip.net>
In-Reply-To: <20140726002751.GA16660@core.coreip.homeip.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 07/26/2014 02:27 AM, Dmitry Torokhov wrote:
> Semi-MT devices are pointers too, so let's tell that to
> input_mt_init_slots(), as well as let it set up the devices as semi-MT,
> instead of us doing it manually.
> 
> Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>
> Reviewed-by: Benson Leung <bleung@chromium.org>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/input/mouse/synaptics.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> index ef9e0b8..fe607e9 100644
> --- a/drivers/input/mouse/synaptics.c
> +++ b/drivers/input/mouse/synaptics.c
> @@ -1371,11 +1371,11 @@ static void set_input_params(struct psmouse *psmouse,
>  		__set_bit(BTN_TOOL_QUADTAP, dev->keybit);
>  		__set_bit(BTN_TOOL_QUINTTAP, dev->keybit);
>  	} else if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c)) {
> -		/* Non-image sensors with AGM use semi-mt */
> -		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
> -		input_mt_init_slots(dev, 2, 0);
>  		set_abs_position_params(dev, priv, ABS_MT_POSITION_X,
>  					ABS_MT_POSITION_Y);
> +		/* Non-image sensors with AGM use semi-mt */
> +		input_mt_init_slots(dev, 2,
> +				    INPUT_MT_POINTER | INPUT_MT_SEMI_MT);
>  	}

As long as DOUBLE_TAP is set unconditionally in this path anyways, it should be
ok. I have a vague memory of refraining from this exact change at some point,
because of the many branches of settings.

>  
>  	if (SYN_CAP_PALMDETECT(priv->capabilities))
> 

Henrik

