Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaAPVaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 16:30:52 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:53537 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaAPVas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 16:30:48 -0500
MIME-Version: 1.0
In-Reply-To: <20140108211610.GC12358@obsidianresearch.com>
References: <20131210193947.GU5429@obsidianresearch.com>
	<CAL_JsqLpWSXd44ErAs=+xYS8ESaBSY6EJEneZFYqtbpfyM4iPQ@mail.gmail.com>
	<20140108211610.GC12358@obsidianresearch.com>
Date: Thu, 16 Jan 2014 15:30:48 -0600
Message-ID: <CAL_JsqJ+0kyPUmRQr0BVnR+2GrOdLOMqjzgghZ9HnhODtKtwOw@mail.gmail.com>
Subject: Re: [PATCH] dt: Document a compatible entry for MDIO ethernet Phys
From: Rob Herring <robherring2@gmail.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 3:16 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Wed, Jan 08, 2014 at 12:37:03PM -0600, Rob Herring wrote:
>
>> > Patch to parse this compatible string to follow if this binding is
>> > acceptable.
>>
>> One minor comment below, otherwise:
>>
>> Acked-by: Rob Herring <robh@kernel.org>
>
> K, I'll send a series hopefully in a few weeks after some travel.
>
>> > +  If the phy's identifier is known then the list may contain an entry
>> > +  of the form: "ethernet-phy-idAAAA,BBBB" where
>>
>> I think this should be a period rather than a comma as we are not
>> separating a vendor ID from product ID.
>
> OK, that makes sense.
>
> Inspecting further, the format of the 32 bit AAAABBBB is actually
> broken out into:
>   OUI[3:18] || OUI[19:24] || MODEL[5:0] || REV[3:0]
>
> So a possible choice with the 'vendor ID,product ID' split is:
>   ethernet-phyOOOOO,MM.R
>
> xlate is:
>
> AAAABBBB = ((OOOOO >> 6) << 16) |
>            ((OOOOO & 0x3f) << 10) |
>            (MM << 4) |
>            R
>
> Which doesn't textually match the register value, or any other
> phy ID constants in the kernel, however makes more sense from the
> 'vendor ID,product ID' angle.
>
> Eg a Marvell 88E1310 would encode into the two options as:
>   ethernet-phy05043,29.0
>   ethernet-phy-id0141.0e90
>
> And the kernel has constants like this:
> include/linux/marvell_phy.h:#define MARVELL_PHY_ID_88E1318S 0x01410e90
>
> In light of this detail do you still like 'ethernet-phy-id0141.0e90' ?

I'm fine either way. Separating out the OUI had crossed my mind. That
probably does make the value in the DT more meaningful. Is the OUI
used anywhere in the kernel?

Rob
