Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbbAETum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:50:42 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:44382 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbbAETuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:50:39 -0500
MIME-Version: 1.0
In-Reply-To: <20150105153252.GI12010@ulmo.nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
 <1419331204-26679-10-git-send-email-vinceh@nvidia.com> <54A20F4D.4040100@gmail.com>
 <54A2198A.4000707@nvidia.com> <20150105153252.GI12010@ulmo.nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 5 Jan 2015 20:50:18 +0100
Message-ID: <CAAVeFuK-SgUbtHADX4-pXN5_ayzvEd+1KxJOBcRe2tmDfHaLEA@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH nouveau 09/11] drm: export some variable and
 functions to resue the PM functions
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Vince Hsu <vinceh@nvidia.com>, Emil Velikov <emil.l.velikov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ben Skeggs <bskeggs@redhat.com>, Martin Peres <martin.peres@free.fr>,
        Roy Spliet <seven@nimrod-online.com>, samuel.pitoiset@gmail.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 4:32 PM, Thierry Reding <thierry.reding@gmail.com> wrote:
> On Tue, Dec 30, 2014 at 11:18:34AM +0800, Vince Hsu wrote:
>> Hi Emil,
>>
>> On 12/30/2014 10:34 AM, Emil Velikov wrote:
>> >On 23/12/14 10:40, Vince Hsu wrote:
>> >>This patch adds some checks in the suspend/resume functions to distinguish
>> >>the dGPU and mobile GPU and exports some variables/functions so that the
>> >>nouveau platform device can reuse them.
>> >>
>> >Hi Vince,
>> >
>> >Afaiu one needs to export a symbol as it's used by another module or
>> >subsystem. With the follow up two patches you are not doing either one,
>> >so I'd assume that you can just omit the EXPORT_* changes.
>> The nouveau platform device driver is built as another module -
>> nouveau_platform.ko. :)
>
> I'd like to hear the opinion of the nouveau people and Alex, but I'd
> very much prefer if nouveau_platform.o was simply linked into the
> nouveau.ko module. I don't see any good reason to keep it separate.

Yep, I agree. The decision to host platform support in a separate
module looks misleaded if it results in additional exports that we
would otherwise avoid. IIUC I did this to be able to use the module
convenience macros to register the platform driver.

>
> Something like the attached patch (untested) ought to do it.

This patch alone won't be enough for the reason I mentioned above.
However, if Vince doesn't mind handling the platform driver
registration manually in nouveau_drm_init/nouveau_drm_exit, I agree
this would be the way to go.

Cheers,
Alex.
