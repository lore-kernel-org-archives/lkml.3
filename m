Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab3BMJIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:08:22 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39847 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab3BMJIR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:08:17 -0500
Date: Wed, 13 Feb 2013 09:08:09 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Loic PALLARDY <loic.pallardy@st.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Paul Walmsley <paul@pwsan.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <greg@linuxfoundation.org>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Wim Van Sebroeck <wim@iguana.be>, Dom Cobley <popcornmix@gmail.com>,
        Tejun Heo <tj@kernel.org>, Omar Ramirez Luna <omar.luna@linaro.org>,
        Suman Anna <s-anna@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 10/13] mailbox: create dbx500 mailbox driver
Message-ID: <20130213090809.GD13775@e106331-lin.cambridge.arm.com>
References: <1360645032-9668-1-git-send-email-s-anna@ti.com>
 <1360645032-9668-11-git-send-email-s-anna@ti.com>
 <20130212103949.GA826@e106331-lin.cambridge.arm.com>
 <511A9F81.1040608@st.com>
MIME-Version: 1.0
In-Reply-To: <511A9F81.1040608@st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 13 Feb 2013 09:08:10.0610 (UTC) FILETIME=[A5440D20:01CE09C9]
X-MC-Unique: 113021309081413201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 08:01:05PM +0000, Loic PALLARDY wrote:
> Hi Mark,
> 
> Thanks for your comments.
> 
> On 02/12/2013 11:39 AM, Mark Rutland wrote:
> > Hello,
> >
> > I have a few comments on the devicetree binding and the way it's parsed.
> >
> >> +static const struct of_device_id dbx500_mailbox_match[] = {
> >> +       { .compatible = "stericsson,db8500-mailbox",
> >> +               .data = (void *)db8500_mboxes,
> >> +       },
> >> +       { .compatible = "stericsson,db9540-mailbox",
> >> +               .data = (void *)dbx540_mboxes,
> >> +       },
> >> +       { /* sentinel */}
> >> +};
> >> +
> >
> > The binding for the compatible strings above and property parsing below should
> > be documented.
> >
> Yes you're right. I will add a description in 
> Documentation/devicetree/bindings/mailbox/...

Great!

[...]

> >> +       mem = platform_get_resource_byname(pdev, IORESOURCE_MEM, "prcm_reg");
> >
> > Does this work for dt? I wasn't aware we got anything more than anonymous
> > memory and interrupts.
> >
> Yes this is working with and without dt.
> dt declaration will be the following
> mailbox {
> 	compatible = "stericsson,db8500-mailbox";
> 	reg = <0x80157000 0x1000>, <0x801B8000 0x2000>;
> 	reg-names = "prcm-reg", "prcmu-tcdm";
> 	interrupts = <0 47 0x4>;
> 	interrupt-names = "irq";
> 	legacy-offset = <0xdd4>;
> };

Ah, I wasn't aware of reg-names. Thanks for the example.

Thanks,
Mark.


