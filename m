Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab3F1KnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:43:04 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:48170 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab3F1KnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:43:02 -0400
MIME-Version: 1.0
In-Reply-To: <51CD5E99.5010802@iki.fi>
References: <1363204102.1335.6.camel@x61.thuisdomein>
	<1371119474.1357.6.camel@x61.thuisdomein>
	<CAF6AEGs_LS1ZFFj+C67dmRj4G122O1YSqTH_EpgtkLkQOKb2LQ@mail.gmail.com>
	<51CD5E99.5010802@iki.fi>
Date: Fri, 28 Jun 2013 20:42:59 +1000
Message-ID: <CAPM=9ty1CyJ5xOEqvAOSc8pMwPHbtdpaXyAhzLkPDH3Hh0S=fA@mail.gmail.com>
Subject: Re: [PATCH] drm/omap: change "!CONFIG_FB_OMAP2" to "!FB_OMAP2"
From: Dave Airlie <airlied@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@iki.fi>
Cc: Rob Clark <robdclark@gmail.com>, Paul Bolle <pebolle@tiscali.nl>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 7:59 PM, Tomi Valkeinen <tomi.valkeinen@iki.fi> wrote:
> On 15/06/13 15:20, Rob Clark wrote:
>> On Thu, Jun 13, 2013 at 6:31 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
>>> On Wed, 2013-03-13 at 20:48 +0100, Paul Bolle wrote:
>>>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>>>> ---
>>>> Untested. Perhaps the first test that people with access to the relevant
>>>> hardware might do, is to test _before applying this patch_ with FB_OMAP2
>>>> set. Perhaps this negative dependency isn't needed at all. Or is it
>>>> obvious?
>>>>
>>>>  drivers/gpu/drm/omapdrm/Kconfig | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> This patch was sent exactly three months ago, shortly after v3.9-rc2 was
>>> released. This obvious typo is still present in v3.10-rc5.
>>>
>>> I didn't received any feedback on this patch. Did anyone had a look at
>>> it? Is it perhaps queued somewhere?
>>
>> oh, sorry, at the time I was in the middle of moving, and wasn't
>> watching dri-devel so much.
>>
>> Yeah, this should probably either be merged, or we should just drop
>> the negative dependency.  (I guess in theory you could build both
>> omapfb and omapdrm as modules and just load one.)
>
> Hmm, fixing that creates a problem:
>
> drivers/video/Kconfig:42:error: recursive dependency detected!
> drivers/video/Kconfig:42:       symbol FB is selected by DRM_KMS_HELPER
> drivers/gpu/drm/Kconfig:29:     symbol DRM_KMS_HELPER is selected by DRM_OMAP
> drivers/gpu/drm/omapdrm/Kconfig:2:      symbol DRM_OMAP depends on FB_OMAP2
> drivers/video/omap2/omapfb/Kconfig:1:   symbol FB_OMAP2 depends on FB
>
> And it makes selecting omapfb not possible...
>
> omapfb already has a !DRM_OMAP dependency. I think it's enough to have
> that one there, and remove the !FB_OMAP dependency from omapdrm.

I just nuked it upstream in drm-next.

commit 2644ee9614be67abe155f1073bb9e1b737bbca53
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Jun 28 12:08:10 2013 +1000

    drm/omap: drop the !FB_OMAP2 dep

    This ends up causing circularity and really let people shoot themselves
    in the foot.

    Acked-by: Rob Clark <robdclark@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

Dave.
>
>  Tomi
>
>
