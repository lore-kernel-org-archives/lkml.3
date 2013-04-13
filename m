Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3DMMyY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 08:54:24 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:44003 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3DMMyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 08:54:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130304184649.GO11806@atomide.com>
References: <20130304095136.GI17833@n2100.arm.linux.org.uk>
	<20130304184649.GO11806@atomide.com>
Date: Sat, 13 Apr 2013 08:54:22 -0400
Message-ID: <CAF6AEGv=3453KKS9-8YAgHrxMMbNvLMvt0pz-=qdG+zcd-Trrw@mail.gmail.com>
Subject: Re: Latest randconfig build errors
From: Rob Clark <robdclark@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>, arm@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 1:46 PM, Tony Lindgren <tony@atomide.com> wrote:
>
>> drivers/gpu/drm/tilcdc/tilcdc_slave.o:(.data+0x54): multiple definition of `__mod_of_device_table'
>> drivers/gpu/drm/tilcdc/tilcdc_tfp410.o:(.data+0x54): first defined here
>> drivers/gpu/drm/tilcdc/tilcdc_panel.o:(.data+0x54): multiple definition of `__mod_of_device_table'
>> drivers/gpu/drm/tilcdc/tilcdc_tfp410.o:(.data+0x54): first defined here
>> drivers/gpu/drm/tilcdc/tilcdc_drv.o:(.data+0x184): multiple definition of `__mod_of_device_table'
>> drivers/gpu/drm/tilcdc/tilcdc_tfp410.o:(.data+0x54): first defined here
>
> Rob, I assume you'll do a patch for this one?


oh, I apologize for the late reply, I didn't see this email...

There is a patch that we can merge to make tilcdc bool instead of
tristate[1], which I suppose is ok for a temporary fix.  Although I'm
all-ears if someone has a better idea about how to fix this.  The
problem is that we have multiple sub-devices for different possible
panel drivers, so that depending on DT tables, the correct ones get
loaded for the hw.  But they are all built into a single module.
Splitting them into multiple modules will be problematic, as panel
drivers which are present really need to get probed before the
toplevel drm device.. I suppose in theory it is possible to make drm
cope better with dynamically loaded outputs, but I'm not sure that
there is any way to do this without breaking userspace which expects
that all of the connectors/encoders are present once the drm device is
loaded.

BR,
-R

[1] https://patchwork.kernel.org/patch/2376061/
