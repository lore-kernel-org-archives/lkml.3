Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933994AbaHZIVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:21:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281AbaHZIVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:21:12 -0400
Message-ID: <53FC4366.7050600@redhat.com>
Date: Tue, 26 Aug 2014 10:20:54 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
CC: Yunkang Tang <yunkang.tang@cn.alps.com>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: ALPS - suppress message about 'Unknown touchpad'
References: <20140825183031.GA5151@core.coreip.homeip.net>
In-Reply-To: <20140825183031.GA5151@core.coreip.homeip.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/25/2014 08:30 PM, Dmitry Torokhov wrote:
> When we fail to match data returned by E7 and EC reports we state that we
> found "Unknown ALPS touchpad" whereas it is most likely it is not ALPS
> touchpad at all. Change wording a bit and reduce the message to debug so
> that it does not litter users logs and confuse them.
> 
> Reported-by: Paul Menzel <paulepanter@users.sourceforge.net>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

I noticed this too, and I agree that it is a confusing message:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans

> ---
>  drivers/input/mouse/alps.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
> index a59a1a6..a956b98 100644
> --- a/drivers/input/mouse/alps.c
> +++ b/drivers/input/mouse/alps.c
> @@ -2234,8 +2234,8 @@ static int alps_identify(struct psmouse *psmouse, struct alps_data *priv)
>  		return 0;
>  	}
>  
> -	psmouse_info(psmouse,
> -		     "Unknown ALPS touchpad: E7=%3ph, EC=%3ph\n", e7, ec);
> +	psmouse_dbg(psmouse,
> +		    "Likely not an ALPS touchpad: E7=%3ph, EC=%3ph\n", e7, ec);
>  
>  	return -EINVAL;
>  }
> 
