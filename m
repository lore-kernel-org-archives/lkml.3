Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaIYKpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:45:35 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:63339 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaIYKpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:45:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Robert Richter <robert.richter@caviumnetworks.com>,
        Robert Richter <rric@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <Will.Deacon@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Sunil Goutham <sgoutham@cavium.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] arm64, defconfig: Enable PCI
Date: Thu, 25 Sep 2014 12:45:20 +0200
Message-ID: <21218217.YUcdQIZ4A8@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140925093545.GE10390@e104818-lin.cambridge.arm.com>
References: <1411573068-12952-1-git-send-email-rric@kernel.org> <3120493.DIoQFCi5Am@wuerfel> <20140925093545.GE10390@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:is/8rrR2gGYA4vJ5F1yjgfIqfMpssGcOr0foPVdagwQ
 JKCKTinpaIdmH0OFxyZmPO6JYK957iXSl0ygOWJ/s/9IX2Vk4b
 E67He4GTYV9VtuMu7HPNLrWEfXUd26jr1cHcb9vbHkeJWzU4k0
 AV5c23UA25DP99dnkpfaaCnU+AjXh0+drnYgT1qR4CWDThKcG1
 lL6ojP/f2dQT88ok8IPvpS0P7phFfL9hnmnzlPkCAnlVST/5Om
 HUDsaIJo5eyCCWKYYTc9oiDzZtJaCtgUBzJtzYjl3oT/uTPNdo
 TjgfZ6AhggDApIpG15ML2etCdboCz2glkRvzpYSIlg4c6Uk4cR
 LWQqEHALJq7JXMqZ0jSg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 September 2014 10:35:45 Catalin Marinas wrote:
> On Wed, Sep 24, 2014 at 07:40:18PM +0100, Arnd Bergmann wrote:
> > On Wednesday 24 September 2014 18:10:48 Catalin Marinas wrote:
> > > > The intention is not to have a second definition, instead this should
> > > > enable the default value just for arm64. Thus I put it to
> > > > arch/arm64/Kconfig. Otherwise it would be enabled per default on all
> > > > archs.
> > 
> > I don't think other architectures actually see the PCI symbol that is
> > defined in the arm64 Kconfig file, but I might be wrong.
> 
> Other archs wouldn't see the symbols in arch/arm64/Kconfig.

Ok.

> > > > We could have used select in config ARM64, but I tried to avoid using
> > > > select due to the dependency issue and instead implement this with
> > > > default-y/depends-on. Doing so it can be manually disabled too.
> > 
> > How about adding a new symbol like
> > 
> > config ARM64_PCI
> >       def_bool PCI
> >       select PCI_MSI
> 
> How is this different from just selecting PCI_MSI in config PCI in
> arch/arm64/Kconfig? I don't see what another symbol brings.

That suggestion was just in case I was wrong above. If the symbol
is indeed hidden elsewhere, we don't need it.

	Arnd
