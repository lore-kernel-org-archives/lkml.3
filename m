Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaKCKeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:34:25 -0500
Received: from mga14.intel.com ([192.55.52.115]:55158 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaKCKeY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:34:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,307,1413270000"; 
   d="scan'208";a="615933691"
From: Jani Nikula <jani.nikula@intel.com>
To: Ortwin =?utf-8?Q?Gl=C3=BCck?= <odi@odi.ch>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-gfx\@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
Subject: Re: [drm] 3.18 regression: backlight dark after resume
In-Reply-To: <5454E2F3.2060404@odi.ch>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <5454E2F3.2060404@odi.ch>
User-Agent: Notmuch/0.18.2+151~g6d88668 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 03 Nov 2014 12:34:15 +0200
Message-ID: <87wq7ch8t4.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Nov 2014, Ortwin Glück <odi@odi.ch> wrote:
> Hi,
>
> Since 3.18-rc1 backlight is dark after resume from suspend. This is on a Samsung 
> laptop with i5 IvyBridge
>
> 00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core processor 
> Graphics Controller (rev 09)
>
>
> I have bisected this problem to the following commit:
> 73580fb764c4213d305c0d36bd8f856ae631eb42 is the first bad commit
> commit 73580fb764c4213d305c0d36bd8f856ae631eb42
> Author: Jani Nikula <jani.nikula@intel.com>
> Date:   Tue Aug 12 17:11:41 2014 +0300
>
>      drm/i915/dp: make backlight bl_power control power sequencer backlight
>
>      This lets the userspace switch off the backlight using the backlight
>      class sysfs bl_power file. The switch is done using the power sequencer;
>      the backlight PWM, and everything else, remains enabled. The display
>      backlight won't draw power, but for maximum power savings the encoder
>      needs to be switched off.
>
>      Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>      Reviewed_by: Clinton Taylor <Clinton.A.Taylor@intel.com>
>      Tested_by: Clinton Taylor <Clinton.A.Taylor@intel.com>
>      Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

See https://bugs.freedesktop.org/show_bug.cgi?id=80773 (please ignore
comments up to #10 or so).

Please attach dmesg with drm.debug=14 module parameter set, from boot to
suspend/resume and the problem, running the debug patch from comment
#18. Preferrably please attach the dmesg on the bug to keep everything
in one place.

Thanks,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
