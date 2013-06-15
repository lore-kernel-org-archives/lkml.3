Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab3FOMUh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 08:20:37 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:46259 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab3FOMUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 08:20:36 -0400
MIME-Version: 1.0
In-Reply-To: <1371119474.1357.6.camel@x61.thuisdomein>
References: <1363204102.1335.6.camel@x61.thuisdomein>
	<1371119474.1357.6.camel@x61.thuisdomein>
Date: Sat, 15 Jun 2013 08:20:35 -0400
Message-ID: <CAF6AEGs_LS1ZFFj+C67dmRj4G122O1YSqTH_EpgtkLkQOKb2LQ@mail.gmail.com>
Subject: Re: [PATCH] drm/omap: change "!CONFIG_FB_OMAP2" to "!FB_OMAP2"
From: Rob Clark <robdclark@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 6:31 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Wed, 2013-03-13 at 20:48 +0100, Paul Bolle wrote:
>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>> ---
>> Untested. Perhaps the first test that people with access to the relevant
>> hardware might do, is to test _before applying this patch_ with FB_OMAP2
>> set. Perhaps this negative dependency isn't needed at all. Or is it
>> obvious?
>>
>>  drivers/gpu/drm/omapdrm/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> This patch was sent exactly three months ago, shortly after v3.9-rc2 was
> released. This obvious typo is still present in v3.10-rc5.
>
> I didn't received any feedback on this patch. Did anyone had a look at
> it? Is it perhaps queued somewhere?

oh, sorry, at the time I was in the middle of moving, and wasn't
watching dri-devel so much.

Yeah, this should probably either be merged, or we should just drop
the negative dependency.  (I guess in theory you could build both
omapfb and omapdrm as modules and just load one.)

BR
-R

>
> Paul Bolle
>
>> diff --git a/drivers/gpu/drm/omapdrm/Kconfig b/drivers/gpu/drm/omapdrm/Kconfig
>> index 09f65dc..45875a0 100644
>> --- a/drivers/gpu/drm/omapdrm/Kconfig
>> +++ b/drivers/gpu/drm/omapdrm/Kconfig
>> @@ -1,7 +1,7 @@
>>
>>  config DRM_OMAP
>>       tristate "OMAP DRM"
>> -     depends on DRM && !CONFIG_FB_OMAP2
>> +     depends on DRM && !FB_OMAP2
>>       depends on ARCH_OMAP2PLUS || ARCH_MULTIPLATFORM
>>       depends on OMAP2_DSS
>>       select DRM_KMS_HELPER
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
