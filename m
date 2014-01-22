Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbaAVVfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 16:35:45 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:45747 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752960AbaAVVfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 16:35:42 -0500
Date: Wed, 22 Jan 2014 21:35:35 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        Rob Clark <robdclark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 10/24] drm/i2c: tda998x: don't read write-only
	registers
Message-ID: <20140122213535.GI15937@n2100.arm.linux.org.uk>
References: <cover.1390153344.git.moinejf@free.fr> <20140119195842.24c40e22@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140119195842.24c40e22@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 19, 2014 at 07:58:42PM +0100, Jean-Francois Moine wrote:
> This patch takes care of the write-only registers of the tda998x.
> 
> The value 'MAT_CONTRL_MAT_SC(1)' in the register MAT_CONTRL has been
> set as it is at reset time.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
> v3
>     - remarks from Russell King
> 	- don't move the sync polarity setting after the setting of the
> 	  register TBG_CNTRL_0 which must be the last setting of the
> 	  init sequence

This is better, except I find that there's an additional change in this
version which wasn't in the original patch 9:

>  	/* must be last register set: */
> -	reg_clear(priv, REG_TBG_CNTRL_0, TBG_CNTRL_0_SYNC_ONCE);
> +	reg_write(priv, REG_TBG_CNTRL_0, 0);

Register changes which have a potential effect shouldn't be part of a
patch which is really only trying to avoid reading from write only
registers.

This could be a potential functional change - and it's probably one
which Rob Clark should at least be made aware of.  As I commented last
time, when you're changing register values in an otherwise innocuous
patch, you should comment about them in the patch description.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
