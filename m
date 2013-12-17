Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab3LQR1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 12:27:53 -0500
Received: from mail.fireflyinternet.com ([87.106.93.118]:55051 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754498Ab3LQR1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 12:27:52 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Tue, 17 Dec 2013 17:27:40 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/intel: Only smash VGA SR01 register if
 intel is default VGA device
Message-ID: <20131217172740.GM22448@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Keith Packard <keithp@keithp.com>, intel-gfx@lists.freedesktop.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <1387300330-8844-1-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387300330-8844-1-git-send-email-keithp@keithp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 09:12:10AM -0800, Keith Packard wrote:
> We want to disable the (unused) VGA plane on the intel hardware, which
> should be a simple matter of writing the vga control register. However,
> in 2009 (commit 24f119c769bacac5729297b682fec7811a983cc6), that simple
> code was changed to also smash the SR01 VGA register to fix "random
> crash and lockups".
> 
> When running efifb on an nVidia card, executing this store to SR01
> ends up causing the screen to go black.
> 
> I'm not sure if this store is still required; this patch limits it to
> when the intel card is primary.

The bspec still says we must assert SR01 bit5 prior to disabling the VGA
plane.

Perhaps the test should be whether (vga_reg & VGA_DISP_DISABLE) == 0 and
do nothing if the plane is already off.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
