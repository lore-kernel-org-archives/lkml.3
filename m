Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbaAHJMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 04:12:45 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33008 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbaAHJMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 04:12:43 -0500
Date: Wed, 8 Jan 2014 09:12:37 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Roger Quadros <rogerq@ti.com>
Cc: sameo@linux.intel.com, balbi@ti.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] mfd: omap-usb-tll: Don't hold lock during
 pm_runtime_get/put_sync()
Message-ID: <20140108091237.GE19974@lee--X1>
References: <1389165333-7573-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1389165333-7573-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> pm_runtime_get/put_sync() can sleep so don't hold spinlock while
> calling them.
> 
> This patch prevents a BUG() during system suspend when
> CONFIG_DEBUG_ATOMIC_SLEEP is enabled.
> 
> Bug is present in Kernel versions v3.9 onwards.
> 
> Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Tested-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: <stable@vger.kernel.org> # 3.9+
> ---
>  drivers/mfd/omap-usb-tll.c | 36 ++++++++++++------------------------
>  1 file changed, 12 insertions(+), 24 deletions(-)

Patch looks good to me now.

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
