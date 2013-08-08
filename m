Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966741Ab3HHVb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:31:29 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:40868 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966621Ab3HHVb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:31:27 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Julius Werner <jwerner@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
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
Subject: Re: [PATCH 1/3 v5] usb: phy-samsung-usb: Simplify PMU register handling
Date: Thu, 08 Aug 2013 23:31:18 +0200
Message-ID: <1729120.r596vOTlMW@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.4-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAODwPW-j=JjunZU3zewrE1_-WoW-RXLmKVQypzxmo_BOYjc3VA@mail.gmail.com>
References: <1375812017-6287-1-git-send-email-jwerner@chromium.org> <20130808092615.GF14648@e106331-lin.cambridge.arm.com> <CAODwPW-j=JjunZU3zewrE1_-WoW-RXLmKVQypzxmo_BOYjc3VA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julius,

On Thursday 08 of August 2013 11:06:54 Julius Werner wrote:
> > I'm not sure I understand. The old documentation referred to the
> > USBDEVICE_PHY_CONTROL and USBHOST_PHY_CONTROL registers for a phy, and
> > your new version only refers to (usb device) PHY_CONTROL. Regardless
> > of
> > multiple phys, you're suggesting that we describe less of each phy.
> > That seems like taking away usable information. Unless I've
> > misunderstood?
> 
> Well that's just the thing that's confusing right now, and which I am
> trying to fix: every PHY is either DEVICE or HOST and thus has only
> one PMU register. The current code describes the PMU register space
> for all PHYs on the system in the DT entry of every PHY and then
> calculates which register to use with hardcoded offsets. I think it
> makes much more sense if every PHY only describes its own register and
> doesn't need to do address arithmetic later on.
> 
> As Vivek said there is one exception in an old Exynos4,

Not that old yet. :)

> but that is
> currently not implemented in the upstream kernel anyway

Sorry, I don't understand what is not implemented. Without your patch, the 
PHY driver handles both PMU registers of Exynos4.

Best regards,
Tomasz

> , and if it
> ever will be it's still much easier to special case one weird chip
> than to have a super complicated and confusing mechanism for all of
> them.
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
