Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaBGNky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:40:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbaBGNkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:40:53 -0500
Date: Fri, 7 Feb 2014 14:40:48 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jani Nikula <jani.nikula@intel.com>
cc: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm next tree
In-Reply-To: <87a9e318m6.fsf@intel.com>
Message-ID: <alpine.LNX.2.00.1402071437400.24838@pobox.suse.cz>
References: <alpine.DEB.2.00.1401300249130.13810@skynet.skynet.ie> <alpine.LRH.2.00.1401301648050.15677@twin.jikos.cz> <alpine.LNX.2.00.1402071052470.24838@pobox.suse.cz> <87a9e318m6.fsf@intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Feb 2014, Jani Nikula wrote:

> >> >   git://people.freedesktop.org/~airlied/linux drm-next
> >> [ ... snip ... ]
> >> > Daniel Vetter (59):
> >> [ ... snip ... ]
> >> >       drm/i915: dp aux irq support for g4x/vlv
> >> 
> >> This commit causes all kinds of havoc on my ThinkPad x200s. It results in
> > [ ... snip ... ]
> >
> > Not having received any response, I suggest the following for 3.14
> 
> Daniel, it's your commit this bisects to...
> 
> If we end up having to revert, I'd just touch the has_aux_irq part, for
> example:
> 
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
> index 5ede4e8..464c047 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -404,7 +404,7 @@ intel_dp_aux_ch(struct intel_dp *intel_dp,
>  	int i, ret, recv_bytes;
>  	uint32_t status;
>  	int try, precharge, clock = 0;
> -	bool has_aux_irq = true;
> +	bool has_aux_irq = INTEL_INFO(dev)->gen >= 5;
>  	uint32_t timeout;
> 
>  	/* dp aux is extremely sensitive to irq latency, hence request the

That, obviously, works for my system as well. Feel free to add

	Reported-and-tested-by: Jiri Kosina <jkosina@suse.cz>

if you are going with this instead of the revert.

-- 
Jiri Kosina
SUSE Labs
