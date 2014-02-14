Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaBNSiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:38:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:43837 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbaBNSiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:38:19 -0500
Date: Fri, 14 Feb 2014 19:38:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Conrad Kostecki <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: AW: AW: [PATCH] x86: HPET force enable for Soekris net6501
In-Reply-To: <52FE5ED4.4040508@zytor.com>
Message-ID: <alpine.DEB.2.02.1402141924170.21991@ionos.tec.linutronix.de>
References: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5683.6030708@zytor.com> <aedabafbb1f0433c9d67ee998971150c@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5BB6.9070405@zytor.com> <1051d374173243b2828efcd21f60ac36@DB4PR04MB265.eurprd04.prod.outlook.com>
 <52FE5D91.6060005@zytor.com> <alpine.DEB.2.02.1402141917320.21991@ionos.tec.linutronix.de> <52FE5ED4.4040508@zytor.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014, H. Peter Anvin wrote:
> On 02/14/2014 10:21 AM, Thomas Gleixner wrote:
> > I wish we could just use devicetree for such cases and fix the crud
> > ourself.
> > 
> 
> We'd have to identify the platform, which is the main problem.  Right
> now we support quirking for DMI or PCI, but I don't think we do for MPTABLE.

My point is that device tree support for some basic stuff like
hpet/ioapic and such would allow people like Conrad to avoid the
stupid hackery of quirks.

Building your own DT requires to read a datasheet as does hacking a
quirk, but its definitely simpler. And we can collect the DTs for
known boards either in the kernel or in some external repository.

People who are dealing with embedded stuff are not those who are
frightened by datasheets and building a custom kernel with some extra
blob.

I bet Conrad is also stuck with PIC on the E6xx CPU and that's a major
PITA. I have such a board as well and it simply sucks.

Now you can't hack an ioapic quirk because that's way to complex, but
we have proven with the ce4100 that it is reasonably simple to get
that stuff working nicely when you can read a datasheet. If we could
generalize that for a few crucial devices that would help a lot.

When I asked the board vendor why there are no acpi tables in the
device, I got the answer, that this is an embedded board and the
"BIOS" built with BLDK does not support that. We all know that's not
true, but how does that help?

The people who brought up the initial target OS (WinCE) on that board
worked around the lack of ACPI by hacking HPET support into the CE
preloader and switched all device drivers to use MSI because CE failed
to handle the PIC properly. That avoided that they needed to hack the
ioapic into submission as well.

That's the sad reality. And we have to cope with these boards whether
we like it or not.

Thanks,

	tglx








