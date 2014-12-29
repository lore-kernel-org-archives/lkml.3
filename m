Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaL2TKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 14:10:03 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:58678 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaL2TKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 14:10:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Eddie Huang <eddie.huang@mediatek.com>
Cc: Rob Herring <robherring2@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, srv_heupstream@mediatek.com,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>, yingjoe.chen@mediatek.com,
        yh.chen@mediatek.com
Subject: Re: [PATCH 1/2] tty: serial: 8250_mtk: Add earlycon
Date: Mon, 29 Dec 2014 20:08:59 +0100
Message-ID: <16342339.NQnBcp9YuE@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1419827096.6184.128.camel@mtksdaap41>
References: <1418891601-53769-1-git-send-email-eddie.huang@mediatek.com> <CAL_JsqKp+1ZWPK4rB4_vxrx-dtNCy7Hc3S67uQ9VHdAby8erjg@mail.gmail.com> <1419827096.6184.128.camel@mtksdaap41>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:SucAS9NHwG6g20ibYlhYkgo45o4oHBhypLs6z0u4GehEFiAtLJP
 XbXi4ZDq2bHA2j5C/G7pszX5slV5feFRH3RG1d/BzBC7qllPlYR4xeUHa2WtoymiJb1DLym
 FIhwOCDNY3KQP9gjKsiIYhsStwonv5JeAsJI320EYX8NDHI0srGHmEcAH4fAgY9zwLpBrBQ
 HpDjQO+BgaJxL+fHi/Ckw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 December 2014 12:24:56 Eddie Huang wrote:
> Hi Rob,
> 
> On Fri, 2014-12-26 at 15:24 -0600, Rob Herring wrote:
> > On Thu, Dec 18, 2014 at 2:33 AM, Eddie Huang <eddie.huang@mediatek.com> wrote:
> > > Mediatek UART has highspeed register, but 8250_early.c doesn't
> > > support this, so add earlycon in 8250_mtk.c
> > 
> > I don't see any highspeed register setup here. More generically,
> > aren't you just skipping any UART setup? That may be useful on other
> > platforms with 8250s, too. With the kernel command line version, you
> > could perhaps add a "noinit" flag. The DT case is harder, and I'm not
> > sure how we should handle that. We could perhaps add a
> > "stdout-path-initialized" flag to chosen.
> > 
> 
> Yes, I skipped UART setup same as msm_serial.c and amba-pl011.c
> (although they are standalone serial driver). Just like earlyprintk, I
> think earlycon should reuse UART setting in loader. Since some other
> platforms with 8250 already depend on this, it's ok to add flags to
> distinguish whether 8250 earlycon driver should init hw or not. As you
> said, add "noinit" flag is simple, but "stdout-path-initialized" need
> more discussion. 

It would definitely be nice to have consistent behavior, and I also
think it would be good to default to noinit for the console, because that
is the more likely case. Basically anything that can do debug_ll on ARM
already depends on this behavior because the debug_ll infrastructure
does not initialize the console before using it. I believe the same
is true for powerpc udbg.

	Arnd
