Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaFDNyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:54:54 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:61758 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbaFDNyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:54:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Hiroshi Doyu <hdoyu@nvidia.com>, Rob Herring <robherring2@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Date: Wed, 04 Jun 2014 15:53:27 +0200
Message-ID: <5349895.mRr9cbXPnm@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140604134400.GE28484@ulmo>
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com> <4462924.8iRbdkOPp7@wuerfel> <20140604134400.GE28484@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:g45tqTdXx0AOt++gZ1enrWRZ5enDEa5GbWXWIdqyiWP
 0wRRrWpOQJCVkh+kRz6ZeGmDIbTtpUDRn9DyOft1kAO9b+TJSx
 Rtl6tpcmjdfn31PgXr0seUfQP+rMrpfWeDJ6Nq3PL/sE6rh8vr
 JmXS2AfahtEXOubIq+Ki0W7alrLY8RUB6CkUL1E3zyfa1XKTgx
 m7KuqQaYgmade31XlsB+Z3aO5kqrxd7ofHYcKrB5VPRag0NJ0k
 nt+TqUDx/Ikodp6iEvzh5wuOpG0W9G55yEhF4CAAhocVcYUBzH
 QTBawbupeRODLwx/l08S+Vkswd3Y3+2hBTNlHdsipKZWrr8nTz
 YpjZVO2XEjd/xsECJo3U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 June 2014 15:44:03 Thierry Reding wrote:
> > Well, the iommu specific binding could allow a variable #address-cells.
> > That way, you just need to know the number of stream IDs for that instance
> > of the iommu.
> 
> That sounds fairly complicated to me. I don't see what that buys us over
> the clarity and simplicity that the above explicit notation gives us. Is
> it not more common for a device to have a single master rather than a
> whole bunch of them?

If I understood the problem right, the case that people want to handle
is not actually multiple masters but instead multiple IOMMU contexts, which
you can have in a GPU to handle multiple processes drawing on different
parts of the screen, or in a NIC with virtual functions assigned to KVM
guests or user processes. I don't know what the number of contexts per
device would be here, but I assume it may be large enough to become
a nuisance to list them individually.

Then again, I also don't know how IOMMUs would show those. In the cases
I've seen before, you actually have an ID for the master that is separate
from the context ID, but apparently SMMU isn't that smart.

	Arnd
