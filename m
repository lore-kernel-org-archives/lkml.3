Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab3CHF1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 00:27:32 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:62799 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab3CHF13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 00:27:29 -0500
MIME-Version: 1.0
In-Reply-To: <CAOS58YOwSjHyFfAfaY_o3YZKhD-p2gc78ZGrc4N5_NCg+ZVu1A@mail.gmail.com>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
	<1362718720-27048-2-git-send-email-yinghai@kernel.org>
	<20130308051059.GC14556@mtj.dyndns.org>
	<CAE9FiQVMjm7P28XLYGQ675we2+dU+H6rJK2eiO+FFeynYefJHA@mail.gmail.com>
	<CAOS58YOwSjHyFfAfaY_o3YZKhD-p2gc78ZGrc4N5_NCg+ZVu1A@mail.gmail.com>
Date: Thu, 7 Mar 2013 21:27:28 -0800
X-Google-Sender-Auth: 1OYR2ClgtXk1Fnjj1W75fFgWe5E
Message-ID: <CAE9FiQVFvg2M5A5Se5pys5yquNSZeOTV=s4YgLwr6QH_6=nY_w@mail.gmail.com>
Subject: Re: [PATCH 01/14] x86, ACPI, mm: Kill max_low_pfn_mapped
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Jacob Shin <jacob.shin@amd.com>,
        linux-acpi@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 9:25 PM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Mar 7, 2013 at 9:22 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Thu, Mar 7, 2013 at 9:10 PM, Tejun Heo <tj@kernel.org> wrote:
>>> On Thu, Mar 07, 2013 at 08:58:27PM -0800, Yinghai Lu wrote:
>>>> diff --git a/drivers/gpu/drm/i915/i915_gem_stolen.c b/drivers/gpu/drm/i915/i915_gem_stolen.c
>>>> index 69d97cb..7f9380b 100644
>>>> --- a/drivers/gpu/drm/i915/i915_gem_stolen.c
>>>> +++ b/drivers/gpu/drm/i915/i915_gem_stolen.c
>>>> @@ -81,7 +81,7 @@ static unsigned long i915_stolen_to_physical(struct drm_device *dev)
>>>>               base -= dev_priv->mm.gtt->stolen_size;
>>>>       } else {
>>>>               /* Stolen is immediately above Top of Memory */
>>>> -             base = max_low_pfn_mapped << PAGE_SHIFT;
>>>> +             base = __REMOVED_CRAZY__ << PAGE_SHIFT;
>>>
>>> Huh?
>>
>> Whole function:
>
> Yeah, but can't we still just do 1LLU << 32 like other places? Or at
> least explain what was there before? It's gonna confuse the hell out
> of future readers of the code.

They are not using memblock_find_in_range(), so 1ULL<< will not help.

Really hope i915 drm guys could clean that hacks.

Thanks

Yinghai
