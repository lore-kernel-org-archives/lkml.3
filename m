Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbbAQPNW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 10:13:22 -0500
Received: from smtp206.alice.it ([82.57.200.102]:1219 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbbAQPNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 10:13:20 -0500
Date: Sat, 17 Jan 2015 16:13:16 +0100
From: Antonio Ospite <ao2@ao2.it>
To: Shailendra Verma <shailendra.capricorn@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] Fixed indentation violation in switch statement :
 Aligned the "switch" and its subordinate "case" labels in the same column
 instead of "double-intending" the "case" labels.
Message-Id: <20150117161316.66645bebb64e7f46218d7daa@ao2.it>
In-Reply-To: <1421495625-21558-1-git-send-email-shailendra.capricorn@gmail.com>
References: <1421495625-21558-1-git-send-email-shailendra.capricorn@gmail.com>
X-Mailer: Sylpheed 3.5.0beta1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Jan 2015 17:23:45 +0530
Shailendra Verma <shailendra.capricorn@gmail.com> wrote:

> 
> Signed-off-by: Shailendra Verma <shailendra.capricorn@gmail.com>
> ---
>  drivers/input/evdev.c    |   30 ++++++++++++++++++++----------
>  drivers/input/mousedev.c |   18 ++++++++++++------
>  2 files changed, 32 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index 18d4b2c..85ee594 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -667,16 +667,26 @@ static int handle_eviocgbit(struct input_dev *dev,
>  
>  	switch (type) {
>  
> -	case      0: bits = dev->evbit;  len = EV_MAX;  break;
> -	case EV_KEY: bits = dev->keybit; len = KEY_MAX; break;
> -	case EV_REL: bits = dev->relbit; len = REL_MAX; break;
> -	case EV_ABS: bits = dev->absbit; len = ABS_MAX; break;
> -	case EV_MSC: bits = dev->mscbit; len = MSC_MAX; break;
> -	case EV_LED: bits = dev->ledbit; len = LED_MAX; break;
> -	case EV_SND: bits = dev->sndbit; len = SND_MAX; break;
> -	case EV_FF:  bits = dev->ffbit;  len = FF_MAX;  break;
> -	case EV_SW:  bits = dev->swbit;  len = SW_MAX;  break;
> -	default: return -EINVAL;

I have the feeling this formatting was deliberate, to make comparing the
lines easier, see the alignment after colons and semicolons.

> +	case      0:
> +		bits = dev->evbit;  len = EV_MAX;  break;
> +	case EV_KEY:
> +		bits = dev->keybit; len = KEY_MAX; break;
> +	case EV_REL:
> +		bits = dev->relbit; len = REL_MAX; break;
> +	case EV_ABS:
> +		bits = dev->absbit; len = ABS_MAX; break;
> +	case EV_MSC:
> +		bits = dev->mscbit; len = MSC_MAX; break;
> +	case EV_LED:
> +		bits = dev->ledbit; len = LED_MAX; break;
> +	case EV_SND:
> +		bits = dev->sndbit; len = SND_MAX; break;
> +	case EV_FF:
> +		bits = dev->ffbit;  len = FF_MAX;  break;
> +	case EV_SW:
> +		bits = dev->swbit;  len = SW_MAX;  break;
> +	default:
> +		return -EINVAL;
>  	}
>

Now, this is a mixed style, multiple statements are still on the same
line which is also somewhat against the code style.

FWIW I'd leave the code current code untouched.

>  	return bits_to_user(bits, len, size, p, compat_mode);
> diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
> index b604564..a9857dd 100644
> --- a/drivers/input/mousedev.c
> +++ b/drivers/input/mousedev.c
> @@ -230,25 +230,31 @@ static void mousedev_key_event(struct mousedev *mousedev,
>  
>  	case BTN_TOUCH:
>  	case BTN_0:
> -	case BTN_LEFT:		index = 0; break;
> +	case BTN_LEFT:
> +		index = 0; break;
>

This makes more sense indeed but the break is still on the same line of
the assignment, if you change the style fix it for good and put the
break on its own line.

>  	case BTN_STYLUS:
>  	case BTN_1:
> -	case BTN_RIGHT:		index = 1; break;
> +	case BTN_RIGHT:
> +		index = 1; break;
>  
>  	case BTN_2:
>  	case BTN_FORWARD:
>  	case BTN_STYLUS2:
> -	case BTN_MIDDLE:	index = 2; break;
> +	case BTN_MIDDLE:
> +		index = 2; break;
>  
>  	case BTN_3:
>  	case BTN_BACK:
> -	case BTN_SIDE:		index = 3; break;
> +	case BTN_SIDE:
> +		index = 3; break;
>  
>  	case BTN_4:
> -	case BTN_EXTRA:		index = 4; break;
> +	case BTN_EXTRA:
> +		index = 4; break;
>  
> -	default:		return;
> +	default:
> +		return;
>  	}
>  
>  	if (value) {
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
