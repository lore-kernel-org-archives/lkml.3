Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaBPXEM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 18:04:12 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41219 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaBPXEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 18:04:11 -0500
Date: Mon, 17 Feb 2014 00:04:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@debian.org>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH] ARM: OMAP2+: Add support for thumb mode on DT booted
 N900
Message-ID: <20140216230408.GA4376@amd.pavel.ucw.cz>
References: <1391603582-11371-1-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391603582-11371-1-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-02-05 13:33:02, Sebastian Reichel wrote:
> Without enabling the workaround for ARM errata 430973 thumb
> compiled userland crashes randomly on the Nokia N900.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>

Reviewed-by: Pavel Machek <pavel@ucw.cz>


> +static void __init nokia_n900_legacy_init(void)
> +{
> +	hsmmc2_internal_input_clk();
> +
> +	if (omap_type() == OMAP2_DEVICE_TYPE_SEC) {
> +		if (IS_ENABLED(CONFIG_ARM_ERRATA_430973)) {
> +			pr_info("RX-51: Enabling ARM errata 430973 workaround\n");
> +			/* set IBE to 1 */
> +			rx51_secure_update_aux_cr(BIT(6), 0);
> +		} else {
> +			pr_warning("RX-51: Not enabling ARM errata 430973 workaround\n");
> +		}

I'd use higher loglevel there, and added "thumb binaries can now crash
randomly, and can crash the system" ... or something like that, if you
are going to send new version of the patch.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
