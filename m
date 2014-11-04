Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbaKDKAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:00:31 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45392 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbaKDKAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:00:10 -0500
Date: Tue, 4 Nov 2014 10:59:44 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rob Herring <robherring2@gmail.com>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sagar Dharia <sdharia@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 0/1] Compact interface for Device-Tree
Message-ID: <20141104095944.GF30369@pengutronix.de>
References: <1414709964-27284-1-git-send-email-gavidov@codeaurora.org>
 <CAL_JsqLtkiiyisxSG_qBknmz6n2qDKUdpwM-ZY3tH3wgYSrO1w@mail.gmail.com>
 <7637604.7PK9W8ePf3@vostro.rjw.lan>
 <40803956.DTL7dD7CLv@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <40803956.DTL7dD7CLv@wuerfel>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:57:10 up 19 days, 21:10, 55 users,  load average: 0.72, 0.36,
 0.26
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 04:06:03PM +0100, Arnd Bergmann wrote:
> On Friday 31 October 2014 23:53:28 Rafael J. Wysocki wrote:
> > On Saturday, November 01, 2014 05:13:45 AM Rob Herring wrote:
> > > On Fri, Oct 31, 2014 at 6:59 AM, Gilad Avidov <gavidov@codeaurora.org> wrote:
> > > >
> > > > Device-Tree compact API
> > > > ------------------------
> > > >
> > > > Common code seen in driver’s probe reads device tree values and handling
> > > > erroneous return codes from all those of_property_read_xxx()  APIs. This
> > > > common code is factored out by the of_property_map module which allows
> > > > driver’s probe to replace that (often lengthy) code with a concise table:
> > > >
> > > > struct of_prop_map map[] = {
> > > >     {"i2c",            &dev->id,        OF_REQ,  OF_ID,  -1},
> > > >     {"qcom,clk-freq-out",    &dev->clk_freq_out,    OF_REQ,  OF_U32,  0},
> > > >     {"qcom,clk-freq-in",    &dev->clk_freq_in,    OF_REQ,  OF_U32,  0},
> > > >     {"qcom,disable-dma",    &dev->disable_dma,    OF_OPT,  OF_BOOL, 0},
> > > >     {"qcom,master-id",    &dev->mstr_id,        OF_SGST, OF_U32,  0},
> > > >     {NULL,            NULL,            0,       0,       0},
> > > > };
> > > >
> > > > Then call populate to read the values into the device’s variables:
> > > >
> > > > ret = of_prop_populate(dev, dev->of_node, map);
> > > 
> > > Interesting idea. The main concern I have with this is there has been
> > > on-going discussions about how to generalize property handling across
> > > DT and ACPI to make drivers more agnostic, so I'm copying a few folks
> > > involved in that. That may be a bit orthogonal to what this is doing,
> > > but we may want some coordination here.
> > 
> > Agreed.
> > 
> > We actually have a patchset adding a unified device property API in 
> > linux-next (http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/log/?h=device-properties)
> > and I'd prefer to see the "compactization" to happen at that level, if possible,
> > rather that for of_ only.
> 
> Agreed, this should definitely use the new generalized API.
> I have prototyped a similar concept last year, which actually went much
> further and also abstracted high-level properties such as interrupts,
> gpios, pwm, dma-engine, etc. I still think we should do something
> like that, but I've never had the time to follow up and nobody else
> picked up my work from back then.
> 
> Would others like to see that?

Do you have a link to your patches? I think I remember that you wrote
something like that, but can't find it anymore in the archives.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
