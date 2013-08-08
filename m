Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965980Ab3HHSG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 14:06:57 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:47908 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3HHSGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 14:06:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130808092615.GF14648@e106331-lin.cambridge.arm.com>
References: <1375812017-6287-1-git-send-email-jwerner@chromium.org>
	<20130807163045.GK28558@e106331-lin.cambridge.arm.com>
	<CAODwPW9DmVdzHbHN0NUK0fYUNw0tj2ktyh-20no30r14_JayFQ@mail.gmail.com>
	<20130808092615.GF14648@e106331-lin.cambridge.arm.com>
Date: Thu, 8 Aug 2013 11:06:54 -0700
X-Google-Sender-Auth: k0NIGgMv6Uws0san_OE_Yb6a97Q
Message-ID: <CAODwPW-j=JjunZU3zewrE1_-WoW-RXLmKVQypzxmo_BOYjc3VA@mail.gmail.com>
Subject: Re: [PATCH 1/3 v5] usb: phy-samsung-usb: Simplify PMU register handling
From: Julius Werner <jwerner@chromium.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Julius Werner <jwerner@chromium.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not sure I understand. The old documentation referred to the
> USBDEVICE_PHY_CONTROL and USBHOST_PHY_CONTROL registers for a phy, and
> your new version only refers to (usb device) PHY_CONTROL. Regardless of
> multiple phys, you're suggesting that we describe less of each phy.
> That seems like taking away usable information. Unless I've
> misunderstood?

Well that's just the thing that's confusing right now, and which I am
trying to fix: every PHY is either DEVICE or HOST and thus has only
one PMU register. The current code describes the PMU register space
for all PHYs on the system in the DT entry of every PHY and then
calculates which register to use with hardcoded offsets. I think it
makes much more sense if every PHY only describes its own register and
doesn't need to do address arithmetic later on.

As Vivek said there is one exception in an old Exynos4, but that is
currently not implemented in the upstream kernel anyway, and if it
ever will be it's still much easier to special case one weird chip
than to have a super complicated and confusing mechanism for all of
them.
