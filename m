Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbbAGH5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:57:11 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:34531 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbbAGH5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:57:08 -0500
Date: Tue, 6 Jan 2015 23:57:03 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Olliver Schinagl <oliver+list@schinagl.nl>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>, Olliver Schinagl <oliver@schinagl.nl>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] input: make use of the input_set_capability helper
Message-ID: <20150107075703.GE5256@dtor-ws>
References: <1420615866-3528-1-git-send-email-oliver+list@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420615866-3528-1-git-send-email-oliver+list@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olliver,

On Wed, Jan 07, 2015 at 08:31:06AM +0100, Olliver Schinagl wrote:
> From: Olliver Schinagl <oliver@schinagl.nl>
> 
> Almost all of the speaker drivers under input manipulate the ev bits
> directly, which is not needed, as there is a helper available.
> 
> This patch makes use of the helper for the speaker drivers.
> 
> Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
> ---
>  drivers/input/misc/cm109.c         | 4 ++--
>  drivers/input/misc/ixp4xx-beeper.c | 5 ++---
>  drivers/input/misc/m68kspkr.c      | 5 ++---
>  drivers/input/misc/pcspkr.c        | 5 ++---
>  drivers/input/misc/pwm-beeper.c    | 5 +----
>  drivers/input/misc/sparcspkr.c     | 6 ++----
>  6 files changed, 11 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/input/misc/cm109.c b/drivers/input/misc/cm109.c
> index 9365535..8e41070 100644
> --- a/drivers/input/misc/cm109.c
> +++ b/drivers/input/misc/cm109.c
> @@ -767,10 +767,10 @@ static int cm109_usb_probe(struct usb_interface *intf,
>  	input_dev->keycodesize = sizeof(unsigned char);
>  	input_dev->keycodemax = ARRAY_SIZE(dev->keymap);
>  
> -	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_SND);
> -	input_dev->sndbit[0] = BIT_MASK(SND_BELL) | BIT_MASK(SND_TONE);
> +	input_set_capability(input_dev, EV_SND, SND_BELL | SND_TONE);

No, input_set_capability() takes single event code, not bitmask. The
fact that it works for these 2 values of SND events is pure coincidence
(the old code wasn't much better though).

>  
>  	/* register available key events */
> +	input_dev->evbit[0] = BIT_MASK(EV_KEY);

Would prefer __set_bit(EV_KEY, input_dev->evbit); here instead.

Thanks.

-- 
Dmitry
