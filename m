Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751138AbaCZETw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 00:19:52 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:44686 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaCZETu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 00:19:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140324215408.GB17218@mithrandir>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
	<1395650554-31925-3-git-send-email-acourbot@nvidia.com>
	<20140324215408.GB17218@mithrandir>
Date: Wed, 26 Mar 2014 14:19:49 +1000
Message-ID: <CACAvsv54BF3cD6y59=kQ=1j-S9tGixTz_J3gx2mbOEkB2eQ4cA@mail.gmail.com>
Subject: Re: [PATCH 02/12] drm/nouveau/timer: skip calibration on GK20A
From: Ben Skeggs <skeggsb@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 7:54 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Mon, Mar 24, 2014 at 05:42:24PM +0900, Alexandre Courbot wrote:
>> GK20A's timer is directly attached to the system timer and cannot be
>> calibrated. Skip the calibration phase on that chip since the
>> corresponding registers do not exist.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>  drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c | 19 +++++++++++++------
>>  1 file changed, 13 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c b/drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c
>> index c0bdd10358d7..822fe0d8a871 100644
>> --- a/drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c
>> +++ b/drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c
>> @@ -185,6 +185,10 @@ nv04_timer_init(struct nouveau_object *object)
>>       if (ret)
>>               return ret;
>>
>> +     /* gk20a does not have the calibration registers */
>> +     if (device->chipset == 0xea)
>> +             goto skip_clk_init;
>
> I'm concerned that this won't scale in the future. Perhaps a better
> solution would be to add a "flags" or "features" field to struct
> nouveau_device along with feature bits such as HAS_CALIBRATION or
> similar.
>
> That way we don't have to touch this code for every new future Tegra
> chip. Unless perhaps if there's a reason to expect things to change in
> newer generations.
I've already handled this in a slightly different way in the tree I'd
previously pointed Alex at (I think!), as I needed to do the same for
GM107.

Should just be able to use that implementation (so, just change the
probe patch) here too.

Thanks,
Ben.

>
> Thierry
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
