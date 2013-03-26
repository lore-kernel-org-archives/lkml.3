Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab3CZRCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:02:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47420 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab3CZRCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:02:07 -0400
Date: Tue, 26 Mar 2013 17:02:03 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Danny Baumann <dannybaumann@web.de>
Cc: David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] drm/i915: Allow specifying a minimum brightness
 level for sysfs control.
Message-ID: <20130326170203.GA23549@srcf.ucam.org>
References: <1364298525-4337-1-git-send-email-dannybaumann@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364298525-4337-1-git-send-email-dannybaumann@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 12:48:44PM +0100, Danny Baumann wrote:
> This patch makes the behaviour of the intel_backlight backlight device
> consistent to e.g. acpi_videoX: When writing the value 0, the set brightness
> makes the panel content barely readable instead of turning the backlight off.
> This matches the expectations of user space (e.g. kde-workspace or the Intel
> X11 driver), which expects that it can use intel_backlight as a drop-in
> replacement for acpi_videoX.

I'm not quite clear what you mean here. The behaviour of "0" isn't well 
defined for the ACPI backlight driver - it's perfectly reasonable for it 
to turn the backlight off entirely. Anything assuming that "0" is still 
visible is broken.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
