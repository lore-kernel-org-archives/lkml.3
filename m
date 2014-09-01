Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaIAAHZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 20:07:25 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:52353 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaIAAHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 20:07:18 -0400
MIME-Version: 1.0
In-Reply-To: <5403ADAF.1000909@infradead.org>
References: <1409526467-20944-1-git-send-email-jcmvbkbc@gmail.com>
	<5403ADAF.1000909@infradead.org>
Date: Mon, 1 Sep 2014 04:07:17 +0400
Message-ID: <CAMo8BfJYrFUao5D5LoRY50u=akmggrJ0OwA_tTbiT2o=BvKF6w@mail.gmail.com>
Subject: Re: [PATCH] drm/vmwgfx: select FB when DRM_VMWGFX is selected
From: Max Filippov <jcmvbkbc@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2014 at 3:20 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 08/31/14 16:07, Max Filippov wrote:
>> Otherwise, if FB is not selected build fails at linking step:
>>   vmwgfx_fb.c:(.text+0x4098b): undefined reference to `register_framebuffer'
>>   vmwgfx_fb.c:(.text+0x409c0): undefined reference to `framebuffer_release'
>>   vmwgfx_fb.c:(.text+0x409f4): undefined reference to `unregister_framebuffer'
>>   vmwgfx_fb.c:(.text+0x40a0e): undefined reference to `framebuffer_release'
>>
>> Patch ae6445ac7475ff05 drm/vmwgfx: depends on FB
>> added dependency on FB that was subsequently removed in patch
>> 04381b987292256d drm: Move plane helpers into drm_kms_helper.ko
>>
>> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
>> ---
>>  drivers/gpu/drm/vmwgfx/Kconfig |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/vmwgfx/Kconfig b/drivers/gpu/drm/vmwgfx/Kconfig
>> index 67720f7..4fba548 100644
>> --- a/drivers/gpu/drm/vmwgfx/Kconfig
>> +++ b/drivers/gpu/drm/vmwgfx/Kconfig
>> @@ -1,6 +1,7 @@
>>  config DRM_VMWGFX
>>       tristate "DRM driver for VMware Virtual GPU"
>>       depends on DRM && PCI
>> +     select FB
>>       select FB_DEFERRED_IO
>>       select FB_CFB_FILLRECT
>>       select FB_CFB_COPYAREA
>>
>
> My experience with these "select FB_*" things is that this symbol (DRM_VMWGFX)
> should still depend on FB.  Has something changed recently to negate that?

I see the following if I replace 'select FB' with 'depends on FB':

drivers/video/fbdev/Kconfig:5:error: recursive dependency detected!
drivers/video/fbdev/Kconfig:5:  symbol FB is selected by DRM_KMS_FB_HELPER
drivers/gpu/drm/Kconfig:39:     symbol DRM_KMS_FB_HELPER depends on
DRM_KMS_HELPER
drivers/gpu/drm/Kconfig:33:     symbol DRM_KMS_HELPER is selected by DRM_VMWGFX
drivers/gpu/drm/vmwgfx/Kconfig:1:       symbol DRM_VMWGFX depends on FB

-- 
Thanks.
-- Max
