Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab3DOMdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 08:33:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58693 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab3DOMdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 08:33:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Clark <robdclark@gmail.com>
Subject: Re: Latest randconfig build errors
Date: Mon, 15 Apr 2013 14:32:45 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap" <linux-omap@vger.kernel.org>, arm@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
References: <20130304095136.GI17833@n2100.arm.linux.org.uk> <20130304184649.GO11806@atomide.com> <CAF6AEGv=3453KKS9-8YAgHrxMMbNvLMvt0pz-=qdG+zcd-Trrw@mail.gmail.com>
In-Reply-To: <CAF6AEGv=3453KKS9-8YAgHrxMMbNvLMvt0pz-=qdG+zcd-Trrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304151432.45362.arnd@arndb.de>
X-Provags-ID: V02:K0:DJLjfhhKXRBJXyobY5xGdwc4z57HMk6n126iHmI4c7+
 C5476neVPWkBfpY9tA2vkiWYJd5P5G7wRtCkX3+CfwzHfBaMFG
 0i6lA4JwvvdvEnnsNsPIQpPVJcvRp84yPAZfCYZD9371r0jZtH
 iHr5Lcc91YS52OKrf0pDNzxUwVbcGYQ7GtClUKieQ8HUpnjsNE
 82OS21/7TWLuhEdcyeaJ3tQQ/Ujs1Fgcm5tny6Ah2rt5wT/VjW
 yO9koTFfKOn0f6NmtvMDYy9GZm24FCE7qUfLcM3C5cS10/FslF
 cRPePeMcLIoZ5glCtajtcAn2sL9v9uosfi7rixq9fLm3Vl29PY
 GMy3O7VoOGHA/5iREEVw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 April 2013, Rob Clark wrote:
> On Mon, Mar 4, 2013 at 1:46 PM, Tony Lindgren <tony@atomide.com> wrote:
> >
> >> drivers/gpu/drm/tilcdc/tilcdc_slave.o:(.data+0x54): multiple definition of `__mod_of_device_table'
> >> drivers/gpu/drm/tilcdc/tilcdc_tfp410.o:(.data+0x54): first defined here
> >> drivers/gpu/drm/tilcdc/tilcdc_panel.o:(.data+0x54): multiple definition of `__mod_of_device_table'
> >> drivers/gpu/drm/tilcdc/tilcdc_tfp410.o:(.data+0x54): first defined here
> >> drivers/gpu/drm/tilcdc/tilcdc_drv.o:(.data+0x184): multiple definition of `__mod_of_device_table'
> >> drivers/gpu/drm/tilcdc/tilcdc_tfp410.o:(.data+0x54): first defined here
> >
> > Rob, I assume you'll do a patch for this one?
> 
> 
> oh, I apologize for the late reply, I didn't see this email...
> 
> There is a patch that we can merge to make tilcdc bool instead of
> tristate[1], which I suppose is ok for a temporary fix.  Although I'm
> all-ears if someone has a better idea about how to fix this.  The
> problem is that we have multiple sub-devices for different possible
> panel drivers, so that depending on DT tables, the correct ones get
> loaded for the hw.  But they are all built into a single module.

If the master device is always present, that's enough for autoloading
the module anyway, you can just drop the other two MODULE_DEVICE_TABLE
lines.

	Arnd
