Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab3INMQz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 08:16:55 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:46539 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab3INMQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 08:16:53 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Benson Leung <bleung@chromium.org>
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, david@protonic.nl, dianders@chromium.org
Subject: Re: [PATCH] Input: gpio_keys - wakeup_trigger
Date: Sat, 14 Sep 2013 14:16:47 +0200
Message-ID: <106090496.3hTZTLSVzK@flatron>
User-Agent: KMail/4.11.1 (Linux/3.10.10-gentoo; KDE/4.11.1; x86_64; ; )
In-Reply-To: <1379109160-32437-1-git-send-email-bleung@chromium.org>
References: <1379109160-32437-1-git-send-email-bleung@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benson,

On Friday 13 of September 2013 14:52:40 Benson Leung wrote:
> Allow wakeup_trigger to be defined per gpio button. Currently, all
> gpio buttons are set up as IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING.
> It may be more appropriate to only wake the system on one edge, for
> example if the gpio is for a Lid Switch.
> 
> Signed-off-by: Benson Leung <bleung@chromium.org>
> ---
>  .../devicetree/bindings/gpio/gpio_keys.txt         |  7 +++++++
>  drivers/input/keyboard/gpio_keys.c                 | 23
> ++++++++++++++++++++-- include/linux/gpio_keys.h                       
>   |  3 +++
>  3 files changed, 31 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/gpio/gpio_keys.txt
> b/Documentation/devicetree/bindings/gpio/gpio_keys.txt index
> 5c2c021..243f569 100644
> --- a/Documentation/devicetree/bindings/gpio/gpio_keys.txt
> +++ b/Documentation/devicetree/bindings/gpio/gpio_keys.txt
> @@ -20,6 +20,13 @@ Optional subnode-properties:
>  	- debounce-interval: Debouncing interval time in milliseconds.
>  	  If not specified defaults to 5.
>  	- gpio-key,wakeup: Boolean, button can wake-up the system.
> +	- gpio-key,wakeup-trigger : Specifies the type of wakeup behavior.
> +	  <1> == Rising Edge Trigger
> +	  <2> == Falling Edge Trigger
> +	  <3> == Both Rising and Falling Edge Trigger
> +	  <4> == Level High Trigger
> +	  <8> == Level Low Trigger
> +	  If not specified, defaults to <3> == Both Rising and Falling.

I don't like two things in this patch.

First is that this looks completely like a configuration option, not 
hardware description, so it's not something that should be put into DT. 
Especially that users might want to use another wake-up trigger depending 
on their use cases. I'd rather see this as a sysfs entry.

Another thing is that this driver assumes that key events are indicated by 
edges on the GPIO line, so I don't think level trigger setting make any 
sense here. I'd rather allow three settings here (through a sysfs knob) - 
key down, key up, key down or up.

Best regards,
Tomasz

