Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3L3KHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 05:07:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:42234 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab3L3KG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 05:06:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,573,1384329600"; 
   d="scan'208";a="459339469"
From: Jani Nikula <jani.nikula@intel.com>
To: Alexander van Heukelum <heukelum@fastmail.fm>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Ben Widawsky <ben@bwidawsk.net>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Dylan Borg <borgdylan@hotmail.com>
Subject: Re: [PATCH] Revert "drm/i915: assume all GM45 Acer laptops use inverted backlight PWM"
In-Reply-To: <1388260839-3873-2-git-send-email-heukelum@fastmail.fm>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1388260839-3873-1-git-send-email-heukelum@fastmail.fm> <1388260839-3873-2-git-send-email-heukelum@fastmail.fm>
User-Agent: Notmuch/0.17~rc2+18~gab1d8e867f4a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 30 Dec 2013 12:09:47 +0200
Message-ID: <87txdqk5uc.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ben, please pick this up for -fixes during Daniel's absense.

BR,
Jani.


On Sat, 28 Dec 2013, Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> My Acer 8510TZ stops displaying anything when X starts with Linus' current
> tree. I bisected it down to commit ee1452d74584.
>
> This patch reverts commit ee1452d74584.

commit ee1452d7458451a7508e0663553ce88d63958157
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Fri Sep 20 15:05:30 2013 +0300

    drm/i915: assume all GM45 Acer laptops use inverted backlight PWM

> After the revert, everything works as before.

Also

Reported-by: Dylan Borg <borgdylan@hotmail.com>

for Acer Extensa 5635Z.

> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

Signed-off-by: Jani Nikula <jani.nikula@intel.com>


>
> ---
>  drivers/gpu/drm/i915/intel_display.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 54e82a8..769b864 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -10541,11 +10541,20 @@ static struct intel_quirk intel_quirks[] = {
>  	/* Sony Vaio Y cannot use SSC on LVDS */
>  	{ 0x0046, 0x104d, 0x9076, quirk_ssc_force_disable },
>  
> -	/*
> -	 * All GM45 Acer (and its brands eMachines and Packard Bell) laptops
> -	 * seem to use inverted backlight PWM.
> -	 */
> -	{ 0x2a42, 0x1025, PCI_ANY_ID, quirk_invert_brightness },
> +	/* Acer Aspire 5734Z must invert backlight brightness */
> +	{ 0x2a42, 0x1025, 0x0459, quirk_invert_brightness },
> +
> +	/* Acer/eMachines G725 */
> +	{ 0x2a42, 0x1025, 0x0210, quirk_invert_brightness },
> +
> +	/* Acer/eMachines e725 */
> +	{ 0x2a42, 0x1025, 0x0212, quirk_invert_brightness },
> +
> +	/* Acer/Packard Bell NCL20 */
> +	{ 0x2a42, 0x1025, 0x034b, quirk_invert_brightness },
> +
> +	/* Acer Aspire 4736Z */
> +	{ 0x2a42, 0x1025, 0x0260, quirk_invert_brightness },
>  
>  	/* Dell XPS13 HD Sandy Bridge */
>  	{ 0x0116, 0x1028, 0x052e, quirk_no_pcm_pwm_enable },
> -- 
> 1.8.3.2
>

-- 
Jani Nikula, Intel Open Source Technology Center
