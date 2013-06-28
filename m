Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab3F1KBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:01:33 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:42933 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab3F1KBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:01:31 -0400
MIME-Version: 1.0
In-Reply-To: <51CB55DB.6040306@wwwdotorg.org>
References: <1372112849-670-1-git-send-email-dh.herrmann@gmail.com>
	<1372112849-670-4-git-send-email-dh.herrmann@gmail.com>
	<51CB55DB.6040306@wwwdotorg.org>
Date: Fri, 28 Jun 2013 12:01:29 +0200
Message-ID: <CANq1E4QKMqPug+dU_o9SGa1=S7v4UO5ttV5EahfrVkV68kW=Qg@mail.gmail.com>
Subject: Re: [RFC 3/6] drm: add SimpleDRM driver
From: David Herrmann <dh.herrmann@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@gmail.com>, linux-fbdev@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Jun 26, 2013 at 10:58 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/24/2013 04:27 PM, David Herrmann wrote:
>> The SimpleDRM driver binds to simple-framebuffer devices and provides a
>> DRM/KMS API. It provides only a single CRTC+encoder+connector combination
>> plus one initial mode.
>>
>> Userspace can create one dumb-buffer and attach it to the CRTC. Only if
>> the buffer is destroyed, a new buffer can be created. The buffer is
>> directly mapped into user-space, so we have only resources for a single
>> buffer. Otherwise, shadow buffers plus damage-request would be needed.
>
>> diff --git a/drivers/gpu/drm/simpledrm/Kconfig b/drivers/gpu/drm/simpledrm/Kconfig
>
>> +config DRM_SIMPLEDRM
>> +     tristate "Simple firmware framebuffer DRM driver"
>> +     depends on DRM && !FB_SIMPLE
>> +     help
>> +       SimpleDRM can run on all systems with pre-initialized graphics
>> +       hardware. It uses a framebuffer that was initialized during
>> +       firmware boot. No page-flipping, modesetting or other advanced
>> +       features are available. However, other DRM drivers can be loaded
>> +       later and take over from SimpleDRM if they provide real hardware
>> +       support.
>> +
>> +       SimpleDRM supports: "simple-framebuffer" DeviceTree objects, x86 VESA
>> +       BIOS Extensions (VBE), EFI framebuffers
>
> DT objects, yes. I'm not sure it's quite true to say it actually
> directly supports VBE or EFI FBs; it's more the code in patch 2/6 that
> supports those. I guess this is a bit nit-picky of a distinction though.

I initially intended to add support for "platform-framebuffer"
objects, too. This would make vesafb/... obsolete but I dropped that
idea for now. I will fix the Kconfig description.

>> diff --git a/drivers/gpu/drm/simpledrm/simpledrm_drv.c b/drivers/gpu/drm/simpledrm/simpledrm_drv.c
>
>> +static int parse_dt(struct platform_device *pdev,
>> +                 struct simplefb_platform_data *mode)
>
>> +     strlcpy(mode->format, format, sizeof(mode->format));
>
> Even here, I believe the DT data sticks around so just copying the
> pointer should be safe. It'd be worth validating that for sure though.

Yep, indeed, I fixed that.

Thanks!
David

> I didn't review the DRM stuff here since I'm not at all familiar with DRM.
