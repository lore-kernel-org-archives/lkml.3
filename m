Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaENTKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:10:19 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:64343 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaENTKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:10:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, devicetree@vger.kernel.org,
        Antoine =?ISO-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        linux-kernel@vger.kernel.org, kishon@ti.com, linux-ide@vger.kernel.org,
        alexandre.belloni@free-electrons.com, jszhang@marvell.com,
        tj@kernel.org
Subject: Re: [PATCH v3 1/6] phy: add a driver for the Berlin SATA PHY
Date: Wed, 14 May 2014 21:10:09 +0200
Message-ID: <5701370.bQb4QoHk6c@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5373BC5D.7010300@gmail.com>
References: <1400060942-10588-1-git-send-email-antoine.tenart@free-electrons.com> <17808571.N5ZGjXFEVP@wuerfel> <5373BC5D.7010300@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:05T4ZZtxvzotkSE2iYq3r0a1DO7Z9SEPVdj1oFX8SDQ
 ++kF/V+ueGJm8dNxuJ+EWxGGLI/JX1zvW7kt/kYo9SbL5oSdY+
 GeLL7OVz3O9OMXx21dalDf2+z3xB99RHJPuSRwJUMwi6RzrnAz
 ZSbsZnc3q1WfBLR3B9ERvDCUymGk/HbBiamu/hBl8EPh5flUz7
 ACezXASQ/tEame9XR8Da4wIRAVCGMPsX701KYnQtJtHbl09+rZ
 A3x0fpW28RRnxfWZAqIheOZ7FZBhAkXsa/OUOGs9rmQYhAhXMo
 XumAW3DR4c6wX1bXS2NAOcvE457zSXtrz1ZLwTWovlcMFykjk6
 6x9n5Fgu9jQEnFbYAJXc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2014 20:56:29 Sebastian Hesselbarth wrote:
> On 05/14/2014 08:51 PM, Arnd Bergmann wrote:
> > On Wednesday 14 May 2014 20:42:16 Sebastian Hesselbarth wrote:
> >>>> For the driver, Antoine then would have to squeeze all PHY register
> >>>> mangling in phy-berlin2.c and see how to make ahci-platform aware of
> >>>> individual port nodes (I haven't looked up if it already exists, sorry)
> >>>> and announce only enabled port child nodes, right?
> >>>
> >>> I've been thinking some more about this aspect. I don't actually have
> >>> a strong opinion on whether it's better to use the generic ahci-platform
> >>> driver, or to keep the multi-phy support as a special variant for
> >>> berlin. If we do the latter, it would however be good to define the
> >>> binding in a way that lets us later merge things into the generic phy
> >>> driver in case we get more of the same.
> >>
> >> Hmm, IMHO multi-phy support is orthogonal to ahci-platform, isn't it?
> >> ahci-platform needs to know about the phy property and calls some
> >> helper that deals with the phy-specifier?
> >>
> >> About a generic _phy_ driver, I am not so sure if berlin is the best
> >> template right now 
> >>
> >> So, my call would be:
> >> - make ahci-platform aware of port sub-nodes and phy properties
> >> - have a berlin specific PHY driver
> > 
> > I'm not sure if we need sub-nodes per port, it should be enough
> > to have an array of phys, plus a way to match them up with the
> > ports.
> 
> Actually, I'd love to see sub-nodes per port as it will allow to
> disabled unused ports on a per-board basis.
> 
> I have this in mind for a long time for Kirkwood's SATA node already:
> Consider a board where you have the one available SATA plug connected
> to port 1. How would that work out with status = "disabled"/"okay" that
> doesn't allow array of strings obviously?

A simple bit mask would work fine, but I see your point. Doing
status="disabled" per port sounds nice.

	Arnd
