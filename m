Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845Ab3GZUqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:46:00 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:46932 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759648Ab3GZUp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:45:58 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, akpm@linux-foundation.org,
        grant.likely@linaro.org, rob.herring@calxeda.com, rob@landley.net,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        gg@slimlogic.co.uk, kishon@ti.com, Stephen Warren <swarren@nvidia.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH] drivers/rtc/rtc-palmas.c: support for backup battery charging
Date: Fri, 26 Jul 2013 22:45:50 +0200
Message-ID: <28643641.Vi84qGI4SB@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <51F2985F.60202@wwwdotorg.org>
References: <1374755343-32573-1-git-send-email-ldewangan@nvidia.com> <51F2985F.60202@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 of July 2013 09:40:15 Stephen Warren wrote:
> (CC'ing the new DT binding maintainers and mailing list on this reply,
> hence quoting the whole of the DT binding)
> 
> On 07/25/2013 06:29 AM, Laxman Dewangan wrote:
> > Palmas series device like TPS65913, TPS80036 supports the backup
> > battery for powering the RTC when no other energy source is
> > available.
> > 
> > The backup battery is optional, connected to the VBACKUP pin, and can
> > be nonrechargeable or rechargeable. The rechargeable battery can be
> > charged from the system supply using the backup battery charger.
> > 
> > Add support for enabling charging of this backup battery.  Also add
> > the DT binding document and the new properties to have this support.
> > 
> > Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> > ---
> > 
> >  .../devicetree/bindings/rtc/rtc-palmas.txt         |   28
> >  ++++++++++++++ drivers/rtc/rtc-palmas.c                           | 
> >   39 ++++++++++++++++++++ 2 files changed, 67 insertions(+), 0
> >  deletions(-)
> >  create mode 100644
> >  Documentation/devicetree/bindings/rtc/rtc-palmas.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/rtc/rtc-palmas.txt
> > b/Documentation/devicetree/bindings/rtc/rtc-palmas.txt new file mode
> > 100644
> > index 0000000..e4b6910
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/rtc/rtc-palmas.txt
> > @@ -0,0 +1,28 @@
> > +Palmas RTC controller bindings
> > +
> > +Required properties:
> > +- compatible:
> > +  - "ti,palams-rtc" for palma series of the RTC controller
> > +- interrupt-parent: Parent interrupt device, must be handle of palams
> > node. +- interrupts: Interrupt number of RTC submodule on device.
> > +
> > +Optional properties:
> > +- ti,back-bat-chg-enable: The palmas series device like TPS65913 or
> > TPS80036 +	supports the battery backup for powering the RTC when main
> > battery is +	removed or in very low power state. This flag will
> > enable the backup +	battery charging.
> > +- ti,back-bat-chg-current: Configure charging current. Device
> > supports the +	charging current as < 100mA or >100mA.
> 
> Does the HW support just two options; less-than or greater-than 100mA?
> If so, a Boolean property here might be better. The code below certainly
> implies this.
> 
> Given there's only 1 battery, I think "back-" is redundant in the
> property names. Since that shortens the names a bit, I'd suggest
> spelling everything out in full, perhaps:
> 
> battery-charge-enable
> battery-charge-low-current

First of all, are those even properties for the RTC binding? Doesn't this 
PMIC contain a charger part which handles battery charging and so requires 
such kind of information?

Best regards,
Tomasz

