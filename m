Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbaIZVNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 17:13:16 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:42270 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908AbaIZVNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 17:13:15 -0400
MIME-Version: 1.0
In-Reply-To: <5425D5CD.4000002@nvidia.com>
References: <CAOnawYp7kv7Zjn4j-j4-TUOshE9G1uXWEqXB_=RHePNwNLmwWA@mail.gmail.com>
	<CA+55aFwX_nV9oUjh6u5WY=jpLxN-a5GFLmXQWDbHW0Yom9OOVA@mail.gmail.com>
	<1411504140.4184.26.camel@pasglop>
	<5425D5CD.4000002@nvidia.com>
Date: Fri, 26 Sep 2014 17:13:14 -0400
X-Google-Sender-Auth: CuK2P3AZ3w28STz5vNM64nRrJIM
Message-ID: <CAKb7Uvguk-tZkEC61uCPPo0_LWFTDyZAzWYk9jOCsqoZDtUr7g@mail.gmail.com>
Subject: Re: Stupid NVIDIA 3D vgaarb.c patch
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Aaron Plattner <aplattner@nvidia.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?B?QyBCZXJnc3Ryw7Zt?= <cbergstrom@pathscale.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        DRI <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 5:08 PM, Aaron Plattner <aplattner@nvidia.com> wrote:
> On 09/23/2014 01:29 PM, Benjamin Herrenschmidt wrote:
>>
>> On Mon, 2014-09-22 at 13:43 -0700, Linus Torvalds wrote:
>>>
>>> Adding proper people and mailing lists..
>>>
>>> The PCI_CLASS_DISPLAY_VGA test goes back to the very beginning by
>>> BenH, and I have no idea if adding PCI_CLASS_DISPLAY_3D is
>>> appropriate, but hopefully somebody does. The fact that it makes
>>> things work certainly argues fairly convincingly for it, but I want
>>> some backup here.
>>>
>>> Dave, BenH?
>>>
>>> Christopher(?), can you please also specify which laptop etc. And the
>>> patch itself seems to have come from somebody else, unless you're
>>> Lekensteyn. So we'd want to get the provenance of that too.
>>
>>
>> Hrm, that sucks. "3D" could mean anything really, we might need an
>> explicit vendor ID check as well and maybe even device ID ...
>
>
> If my understanding is correct, the board designers explicitly mark them as
> "3D controller" when they don't have any outputs connected, specifically so
> the SBIOS won't choose them as the boot VGA device. Depending on the design,
> some GPUs on these 3D controller boards don't have a display engine at all,
> while others still have it in the silicon but leave it disabled at runtime.
> In either case, VGA should not be routed to them and I don't think they
> should need to participate in VGA arbitration.

Without commenting on the vga aspects of this discussion (about which
I know next to nothing), I'm moderately sure the nouveau team has seen
optimus setups where the secondary GPU reports itself as a 3d
controller, but has a working display engine, and outputs connected to
it. And I believe the inverse has also happened (a device that reports
itself as VGA but has no outputs advertised and a potentially-absent
display engine).

  -ilia
