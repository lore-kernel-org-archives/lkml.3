Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaBJPtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:49:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39898 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbaBJPtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:49:45 -0500
Date: Mon, 10 Feb 2014 16:49:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Imre Deak <imre.deak@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>,
        intel-gfx@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: intel_sdvo_init: trying to register non-static key
Message-ID: <20140210154942.GC4303@pd.tnic>
References: <20140207093205.GA24395@pd.tnic>
 <87d2iz18vi.fsf@intel.com>
 <1391771542.5669.6.camel@intelbox>
 <20140207112809.GG24395@pd.tnic>
 <20140207145149.GZ17001@phenom.ffwll.local>
 <1391787126.5669.11.camel@intelbox>
 <20140207154911.GK24395@pd.tnic>
 <1391791674.21697.2.camel@intelbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1391791674.21697.2.camel@intelbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 06:47:54PM +0200, Imre Deak wrote:
> Ok, not sure why the sdvo initialization fails, but the lockdep
> warning is probably fixed by the below patch. Could you try it and
> send a dmesg with drm.debug=0xe?

Yep, FWIW, the issue is fixed in -rc2, as it got cleared in the other
thread that there's a fix for that on its way to Linus. I.e., this one

commit da9846ae15186d491d6e21ebbb5051e1d3c7f652
Author: Tejun Heo <tj@kernel.org>
Date:   Wed Jan 29 12:04:03 2014 -0500

    kernfs: make kernfs_deactivate() honor KERNFS_LOCKDEP flag

Thanks for addressing this issue so quickly!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
