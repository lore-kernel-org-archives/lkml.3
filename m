Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaGNCJG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 22:09:06 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:42087 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaGNCI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 22:08:58 -0400
MIME-Version: 1.0
In-Reply-To: <53BF4029.5060301@nvidia.com>
References: <1404977677-22248-1-git-send-email-acourbot@nvidia.com>
 <CACAvsv7cxHbXaF-0wi=cijACUBdrH_rqamM+=okrb0+cJxYAsw@mail.gmail.com> <53BF4029.5060301@nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 14 Jul 2014 11:08:37 +0900
Message-ID: <CAAVeFuJsaH=z7YKPet1eiMhA-QKX2WYgYUrhNDFgU8stL=f9jQ@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH 0/3] drm/gk20a: support for reclocking
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <skeggsb@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 10:38 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Hi Ben,
>
>
> On 07/11/2014 10:07 AM, Ben Skeggs wrote:
>>
>> On Thu, Jul 10, 2014 at 5:34 PM, Alexandre Courbot <acourbot@nvidia.com>
>> wrote:
>>>
>>> This series adds support for reclocking on GK20A. The first two patches
>>> touch
>>> the clock subsystem to allow GK20A to operate, by making the presence of
>>> the
>>> thermal and voltage devices optional, and allowing pstates to be provided
>>> directly instead of being probed using the BIOS (which Tegra does not
>>> have).
>>
>> Hey Alex,
>>
>> I mentioned a while back I had some stuff in-progress to make
>> implementing this a bit cleaner for you, but as you can probably tell,
>> I didn't get to it yet.  It's likely I won't manage to before the next
>> merge window either.  So, I'll likely take these patches as-is
>> (assuming no objections on reviews here) and rebase my stuff on top.
>
>
> Thanks. You will probably notice that these patches won't apply to your tree
> and require some tweaking. I will probably end up sending a v2 anyway, so
> maybe you should wait for it. If you want to try this version anyway, I have
> fixed-up patches against your tree.
>
> Note that your tree currently won't build against -next because it uses
> drm_sysfs_connector_add/remove which are not available anymore (replaced by
> drm_connector_register/unregister I believe).
>
> Oh and while I'm at it, there seems to be a typo in line 131 of clock.h,
> which should read _nouveau_clock_fini and not _nouveau_clock_init.
>
>
>>>
>>> The last patch adds the GK20A clock device. Arguably the clock can be
>>> seen as a
>>> stripped-down version of what is seen on NVE0, however instead of using
>>> NVE0
>>> support has been written from scratch using the ChromeOS kernel as a
>>> basis.
>>> There are several reasons for this:
>>>
>>> - The ChromeOS driver uses a lookup table for the P coefficient which I
>>> could
>>>    not find in the NVE0 driver,
>>
>> Interesting.  Can you give more details on how "PL" works exactly,
>> we'd been operating on the assumption (mainly inherited from code that
>> appeared in xf86-video-nv) that it was always a straight division.
>
>
> The pl_to_div table in clock/gk20a.c should give the right coefficients, but
> I have seen contradictory information in our docs. Let me ask the right
> people so we can get to the bottom of this.

So as it turns out this seems to be gk20a-specific. Other Kepler GPUs
use it as a straight division, but gk20a uses a narrower range and
thus requires this table.
