Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab3ECMDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 08:03:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:41732 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab3ECMDX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 08:03:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,604,1363158000"; 
   d="scan'208";a="236358527"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Daniel Vetter <daniel@ffwll.ch>, dl9pf@gmx.de
Cc: airlied@linux.ie, daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        pageexec@freemail.hu
Subject: Re: [Intel-gfx] [PATCH] [TRIVIAL] Fix declaration of intel_gmbus_{is_forced_bit/is_port_falid} in i915 driver.
In-Reply-To: <20130503092348.GL5763@phenom.ffwll.local>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1367572662-18400-1-git-send-email-dl9pf@gmx.de> <20130503092348.GL5763@phenom.ffwll.local>
User-Agent: Notmuch/0.15.2+89~g202cdc4 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 03 May 2013 15:03:37 +0300
Message-ID: <87k3ngtgme.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 May 2013, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Fri, May 03, 2013 at 11:17:42AM +0200, dl9pf@gmx.de wrote:
>> From: Jan-Simon Möller <dl9pf@gmx.de>
>> 
>> Description:
>> intel_gmbus_is_forced_bit is no extern as its body is right below.
>> Likewise for intel_gmbus_is_port_valid.
>> 
>> This fixes a compilation issue with clang. An initial version of this patch
>> was developed by PaX Team <pageexec at freemail.hu>.
>> This is respin of this patch.
>> 
>> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
>> CC: pageexec@freemail.hu
>> CC: daniel.vetter@ffwll.ch
>> CC: airlied@linux.ie
>> CC: intel-gfx@lists.freedesktop.org
>> CC: dri-devel@lists.freedesktop.org
>> CC: linux-kernel@vger.kernel.org
> Picked up for -fixes, thanks for the patch.

Please drop it.

The patch removes the inline keyword, creating dozens of copies of the
functions, and consequently loads of warnings:

drivers/gpu/drm/i915/i915_drv.h:1803:13: warning: ‘intel_gmbus_is_port_valid’ defined but not used [-Wunused-function]
drivers/gpu/drm/i915/i915_drv.h:1812:13: warning: ‘intel_gmbus_is_forced_bit’ defined but not used [-Wunused-function]


BR,
Jani.
