Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3KQNkx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 08:40:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab3KQNkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 08:40:45 -0500
Message-ID: <5288C74D.7070206@redhat.com>
Date: Sun, 17 Nov 2013 14:40:29 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] radio-shark: Mark shark_resume_leds() inline
 to kill compiler warning
References: <1382962565-1662-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1382962565-1662-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/28/2013 01:16 PM, Geert Uytterhoeven wrote:
> If SHARK_USE_LEDS=1, but CONFIG_PM=n:
>
> drivers/media/radio/radio-shark.c:275: warning: ‘shark_resume_leds’ defined but not used
>
> Instead of making the #ifdef logic even more complicated (there are already
> two definitions of shark_resume_leds()), mark shark_resume_leds() inline to
> kill the compiler warning. shark_resume_leds() is small and it has only one
> caller.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> {cris,m68k,parisc,sparc,xtensa}-all{mod,yes}config
>
>   drivers/media/radio/radio-shark.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/radio/radio-shark.c b/drivers/media/radio/radio-shark.c
> index b91477212413..050b3bb96fec 100644
> --- a/drivers/media/radio/radio-shark.c
> +++ b/drivers/media/radio/radio-shark.c
> @@ -271,7 +271,7 @@ static void shark_unregister_leds(struct shark_device *shark)
>   	cancel_work_sync(&shark->led_work);
>   }
>
> -static void shark_resume_leds(struct shark_device *shark)
> +static inline void shark_resume_leds(struct shark_device *shark)
>   {
>   	if (test_bit(BLUE_IS_PULSE, &shark->brightness_new))
>   		set_bit(BLUE_PULSE_LED, &shark->brightness_new);
>

Thanks for the patch. I've added this to my tree for 3.13 .

Regards,

Hans
