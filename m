Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaJTOM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:12:56 -0400
Received: from vader.hardeman.nu ([95.142.160.32]:34425 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbaJTOMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:12:55 -0400
To: Tomas Melin <tomas.melin@iki.fi>
Subject: Re: [PATCH 2/2] [media] rc-core: change =?UTF-8?Q?enabled=5Fproto?=  =?UTF-8?Q?col=20default=20setting?=
X-PHP-Originating-Script: 0:rcmail.php
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 20 Oct 2014 16:12:54 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: m.chehab@samsung.com, james.hogan@imgtec.com, a.seppala@gmail.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomas Melin <tomas.j.melin@gmail.com>
In-Reply-To: <1413714113-7456-2-git-send-email-tomas.melin@iki.fi>
References: <1413714113-7456-1-git-send-email-tomas.melin@iki.fi>
 <1413714113-7456-2-git-send-email-tomas.melin@iki.fi>
Message-ID: <5ee64319b16d00f8fb800607b1e304a1@hardeman.nu>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-19 12:21, Tomas Melin wrote:
> Change default setting for enabled protocols.
> Instead of enabling all protocols, disable all except lirc during 
> registration.
> Reduces overhead since all protocols not handled by default.
> Protocol to use will be enabled when keycode table is written by 
> userspace.

I can see the appeal in this, but now you've disabled automatic decoding 
for the protocol specified by the keymap for raw drivers? So this would 
also be a change, right?

I agree with Mauro that the "proper" long-term fix would be to teach the 
LIRC userspace daemon to enable the lirc protocol as/when necessary, but 
something similar to the patch below (but lirc + keymap protocol...if 
that's possible to implement in a non-intrusive manner, I haven't 
checked TBH) might be a good idea as an interim measure?


> 
> Signed-off-by: Tomas Melin <tomas.melin@iki.fi>
> ---
>  drivers/media/rc/rc-ir-raw.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/rc/rc-ir-raw.c 
> b/drivers/media/rc/rc-ir-raw.c
> index a118539..63d23d0 100644
> --- a/drivers/media/rc/rc-ir-raw.c
> +++ b/drivers/media/rc/rc-ir-raw.c
> @@ -256,7 +256,8 @@ int ir_raw_event_register(struct rc_dev *dev)
>  		return -ENOMEM;
> 
>  	dev->raw->dev = dev;
> -	dev->enabled_protocols = ~0;
> +	/* by default, disable all but lirc*/
> +	dev->enabled_protocols = RC_BIT_LIRC;
>  	rc = kfifo_alloc(&dev->raw->kfifo,
>  			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
>  			 GFP_KERNEL);
