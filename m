Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbaDKCqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 22:46:33 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:32804 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbaDKCqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 22:46:31 -0400
MIME-Version: 1.0
In-Reply-To: <CACAvsv54BF3cD6y59=kQ=1j-S9tGixTz_J3gx2mbOEkB2eQ4cA@mail.gmail.com>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
 <1395650554-31925-3-git-send-email-acourbot@nvidia.com> <20140324215408.GB17218@mithrandir>
 <CACAvsv54BF3cD6y59=kQ=1j-S9tGixTz_J3gx2mbOEkB2eQ4cA@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 11 Apr 2014 11:46:10 +0900
Message-ID: <CAAVeFuK-6RAfmZ8Zi3+bX_ibmPxPKEy7oT9YiLJWXpLMx3PsFw@mail.gmail.com>
Subject: Re: [PATCH 02/12] drm/nouveau/timer: skip calibration on GK20A
To: Ben Skeggs <skeggsb@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 1:19 PM, Ben Skeggs <skeggsb@gmail.com> wrote:
> On Tue, Mar 25, 2014 at 7:54 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
>> On Mon, Mar 24, 2014 at 05:42:24PM +0900, Alexandre Courbot wrote:
>>> GK20A's timer is directly attached to the system timer and cannot be
>>> calibrated. Skip the calibration phase on that chip since the
>>> corresponding registers do not exist.
>>>
>>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>>> ---
>>>  drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c | 19 +++++++++++++------
>>>  1 file changed, 13 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c b/drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c
>>> index c0bdd10358d7..822fe0d8a871 100644
>>> --- a/drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c
>>> +++ b/drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c
>>> @@ -185,6 +185,10 @@ nv04_timer_init(struct nouveau_object *object)
>>>       if (ret)
>>>               return ret;
>>>
>>> +     /* gk20a does not have the calibration registers */
>>> +     if (device->chipset == 0xea)
>>> +             goto skip_clk_init;
>>
>> I'm concerned that this won't scale in the future. Perhaps a better
>> solution would be to add a "flags" or "features" field to struct
>> nouveau_device along with feature bits such as HAS_CALIBRATION or
>> similar.
>>
>> That way we don't have to touch this code for every new future Tegra
>> chip. Unless perhaps if there's a reason to expect things to change in
>> newer generations.
> I've already handled this in a slightly different way in the tree I'd
> previously pointed Alex at (I think!), as I needed to do the same for
> GM107.
>
> Should just be able to use that implementation (so, just change the
> probe patch) here too.

I will skip this patch and use your implementation then. Btw,
shouldn't the source file for the GK20A implementation be named nvea.c
instead of gk20a.c?
