Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbbAIIUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 03:20:52 -0500
Received: from mga03.intel.com ([134.134.136.65]:59606 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbbAIIUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 03:20:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,729,1413270000"; 
   d="scan'208";a="659185403"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Jeremiah Mahler <jmmahler@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] drm/i915: backlight off after resume
In-Reply-To: <20150109040647.GA1355@hudson.localdomain>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20150109040647.GA1355@hudson.localdomain>
User-Agent: Notmuch/0.19~rc1+1~g08b4944 (http://notmuchmail.org) Emacs/24.4.1 (x86_64-pc-linux-gnu)
Date: Fri, 09 Jan 2015 10:21:26 +0200
Message-ID: <87fvbkz7nd.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Jan 2015, Jeremiah Mahler <jmmahler@gmail.com> wrote:
> Jani, all,
>
> On a Lenovo X1 Carbon if the display is off when suspend is entered
> it will be off when it is resumed.  A key must be pressed to restore
> normal brightness.

Please file a bug on [1] and attach dmesg with drm.debug=14 set, from
boot to reproducing the problem.

Thanks for the report.

BR,
Jani.


[1] https://bugs.freedesktop.org/enter_bug.cgi?product=DRI&component=DRM/Intel

>
>   xset dpms force off
>   sleep 1
>   sudo systemctl suspend
>   (resume)
>   (screen off, press any key)
>
> The behavior I am accustomed to is for it to resume with the screen on.
> All of my other machines behave this way and the X1 Carbon behaved this
> way in the past.
>
> I performed a bisect and found that the following commit introduced the
> problem.
>
>   From 6dda730e55f412a6dfb181cae6784822ba463847 Mon Sep 17 00:00:00 2001
>   From: Jani Nikula <jani.nikula@intel.com>
>   Date: Tue, 24 Jun 2014 18:27:40 +0300
>   Subject: [PATCH] drm/i915: respect the VBT minimum backlight brightness
>   
>   Historically we've exposed the full backlight PWM duty cycle range to
>   the userspace, in the name of "mechanism, not policy". However, it turns
>   out there are both panels and board designs where there is a minimum
>   duty cycle that is required for proper operation. The minimum duty cycle
>   is available in the VBT.
>   
>   The backlight class sysfs interface does not make any promises to the
>   userspace about the physical meaning of the range
>   0..max_brightness. Specifically there is no guarantee that 0 means off;
>   indeed for acpi_backlight 0 usually is not off, but the minimum
>   acceptable value.
>   
>   Respect the minimum backlight, and expose the range acceptable to the
>   hardware as 0..max_brightness to the userspace via the backlight class
>   device; 0 means the minimum acceptable enabled value. To switch off the
>   backlight, the user must disable the encoder.
>   
>   As a side effect, make the backlight class device max brightness and
>   physical PWM modulation frequency (i.e. max duty cycle)
>   independent. This allows a follow-up patch to virtualize the max value
>   exposed to the userspace.
>   
>   Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>   Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>   [danvet: s/BUG_ON/WARN_ON/]
>   Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>
> -- 
> - Jeremiah Mahler

-- 
Jani Nikula, Intel Open Source Technology Center
