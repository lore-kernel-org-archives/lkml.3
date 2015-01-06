Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbbAFJhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 04:37:11 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14247 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbbAFJhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 04:37:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 06 Jan 2015 01:35:34 -0800
Message-ID: <54ABACAB.4070209@nvidia.com>
Date: Tue, 6 Jan 2015 17:36:43 +0800
From: Vince Hsu <vinceh@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Emil Velikov <emil.l.velikov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ben Skeggs <bskeggs@redhat.com>, Martin Peres <martin.peres@free.fr>,
        Roy Spliet <seven@nimrod-online.com>, <samuel.pitoiset@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Nouveau] [PATCH nouveau 09/11] drm: export some variable and
 functions to resue the PM functions
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com> <1419331204-26679-10-git-send-email-vinceh@nvidia.com> <54A20F4D.4040100@gmail.com> <54A2198A.4000707@nvidia.com> <20150105153252.GI12010@ulmo.nvidia.com> <CAAVeFuK-SgUbtHADX4-pXN5_ayzvEd+1KxJOBcRe2tmDfHaLEA@mail.gmail.com>
In-Reply-To: <CAAVeFuK-SgUbtHADX4-pXN5_ayzvEd+1KxJOBcRe2tmDfHaLEA@mail.gmail.com>
X-Originating-IP: [10.19.108.126]
X-ClientProxiedBy: DRBGMAIL103.nvidia.com (10.18.16.22) To
 HKMAIL101.nvidia.com (10.18.16.10)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2015 03:50 AM, Alexandre Courbot wrote:
> On Mon, Jan 5, 2015 at 4:32 PM, Thierry Reding <thierry.reding@gmail.com> wrote:
>> On Tue, Dec 30, 2014 at 11:18:34AM +0800, Vince Hsu wrote:
>>> Hi Emil,
>>>
>>> On 12/30/2014 10:34 AM, Emil Velikov wrote:
>>>> On 23/12/14 10:40, Vince Hsu wrote:
>>>>> This patch adds some checks in the suspend/resume functions to distinguish
>>>>> the dGPU and mobile GPU and exports some variables/functions so that the
>>>>> nouveau platform device can reuse them.
>>>>>
>>>> Hi Vince,
>>>>
>>>> Afaiu one needs to export a symbol as it's used by another module or
>>>> subsystem. With the follow up two patches you are not doing either one,
>>>> so I'd assume that you can just omit the EXPORT_* changes.
>>> The nouveau platform device driver is built as another module -
>>> nouveau_platform.ko. :)
>> I'd like to hear the opinion of the nouveau people and Alex, but I'd
>> very much prefer if nouveau_platform.o was simply linked into the
>> nouveau.ko module. I don't see any good reason to keep it separate.
> Yep, I agree. The decision to host platform support in a separate
> module looks misleaded if it results in additional exports that we
> would otherwise avoid. IIUC I did this to be able to use the module
> convenience macros to register the platform driver.
>
>> Something like the attached patch (untested) ought to do it.
> This patch alone won't be enough for the reason I mentioned above.
> However, if Vince doesn't mind handling the platform driver
> registration manually in nouveau_drm_init/nouveau_drm_exit, I agree
> this would be the way to go.
I definitely don't mind. :) Will fix in next version based on you guys' 
suggestions.

Thanks,
Vince

