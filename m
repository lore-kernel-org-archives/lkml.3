Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaJAR54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:57:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:52414 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbaJAR5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:57:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,633,1406617200"; 
   d="scan'208";a="599433520"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, daniel.vetter@intel.com,
        intel-gfx@lists.freedesktop.org,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: randconfig build error with next-20141001, in drivers/gpu/drm/i915
In-Reply-To: <CA+r1ZhhmT4DrWtf6MbRQo5EqXwx+LxCqh15Vsu_d9WpftLhnxw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <CA+r1ZhhmT4DrWtf6MbRQo5EqXwx+LxCqh15Vsu_d9WpftLhnxw@mail.gmail.com>
User-Agent: Notmuch/0.18.1+110~gd9ec63c (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 01 Oct 2014 20:57:43 +0300
Message-ID: <87fvf73c6g.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Oct 2014, Jim Davis <jim.epost@gmail.com> wrote:
> Building with the attached random configuration file,
>
> warning: (VIDEO_TIMBERDALE) selects TIMB_DMA which has unmet direct
> dependencies (DMADEVICES && MFD_TIMBERDALE)
> warning: (USB_OTG_FSM && FSL_USB2_OTG && USB_MV_OTG) selects USB_OTG
> which has unmet direct dependencies (USB_SUPPORT && USB && PM_RUNTIME)
>
> drivers/built-in.o: In function `intel_panel_setup_backlight':
> (.text+0x11855d): undefined reference to `backlight_device_register'
> drivers/built-in.o: In function `intel_panel_destroy_backlight':
> (.text+0x118624): undefined reference to `backlight_device_unregister'
> make: *** [vmlinux] Error 1

It's the combination:

> CONFIG_DRM_I915=y
> CONFIG_BACKLIGHT_CLASS_DEVICE=m

Not sure what the Kconfig magic spell needs to be when we don't want to
depend on CONFIG_BACKLIGHT_CLASS_DEVICE but we'll use it if it's enabled
(y or m).

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
