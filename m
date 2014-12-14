Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaLNQag (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 11:30:36 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:64660 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaLNQad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 11:30:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Ray Jui <rjui@broadcom.com>, Christian Daudt <bcm@fixthebug.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        Hauke Mehrtens <hauke@hauke-m.de>, Kumar Gala <galak@codeaurora.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH v2 1/4] pci: iProc: define Broadcom iProc PCIe binding
Date: Sun, 14 Dec 2014 17:29:25 +0100
Message-ID: <3622321.f8bfUffhzH@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <548D5CD1.10801@broadcom.com>
References: <1418351817-14898-2-git-send-email-rjui@broadcom.com> <3383252.Ad6Qf0H2fa@wuerfel> <548D5CD1.10801@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:PHk1Zr7a0vRDQEFc/oiHqW6RZG+y48J1B0bxktwI5WE9sqFiTMF
 8/9gi51FzkBaqivtKpnOCVSG5CdzWkaCfMRm0LM75QfMJD//HYxeb0OzoJiMtCKZQwws3aB
 Qz3aGXkMX92Bd7K/UPLC4gQeLdIt+CFKcqy4hKKn0Y0s0VzrWIow5LY0Bhn/aLAro33xMZ0
 Bzx+/L2zZo7uKlld/XZNw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 December 2014 10:48:01 Arend van Spriel wrote:
> On 12/13/14 20:46, Arnd Bergmann wrote:
> > On Saturday 13 December 2014 11:05:52 Arend van Spriel wrote:
> >>
> >> Makes sense. I think that is what Hauke meant by "adding
> >> additional support for registering to bcma". So the discovery info is a
> >> piece of read-only memory in the chip. Its address is stored in the
> >> chipcommon core register space. BCMA parses that memory blob resulting
> >> in a list of cores which register address info. We could add DT support
> >> in BCMA matching the compatible string and register a core for it.
> >
> > Ah, interesting idea. That would mirror what we do for drivers/amba,
> > I like the idea.
> 
> + Rafal
> 
> Let's explore this. Although I don't have the iProc hardware to verify it.
> 

If we can make this work nicely, you won't even need iProc hardware,
but instead provide all the data for the bcma devices on an older
machine through DT and get the probing to work with that. For AMBA,
we actually allow mixing amba and platform devices on the same parent.
You could do this here as well, but it would be simpler to have a
a special bcma device node as the parent that does the probing, in order
to avoid adding bcma specific code to drivers/of/platform.c

	Arnd
