Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbaDBOOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:14:33 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:44910 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120AbaDBOOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:14:31 -0400
MIME-Version: 1.0
In-Reply-To: <CACAvsv4FHqwAF6FOaMF1sQLwAfBOd6uFgsZ+VdwCHoR4qsVbVw@mail.gmail.com>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
 <1395650554-31925-12-git-send-email-acourbot@nvidia.com> <20140324231014.GI17218@mithrandir>
 <CACAvsv4FHqwAF6FOaMF1sQLwAfBOd6uFgsZ+VdwCHoR4qsVbVw@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 2 Apr 2014 23:14:10 +0900
Message-ID: <CAAVeFuL-v2dntm5kgXUaC1-0dw2PgPnmpffPpa_dpwYZqmhvpA@mail.gmail.com>
Subject: Re: [PATCH 11/12] drm/nouveau: support GK20A in nouveau_accel_init()
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

On Wed, Mar 26, 2014 at 1:27 PM, Ben Skeggs <skeggsb@gmail.com> wrote:
> On Tue, Mar 25, 2014 at 9:10 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
>> On Mon, Mar 24, 2014 at 05:42:33PM +0900, Alexandre Courbot wrote:
>>> GK20A does not embed a dedicated COPY engine and thus cannot allocate
>>> the copy channel that nouveau_accel_init() attempts to create. It also
>>> lacks any display hardware, so the creation of a software channel does
>>> not apply neither.
>>
>> Perhaps this should be two separate patches?
>>
>>> diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
>> [...]
>>> +     if (device->chipset == 0xea) {
>>> +             /* gk20a does not have CE0/CE1 */
>>
>> This would be another good candidate for a feature flag.
> There are ways to query this in a chipset-independent way.  However,
> despite reporting it as an error if no copy engines are available, the
> code should continue on without the channel happily.  Perhaps we can
> just punt the relevent error messages to a debug loglevel for now?

Sure, that would be more future-proof as well.

>
>>
>>> +             arg0 = NVE0_CHANNEL_IND_ENGINE_GR;
>>> +             arg1 = 1;
>>> +     } else
>>>       if (device->card_type >= NV_E0) {
>>
>> The formatting here is somewhat weird. From a brief look I couldn't find
>> any indication that nouveau deviates from the standard coding style, so
>> this should be:
>>
>>         } else if (...) {
> I use the former in a few places, despite it not entirely being
> "correct".. It looks nicer though :)  I don't mind either way though.

Yeah, I just followed the style of the file here. Whether it needs to
change or not is not my call. :P

>>> +     /* Need to figure out how to handle sw for gk20a */
>>> +     if (device->chipset == 0xea)
>>> +             goto skip_sw_init;
>>
>> The commit message makes it sound like SW isn't needed since gk20a
>> "lacks any display hardware". In that case the comment here doesn't make
>> much sense.

Correct. As far as I have looked (that is, not very far), SW methods
are used for display-related functions, but there might be other
use-cases too. Maybe someone who knows better can confirm?
