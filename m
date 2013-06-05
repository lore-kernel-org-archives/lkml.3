Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab3FEW1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:27:32 -0400
Received: from vps1.hno.se ([31.192.227.87]:50236 "EHLO vps1.hno.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757778Ab3FEW1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 18:27:30 -0400
Message-ID: <1370468873.18839.22.camel@localhost>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
From: Henrik =?ISO-8859-1?Q?Nordstr=F6m?= <henrik@henriknordstrom.net>
To: Linux on small ARM machines <arm-netbook@lists.phcomp.co.uk>
Cc: "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org,
        ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>,
        debian-kernel@lists.debian.org
Date: Wed, 05 Jun 2013 23:47:53 +0200
In-Reply-To: <CAPweEDzDC87KmOQ=0hyPcjPtPsRuXHxNTs97vbEqVNNnix69rA@mail.gmail.com>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	 <CAKON4OxDD5orX2w-_+d5kawTGXbE3KKj2QLERo9m7=NiUSXhgQ@mail.gmail.com>
	 <CAPweEDzDC87KmOQ=0hyPcjPtPsRuXHxNTs97vbEqVNNnix69rA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ons 2013-06-05 klockan 22:15 +0100 skrev Luke Kenneth Casson Leighton:

> what we do not want to happen is that they see upstream patches being
> submitted, they merge them into their internal tree (which to date has
> had zero upstream changes: they're currently only just getting round
> to doing 3.4 as we speak), and they *completely* ignore *absolutely
> everything* that's being done by the community, duplicating yet
> another set of device drivers (named drivers/*/sun8i_* and so on).

Well, that will obviously happen one or two more rounds, a bit depending
on which kernel releases Android will use. But I hope the Allwinner
kernel team will rethink when they hit more current kernels.

>  this proposal is a start: however what you have to bear in mind is
> that you now have to convince a very busy company that it is in their
> best interests to disrupt their schedule, to drop their existing
> working practices, to tell all their customers "please stop using the
> existing tools and please use these ones instead".

Why?

>  you also need to convince the creators of the proprietary
> firmware-flashing tools "livesuite" and "phoenix" to *also* convert
> their tools over to the new proposed idea.

Why?

>  can you provide such a supporting argument which would convince
> allwinner to accept the modifications to their working practices that
> you propose?

It does not really need to be such big modifications to their working
practices. Their configuration working practices is all built around the
fex file, and the new practices can be

0. Assuming kernel drivers gets ported over to using device tree.

1. Do configuration as you have always done in the .fex

2. Modify the build script to build a device tree from the fex +
template, in addition to script.bin.

3. Tell u-boot to load the device tree for the kernel.

That's it really.

licesuit do not modify script.bin. script.bin is compiled from the .fex
at image creation time. A couple more lines in the build script (and a
suitable translation tool) and there is also a device tree built and
installed and you get a nice and smoot transition.

> > Device tree on ARM's goal is to achieve a single kernel across vendors, not
> > just a single kernel for a single vendor.
> 
>  you'll be aware that i've mentioned a number of times and have
> discussed at some length why this is a goal that is completely
> impossible to achieve [*1].  sadly.

Here I disagree. It is possible. Not across all vendors but a
significant share.

Regards
enrik

