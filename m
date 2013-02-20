Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934674Ab3BTSRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 13:17:55 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:47323 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933919Ab3BTSRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 13:17:52 -0500
Date: Wed, 20 Feb 2013 10:17:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Simon Glass <sjg@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Che-Liang Chiou <clchiou@chromium.org>,
        Jonathan Kliegman <kliegs@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 2/6] mfd: Add ChromeOS EC implementation
Message-ID: <20130220181746.GA15152@core.coreip.homeip.net>
References: <1361381079-26747-1-git-send-email-sjg@chromium.org>
 <1361381079-26747-3-git-send-email-sjg@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361381079-26747-3-git-send-email-sjg@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 09:24:35AM -0800, Simon Glass wrote:
> This is the base EC implementation, which provides a high level
> interface to the EC for use by the rest of the kernel. The actual
> communcations is dealt with by a separate protocol driver which
> registers itself with this interface.
> 
> Interrupts are passed on through a notifier.
> 
> A simple message structure is used to pass messages to the
> protocol driver.
> Signed-off-by: Simon Glass <sjg@chromium.org>
> Signed-off-by: Che-Liang Chiou <clchiou@chromium.org>
> Signed-off-by: Jonathan Kliegman <kliegs@chromium.org>
> Signed-off-by: Luigi Semenzato <semenzato@chromium.org>
> Signed-off-by: Olof Johansson <olofj@chromium.org>
> Signed-off-by: Vincent Palatin <vpalatin@chromium.org>

...

>  
> +config MFD_CROS_EC
> +	bool "Support ChromeOS Embedded Controller"
> +	help
> +	  If you say Y here you get support for the ChromeOS Embedded
> +	  Controller (EC) providing keyboard, battery and power services.
> +	  You also ned to enable the driver for the bus you are using. The
> +	  protocol for talking to the EC is defined by the bus driver.

Why can't it be a module?

> +
> +#ifndef __LINUX_MFD_CROS_EC_H
> +#define __LINUX_MFD_CROS_EC_H
> +
> +struct i2c_msg;

I do not believe this is needed here.

Thanks.

-- 
Dmitry
