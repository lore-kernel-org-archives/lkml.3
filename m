Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbaJ1Fbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 01:31:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40193 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaJ1Fbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 01:31:44 -0400
Date: Mon, 27 Oct 2014 22:31:40 -0700
From: Darren Hart <dvhart@infradead.org>
To: Frans Klaver <fransklaver@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] eeepc-laptop: document fan_pwm conversions
Message-ID: <20141028053134.GH60814@vmdeb7>
References: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
 <1414005163-3461-8-git-send-email-fransklaver@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414005163-3461-8-git-send-email-fransklaver@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 09:12:42PM +0200, Frans Klaver wrote:
> eeepc_get_fan_pwm and eeepc_set_fan_pwm convert the PWM value read from
> the fan to a range lmsensors understands. Unfortunately this is only
> clear if you are familiar with how lmsensors handles duty cycles.
> 
> Introduce two conversion functions that document the goal of these
> conversions.
> 
> Signed-off-by: Frans Klaver <fransklaver@gmail.com>
> ---
>  drivers/platform/x86/eeepc-laptop.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> index f820bb3..275a239 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -974,18 +974,28 @@ static struct platform_driver platform_driver = {
>  #define EEEPC_EC_SFB0      0xD0
>  #define EEEPC_EC_FAN_CTRL  (EEEPC_EC_SFB0 + 3) /* Byte containing SF25  */
>  
> +static inline int eeepc_pwm_to_lmsensors(int value)
> +{
> +	return value * 255 / 100;
> +}
> +
> +static inline int eeepc_lmsensors_to_pwm(int value)
> +{
> +	value = clamp_val(value, 0, 255);
> +	return value * 100 / 255;

Says the guy cleaning up all the magic numbers.... ;-)

But yeah, this is fine IMO. Applied.

-- 
Darren Hart
Intel Open Source Technology Center
