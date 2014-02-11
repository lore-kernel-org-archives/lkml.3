Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbaBKOjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 09:39:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59778 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaBKOjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 09:39:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
Cc: Pratyush ANAND <pratyush.anand@st.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        spear-devel <spear-devel@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH V5 4/8] phy: st-miphy-40lp: Add skeleton driver
Date: Tue, 11 Feb 2014 15:38:51 +0100
Message-ID: <10315753.nkNxr0yDnp@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <2CC2A0A4A178534D93D5159BF3BCB66189FD2CAA9B@EAPEX1MAIL1.st.com>
References: <cover.1391871170.git.pratyush.anand@st.com> <201402101654.22187.arnd@arndb.de> <2CC2A0A4A178534D93D5159BF3BCB66189FD2CAA9B@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:dUYOEPYFYgbjZudzzyTYtlCkIUnbE6NYGE++6H0eRY6
 3axJRYwFWaLm9VVSb2HGG8u05sXjYvbHW6hutuvwjZUXmKXtmR
 Iwml7ItPKn51IfUDlEYm6shmK30r3B/R0c/scX3tSRXNu9utwR
 R8bGP/64nP+t0LYRVGDz2A3D8b+crvSyhU8w9pjDLhe/FQYHxQ
 2CurYUADUXAnUENgaTRslcORO8ed9Xfk5oGNz8KR6WnSINd1Ta
 JE1oiu6E2jOzpEZ2RKi1ZRvgHUTRBEAyg8r8nohhsYxgYBQck7
 1so/bUZA+ycBLdqa/7gLmMgSylj72ImSjhMtYaYmFvhgWVQInO
 6N2ku8n8C0xkYZxlDFsk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 February 2014 11:57:46 Mohit KUMAR DCG wrote:
> 
> > Maybe mention that this phy is used inside the spear13xx
> > SoC here rather than a standalone phy.
> 
> - Yes, for spear13xx its used internally. Do you think that
> it requires to be mentioned here? 
> We have few prototype boards that uses this as external phy.

[adding Lee since he mentioned working on a similar part]

I'm a bit confused. Is it actually the same IP block that can
be used internally as part of a SoC and as a standalone chip?

Since some of the settings of the PHY are controlled through
the misc register in case of spear13xx, I assume that part
is different on the standalone version. How do you actually
select the mode in that case?

It would certainly be helpful to explain this somewhere,
and the binding might not be the worst place for this.

On a related note, the driver in its current shape looks
a bit silly since it doesn't contain any of the miphy specific
code but only the SoC specific parts (as I suggested you
do, so I'm not blaming you :-)) and a multiplexer that
switches between the two possible implementations.

What is your plan for the future, do you intend to add
the actual miphy code soon, or is that something you just
want to leave as an option for the future but have no
specific plans to do right now? If not, the driver
would probably look nicer if it were split into two
separate implementations, one for each spear13xx SoC
and with a separate set of phy_ops but no multiplexer.
The connection to the miphy code (if you want to keep
your options open) could be done by implementing some
kind of nested phy model where the st,spear1340-phy contains
another "phys" property pointing to the st,miphy40 node
and the driver just calls the slave phy_ops recursively,
or the sata and pcie nodes actually link to two phy nodes
that are separate from one another.

	Arnd
