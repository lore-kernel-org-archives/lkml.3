Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbaHNDzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 23:55:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbaHNDzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 23:55:15 -0400
Message-ID: <53EC331F.3000508@suse.com>
Date: Thu, 14 Aug 2014 05:55:11 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Ben Widawsky <benjamin.widawsky@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: Usage of _PAGE_PCD et al in i915 driver
References: <53E4B338.3040904@suse.com>	<CAKMK7uEqfLudZbj1ArKJVXET69d+g+SA3=GtXQ0zXi+FeudAag@mail.gmail.com> <20140813080705.31a0901a@jbarnes-desktop>
In-Reply-To: <20140813080705.31a0901a@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 05:07 PM, Jesse Barnes wrote:
> On Fri, 8 Aug 2014 15:14:15 +0200
> Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>
>> Adding relevant mailing lists.
>>
>> On Fri, Aug 8, 2014 at 1:23 PM, Juergen Gross <jgross@suse.com> wrote:
>>> I'm just about to create a patch for full PAT support in the Linux
>>> kernel, including Xen. For this purpose I introduce a translation
>>> between cache modes and pte bits.
>>>
>>> Scanning the kernel sources for usage of the cache mode bits in the
>>> pte I discovered  drivers/gpu/drm/i915/i915_gem_gtt.h is using
>>> _PAGE_PCD, _PAGE_PWT and _PAGE_PAT. I think those defines are used
>>> to create ptes not for usage by the main processor, but for the
>>> graphics processor. Is this true? In this case I'd suggest to define
>>> i915-specific macros instead of using the x86 ones.
>>
>> Yeah, those are gpu specific PAT tables, but the hw engineers
>> specifically designed this to match, and we've tried to follow the cpu
>> side to match it. Especially in the future that will be somewhat
>> important, since we want to fully share the entire address space
>> between cpu and gpu on the next platform. Jesse is working on that.
>
> Right, we have an x86 compatible MMU in the GPU itself, so re-using the
> defines makes sense.  I suppose with your work you'll move them and
> make them a bit more opaque?  If so, we'll still want a way to get at
> them directly, or access your mapping functions for generating PTE bits
> for the GPU MMU.

Using the mapping functions I'm introducing should work, if the MMU has
an x86 compatible MSR_IA32_CR_PAT which is configured the same way as
on the x86 processor (be aware that Xen is using another MSR_IA32_CR_PAT
setting as the Linux kernel).

Juergen

