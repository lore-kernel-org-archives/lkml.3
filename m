Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaAGKnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:43:40 -0500
Received: from mail.fireflyinternet.com ([87.106.93.118]:63305 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751377AbaAGKnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 05:43:39 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Tue, 7 Jan 2014 10:43:24 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andreas Heider <andreas@meetr.de>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH 1/4] drm/i915: add support for vga_switcheroo reprobe
Message-ID: <20140107104324.GB8991@nuc-i3427.alporthouse.com>
References: <1389088723-30959-1-git-send-email-artagnon@gmail.com>
 <1389088723-30959-2-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389088723-30959-2-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 03:28:40PM +0530, Ramkumar Ramachandra wrote:
> Cc: Andreas Heider <andreas@meetr.de>
> Cc: Seth Forshee <seth.forshee@canonical.com>
> Original-patch-by: Andreas Heider <andreas@meetr.de>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  drivers/gpu/drm/i915/i915_dma.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
> index 5c64842..336a835b 100644
> --- a/drivers/gpu/drm/i915/i915_dma.c
> +++ b/drivers/gpu/drm/i915/i915_dma.c
> @@ -1265,6 +1265,12 @@ static void i915_switcheroo_set_state(struct pci_dev *pdev, enum vga_switcheroo_
>  	}
>  }
>  
> +static void i915_switcheroo_reprobe(struct pci_dev *pdev)
> +{
> +	struct drm_device *dev = pci_get_drvdata(pdev);
> +	intel_fbdev_output_poll_changed(dev);
> +}

switcheroo should be sending a hotplug notification, which should
trigger both this kernel listener and userspace.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
