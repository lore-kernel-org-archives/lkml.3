Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbaCZEeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 00:34:24 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:54030 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaCZEeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 00:34:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140324231014.GI17218@mithrandir>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
	<1395650554-31925-12-git-send-email-acourbot@nvidia.com>
	<20140324231014.GI17218@mithrandir>
Date: Wed, 26 Mar 2014 14:27:20 +1000
Message-ID: <CACAvsv4FHqwAF6FOaMF1sQLwAfBOd6uFgsZ+VdwCHoR4qsVbVw@mail.gmail.com>
Subject: Re: [PATCH 11/12] drm/nouveau: support GK20A in nouveau_accel_init()
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

On Tue, Mar 25, 2014 at 9:10 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Mon, Mar 24, 2014 at 05:42:33PM +0900, Alexandre Courbot wrote:
>> GK20A does not embed a dedicated COPY engine and thus cannot allocate
>> the copy channel that nouveau_accel_init() attempts to create. It also
>> lacks any display hardware, so the creation of a software channel does
>> not apply neither.
>
> Perhaps this should be two separate patches?
>
>> diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
> [...]
>> +     if (device->chipset == 0xea) {
>> +             /* gk20a does not have CE0/CE1 */
>
> This would be another good candidate for a feature flag.
There are ways to query this in a chipset-independent way.  However,
despite reporting it as an error if no copy engines are available, the
code should continue on without the channel happily.  Perhaps we can
just punt the relevent error messages to a debug loglevel for now?

>
>> +             arg0 = NVE0_CHANNEL_IND_ENGINE_GR;
>> +             arg1 = 1;
>> +     } else
>>       if (device->card_type >= NV_E0) {
>
> The formatting here is somewhat weird. From a brief look I couldn't find
> any indication that nouveau deviates from the standard coding style, so
> this should be:
>
>         } else if (...) {
I use the former in a few places, despite it not entirely being
"correct".. It looks nicer though :)  I don't mind either way though.

>
>> +     /* Need to figure out how to handle sw for gk20a */
>> +     if (device->chipset == 0xea)
>> +             goto skip_sw_init;
>
> The commit message makes it sound like SW isn't needed since gk20a
> "lacks any display hardware". In that case the comment here doesn't make
> much sense.
>
> Thierry
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
