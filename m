Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237AbaHaJHo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 05:07:44 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47432 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaHaJHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 05:07:40 -0400
Message-ID: <5402E5D8.6080401@gmail.com>
Date: Sun, 31 Aug 2014 21:07:36 +1200
From: Michael Schmitz <schmitzmic@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux ppc; en-US; rv:1.8.1.4) Gecko/20070509 Iceape/1.1.2 (Debian-1.1.2-1)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-m68k@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k/atari: Remove obsolete keyboard_tasklet scheduling
References: <1409328896-8457-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1409328896-8457-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert
> If CONFIG_VT=n:
>
> arch/m68k/atari/built-in.o: In function `atari_keyboard_interrupt':
> atakeyb.c:(.text+0x1846): undefined reference to `keyboard_tasklet'
> atakeyb.c:(.text+0x1852): undefined reference to `keyboard_tasklet'
>   

Has keyboard_tasklet gone for good, or just been conditionalized on 
CONFIG_VT?

> I think the keyboard_tasklet scheduling is no longer needed, as I
> believe it's handled by drivers/tty/vt/keyboard.c based on events
> received from the input subsystem. So just remove it.
>   

I'd like to test this on real hardware (though ARAnyM does emulate the 
keyboard ACIA IIRC - if you had a working keyboard there I should find 
no different),

Cheers,

    Michael


> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> Not tested on real hardware. ARAnyM doesn't have keyboard LEDs.
>
>  arch/m68k/atari/atakeyb.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/m68k/atari/atakeyb.c b/arch/m68k/atari/atakeyb.c
> index 95022b04b62d..1e2be1d34635 100644
> --- a/arch/m68k/atari/atakeyb.c
> +++ b/arch/m68k/atari/atakeyb.c
> @@ -170,7 +170,6 @@ repeat:
>  	if (acia_stat & ACIA_RDRF) {
>  		/* received a character */
>  		scancode = acia.key_data;	/* get it or reset the ACIA, I'll get it! */
> -		tasklet_schedule(&keyboard_tasklet);
>  	interpret_scancode:
>  		switch (kb_state.state) {
>  		case KEYBOARD:
>   

