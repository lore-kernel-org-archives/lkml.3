Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab3F1KPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:15:04 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:55409 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3F1KPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:15:01 -0400
MIME-Version: 1.0
In-Reply-To: <51CB5630.6060000@wwwdotorg.org>
References: <1372112849-670-1-git-send-email-dh.herrmann@gmail.com>
	<1372112849-670-5-git-send-email-dh.herrmann@gmail.com>
	<51CB5630.6060000@wwwdotorg.org>
Date: Fri, 28 Jun 2013 12:14:59 +0200
Message-ID: <CANq1E4T6rR9CHsrWnBR37eROpwvBRUVMrJ+gWFgg=huxD2dP6Q@mail.gmail.com>
Subject: Re: [RFC 4/6] drm: simpledrm: add fbdev fallback support
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

On Wed, Jun 26, 2013 at 10:59 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/24/2013 04:27 PM, David Herrmann wrote:
>> Create a simple fbdev device during SimpleDRM setup so legacy user-space
>> and fbcon can use it.
>>
>> fbdev deletion is quite buggy. A unregister_framebuffer() call followed by
>> a printk() causes NULL-derefs in hide_cursor() and other places in the VT
>> layer. Hence, we leak the fbdev device currently to make the VT layer
>> happy. This needs to be fixed soon! Otherwise, we need a "depends !VT"
>> line for SimpleDRM.
>
>> diff --git a/drivers/gpu/drm/simpledrm/Makefile b/drivers/gpu/drm/simpledrm/Makefile
>
>>  simpledrm-y := simpledrm_drv.o simpledrm_main.o simpledrm_mem.o
>>
>> +ifdef CONFIG_DRM_SIMPLEDRM_FBDEV
>> +     simpledrm-y += simpledrm_fbdev.o
>> +endif
>
> I think that's:
>
> + simpledrm-$(CONFIG_DRM_SIMPLEDRM_FBDEV) += simpledrm_fbdev.o

Ugh, I got errors trying that because SIMPLEDRM_FBDEV is a boolean but
SIMPLEDRM is a tristate. But I guess I tried:
obj-$(CONFIG_DRM_SIMPLEDRM_FBDEV) += simpledrm_fbdev.o
which obviously fails if SIMPLEDRM=m and SIMPLEDRM_FBDEV=y. I will try
to fix that.

Thanks
David
