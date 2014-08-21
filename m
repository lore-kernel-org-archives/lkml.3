Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbaHUIhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:37:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41791 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752846AbaHUIhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:37:11 -0400
Date: Thu, 21 Aug 2014 10:37:06 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>, David Airlie <airlied@linux.ie>,
        <dri-devel@lists.freedesktop.org>, <linux-pwm@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mark Rutland <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Bo Shen <voice.shen@atmel.com>, Kumar Gala <galak@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 00/11] drm: add support for Atmel HLCDC Display
 Controller
Message-ID: <20140821103706.2349915d@bbrezillon>
In-Reply-To: <20140821081619.GZ2452@ldesroches-Latitude-E6320>
References: <1406034695-15534-1-git-send-email-boris.brezillon@free-electrons.com>
	<20140821081619.GZ2452@ldesroches-Latitude-E6320>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ludovic,

On Thu, 21 Aug 2014 10:16:19 +0200
Ludovic Desroches <ludovic.desroches@atmel.com> wrote:

> Hi Boris,
> 
> You can add
> 
> Tested-by: Ludovic Desroches <ludovic.desroches@atmel.com>

Thanks for testing this driver.

> 
> Only one issue but not related to your patches, you can't display
> quickly the bootup logo since the panel detection takes too much
> time.

Yes, actually this is related to the device probe order: the
hlcdc-display-controller device is probed before the simple-panel, thus
nothing is detected on the RGB connector (I use of_drm_find_panel to
check for panel availability) when the display controller is
instantiated. I rely on the default polling infrastructure provided by
the DRM/KMS framework which polls for a new connector every 10s, and
this is far more than you kernel boot time.

Do anyone see a solution to reduce this delay (without changing the
polling interval). I thought we could add a notifier infrastructure to
the DRM panel framework, but I'm not sure this is how you want things
done...

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
