Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936231Ab3DIOMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:12:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:22959 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761568Ab3DIOMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:12:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,439,1363158000"; 
   d="scan'208";a="292363063"
From: Jani Nikula <jani.nikula@intel.com>
To: Josh Boyer <jwboyer@redhat.com>, gregkh@linuxfoundation.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.8.y] drm/i915: add quirk to invert brightness on eMachines e725
In-Reply-To: <20130409123833.GC32476@hansolo.jdub.homelinux.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20130409123833.GC32476@hansolo.jdub.homelinux.org>
User-Agent: Notmuch/0.15.2+76~g76bbe24 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 09 Apr 2013 17:12:18 +0300
Message-ID: <87y5crpzct.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Apr 2013, Josh Boyer <jwboyer@redhat.com> wrote:
> Upstream commit 01e3a8feb40e54b962a20fa7eb595c5efef5e109

This patch seems to be the above commit and

commit 1ffff60320879830e469e26062c18f75236822ba
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Tue Jan 22 12:50:34 2013 +0200

    drm/i915: add quirk to invert brightness on eMachines G725

squashed together. There's a separate bug for that too:
https://bugs.freedesktop.org/show_bug.cgi?id=59628

I think both are okay for stable, but by the stable rules you should
probably split this up, with the appropriate upstream references in
both. Or do whatever the stable team tells you to do. ;)

BR,
Jani.

>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=31522#c35
> [Note: There are more than one broken setups in the bug. This fixes one.]
> Reported-by: Martins <andrissr@inbox.lv>
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>  drivers/gpu/drm/i915/intel_display.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index e6e4df7..6292677 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -8899,6 +8899,12 @@ static struct intel_quirk intel_quirks[] = {
>  	/* Acer Aspire 5734Z must invert backlight brightness */
>  	{ 0x2a42, 0x1025, 0x0459, quirk_invert_brightness },
>  
> +	/* Acer/eMachines G725 */
> +	{ 0x2a42, 0x1025, 0x0210, quirk_invert_brightness },
> +
> +	/* Acer/eMachines e725 */
> +	{ 0x2a42, 0x1025, 0x0212, quirk_invert_brightness },
> +
>  	/* Acer Aspire 4736Z */
>  	{ 0x2a42, 0x1025, 0x0260, quirk_invert_brightness },
>  };
> -- 
> 1.8.1.4
