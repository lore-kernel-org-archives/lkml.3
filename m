Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbaLARXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:23:44 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:55860 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbaLARXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:23:42 -0500
Date: Mon, 1 Dec 2014 09:22:19 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Stefan Agner <stefan@agner.ch>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "arnd@arndb.de" <arnd@arndb.de>, "sre@kernel.org" <sre@kernel.org>,
        "fkan@apm.com" <fkan@apm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] power: reset: read priority from device tree
Message-ID: <20141201172219.GA24692@roeck-us.net>
References: <1417453389-1588-1-git-send-email-stefan@agner.ch>
 <1417453389-1588-2-git-send-email-stefan@agner.ch>
 <20141201171126.GB22708@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201171126.GB22708@leverpostej>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.547CA41E.01E2,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 14
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 05:11:26PM +0000, Mark Rutland wrote:
> On Mon, Dec 01, 2014 at 05:03:07PM +0000, Stefan Agner wrote:
> > This patch adds an optional property which allows to specify the
> > reset source priority. This priority is used by the kernel restart
> > handler call chain to sort out the proper reset/restart method.
> > Depending on the power design of a board or other machine/board
> > specific peculiarity, it is not possible to pick a generic priority.
> > 
> > Signed-off-by: Stefan Agner <stefan@agner.ch>
> > ---
> >  Documentation/devicetree/bindings/power/reset/syscon-reboot.txt | 3 +++
> >  drivers/power/reset/syscon-reboot.c                             | 5 ++++-
> >  2 files changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
> > index 1190631..ee41d9c 100644
> > --- a/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
> > +++ b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
> > @@ -11,6 +11,9 @@ Required properties:
> >  - offset: offset in the register map for the reboot register (in bytes)
> >  - mask: the reset value written to the reboot register (32 bit access)
> >  
> > +Optional properties:
> > +- priority: define the priority of the reset (0-255, defaults to 128)
> > +
> 
> NAK. This is a leak of Linux-internal details.
> 
> What is this necessary for?
> 
It establishes which restart handler to use if there more than one means
to reset the system. See documentation to register_restart_handler() in
kernel/reboot.c.

Guenter
