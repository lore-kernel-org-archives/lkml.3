Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab3BEW1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:27:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62815 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757573Ab3BEW06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:26:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to arm/common
Date: Tue, 5 Feb 2013 22:26:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: Felipe Balbi <balbi@ti.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Sergei Shtylyov <sshtylyov@mvista.com>, Matt Porter <mporter@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Chris Ball <cjb@laptop.org>, "Cousson, Benoit" <b-cousson@ti.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
References: <1359742975-10421-1-git-send-email-mporter@ti.com> <20130204154153.GA18237@arwen.pp.htv.fi> <20130205182848.GJ25185@atomide.com>
In-Reply-To: <20130205182848.GJ25185@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302052226.30754.arnd@arndb.de>
X-Provags-ID: V02:K0:ZslWUMaet042SX6fP8MrGb8y1qqaEslalJKMYuJulh+
 hLVDyIDBQhH+bpbFCjQIGlvTL+KIaDiFcD+h9qmOeV/mMzuCU2
 PeoDiEkX+7ogHQXQphvOA0Hj0iDimrzxcC/pd40LS+yt56hu60
 bC2VEuNbErNkgd/hf/CwKgM2jO0fmNzAAgYA6r+Yw8p/QdOtI6
 YP/Z0JRPZvVNuVf0rxWkiAdP/mm/Av3O/7tdrR2FN2CTYp+BmY
 qa6HMq0EEbfC7uccOA0neVdXBm7j26K6nGf+l/ev9jnnZsJlCj
 kPeVhHAgwxI2xmL6lwhchmleMDCkGxMcDMyrNxmkP5ZfXMbRtm
 tv8OL1Gf3sWc5cAXBq9k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2013, Tony Lindgren wrote:
> * Felipe Balbi <balbi@ti.com> [130204 07:46]:
> > 
> > Current DMA abstraction is quite poor, for example there's no way to
> > compile support for multiple DMA engines. Code also makes certain, IMO
> > unnecessary, assumptions about the underlying DMA engine (abstraction is
> > poor, as said above but it we could follow MUSB's programming guide when
> > it comes to programming DMA transfers).
> > 
> > Considering all of the above, it's far better to use DMA engine and get
> > rid of all the mess.
> 
> How about just disable MUSB DMA support if ARCH_MULTIPLATFORM for now?
> That way MUSB can be fixed up first to support ARCH_MULTIPLATFORM
> using PIO while sorting out the DMA related issues.

Sounds ok to me. Someone still needs to do the work to make the non-DMA
variants of MUSB coexist in one kernel, but as we discussed erlier, that
should be much simpler.

	Arnd
