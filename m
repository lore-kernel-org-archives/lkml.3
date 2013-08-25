Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab3HYU2n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 16:28:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65332 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab3HYU2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 16:28:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH V2] PCI: exynos: add support for MSI
Date: Sun, 25 Aug 2013 22:28:20 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Pratyush Anand <pratyush.anand@st.com>, Jingoo Han <jg1.han@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        Siva Reddy Kallam <siva.kallam@samsung.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        "'Sean Cross'" <xobs@kosagi.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <003d01ce9fc6$9c0f1c20$d42d5460$%han@samsung.com> <20130823083539.GB3937@pratyush-vbox> <20130823092238.GJ3535@ulmo>
In-Reply-To: <20130823092238.GJ3535@ulmo>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201308252228.20843.arnd@arndb.de>
X-Provags-ID: V02:K0:Vo0VTtKpmEXPvG0D3Mt4ym15d72hUgMNgYoCjEWiQsb
 g8WbQTJxmeYf9K38ObIIjT0kC8dJfsZq0/Mgcqijg4156COv8X
 nxi49o9KHpnUkbHl6zXgy5o+TeHcm64LGTnHw7P6CHTupMnMiv
 XVscpVR+wLsiM1vk70Bx/c/EoECUBOsLuBCuNO5Gnl1Vo4xaKU
 al0LNEYNv6FQoxMOBGdIiHhIkpceokacwpyUihQJrjd/8OlKPO
 Ann3HlRTRdtUX/aqQIIP4soZL6GUe9DzuhTDswQtRIciqRKTPh
 dqkUKoNimW2wM0VvmhGXqMfAVLjxjCPurQRnYOSmmktjrxJgjL
 uc2zTvqSyF18PGoK7/7w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 August 2013, Thierry Reding wrote:
> > > +       if (IS_ENABLED(CONFIG_PCI_MSI)) {
> > > +               if (of_property_read_u32(np, "msi-base", &pp->msi_irq_start)) {
> > > +                       dev_err(pp->dev, "Failed to parse the number of lanes\n");
> > > +                       return -EINVAL;
> > > +               }
> > > +       }
> > > +
> > 
> > What if an implementor want to use irq_domain method for msi_irq_start
> > allocation? Is it fine to return error if msi-base is not passed from
> > dt?
> 
> I agree. This should be using an IRQ domain to represent the MSI
> controller. Both Tegra and Marvell drivers do that already and if Exynos
> can follow that same path it will increase the chances of refactoring
> common bits.
> 
> Also the error message doesn't quite match up with what the code is
> doing. =)

Agreed. Besides the encoding of "base" irq values in the device tree is always
wrong, since the numbers are not at all a hardware property but an implementation
detail of how Linux currently uses interrupt numbers. When using DT probing,
you *have* to use IRQ domains, and the rest of Exynos does that.

	Arnd
