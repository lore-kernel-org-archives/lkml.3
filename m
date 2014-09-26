Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbaIZVIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 17:08:32 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:4430 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908AbaIZVIb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 17:08:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 26 Sep 2014 14:08:34 -0700
Message-ID: <5425D5CD.4000002@nvidia.com>
Date: Fri, 26 Sep 2014 14:08:29 -0700
From: Aaron Plattner <aplattner@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: =?UTF-8?B?QyBCZXJnc3Ryw7Zt?= <cbergstrom@pathscale.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        DRI <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Stupid NVIDIA 3D vgaarb.c patch
References: <CAOnawYp7kv7Zjn4j-j4-TUOshE9G1uXWEqXB_=RHePNwNLmwWA@mail.gmail.com> <CA+55aFwX_nV9oUjh6u5WY=jpLxN-a5GFLmXQWDbHW0Yom9OOVA@mail.gmail.com> <1411504140.4184.26.camel@pasglop>
In-Reply-To: <1411504140.4184.26.camel@pasglop>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2014 01:29 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2014-09-22 at 13:43 -0700, Linus Torvalds wrote:
>> Adding proper people and mailing lists..
>>
>> The PCI_CLASS_DISPLAY_VGA test goes back to the very beginning by
>> BenH, and I have no idea if adding PCI_CLASS_DISPLAY_3D is
>> appropriate, but hopefully somebody does. The fact that it makes
>> things work certainly argues fairly convincingly for it, but I want
>> some backup here.
>>
>> Dave, BenH?
>>
>> Christopher(?), can you please also specify which laptop etc. And the
>> patch itself seems to have come from somebody else, unless you're
>> Lekensteyn. So we'd want to get the provenance of that too.
>
> Hrm, that sucks. "3D" could mean anything really, we might need an
> explicit vendor ID check as well and maybe even device ID ...

If my understanding is correct, the board designers explicitly mark them 
as "3D controller" when they don't have any outputs connected, 
specifically so the SBIOS won't choose them as the boot VGA device. 
Depending on the design, some GPUs on these 3D controller boards don't 
have a display engine at all, while others still have it in the silicon 
but leave it disabled at runtime.  In either case, VGA should not be 
routed to them and I don't think they should need to participate in VGA 
arbitration.

-- Aaron

> Ben.
>
>>                  Linus
>>
>> On Mon, Sep 22, 2014 at 1:28 PM, C Bergström <cbergstrom@pathscale.com> wrote:
>>> Hi Linus,
>>>
>>> I don't know who the original author is and I can have one of the distro
>>> graphics friends review it, but I need this patch below to get NVIDIA
>>> drivers to work (without using any Intel graphics) on my laptop
>>> http://pastebin.com/wpmFi38k
>>>
>>> Sorry - I know this is not the proper way to submit a patch, but it's
>>> trivial and I'm not a kernel dev.
>>>
>>> Thanks
>>>
>>> ./C
