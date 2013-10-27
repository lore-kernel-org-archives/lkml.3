Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3J0Nv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 09:51:27 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:49353 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab3J0Nv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 09:51:26 -0400
Date: Sun, 27 Oct 2013 14:51:52 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Rob Pearce <rob@flitspace.org.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] INTEL DRM DRIVERS : No LVDS hardware on Intel D410PT and
 D425KT
Message-ID: <20131027135152.GG18189@phenom.ffwll.local>
Mail-Followup-To: Rob Pearce <rob@flitspace.org.uk>,
	David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <526D16A2.60804@flitspace.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526D16A2.60804@flitspace.org.uk>
X-Operating-System: Linux phenom 3.10-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 01:35:30PM +0000, Rob Pearce wrote:
> From: Rob Pearce <rob@flitspace.org.uk> 
> 
> These Intel D410PT and D425KT Mini-ITX desktop boards both show up as
> having LVDS but the hardware is not populated. This patch adds them to
> the list of such systems. Tested against 3.9.10 and 3.11.4
> 
> Signed-off-by: Rob Pearce <rob@flitspace.org.uk>
> ---
> diff -uprN -X linux-3.9.10/Documentation/dontdiff linux-3.9.10/drivers/gpu/drm/i915/intel_lvds.c linux-3.9.10-ovs/drivers/gpu/drm/i915/intel_lvds.c
> --- linux-3.9.10/drivers/gpu/drm/i915/intel_lvds.c       2013-10-22 19:00:30.000000000 +0100
> +++ linux-3.9.10-ovs/drivers/gpu/drm/i915/intel_lvds.c   2013-10-22 18:58:56.000000000 +0100
> @@ -843,6 +843,22 @@
>  	},
>  	{
>  		.callback = intel_no_lvds_dmi_callback,
> +		.ident = "Intel D410PT",
> +		.matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Intel"),
> +			DMI_MATCH(DMI_BOARD_NAME, "D410PT"),
> +		},
> +	},
> +	{
> +		.callback = intel_no_lvds_dmi_callback,
> +		.ident = "Intel D425KT",
> +		.matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Intel"),
> +			DMI_MATCH(DMI_BOARD_NAME, "D425KT"),

At least this one here has a KTW variant with lvds connector. I think we
need a DMI_EXACT_MATCH. I haven't found out whether the D410PT board also
has such a cousin, so please digg in a bit for me.

Thanks, Daniel

> +		},
> +	},
> +	{
> +		.callback = intel_no_lvds_dmi_callback,
>  		.ident = "Supermicro X7SPA-H",
>  		.matches = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "Supermicro"),
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
