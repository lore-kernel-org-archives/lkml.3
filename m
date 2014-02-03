Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbaBCV3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:29:37 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15263 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaBCV3f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:29:35 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 03 Feb 2014 13:28:11 -0800
From: Andrew Chew <AChew@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <mark.rutland@arm.com>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "abrestic@chromium.org" <abrestic@chromium.org>,
        "dgreid@chromium.org" <dgreid@chromium.org>,
        "katierh@chromium.org" <katierh@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 3 Feb 2014 13:29:33 -0800
Subject: RE: [PATCH v1] ARM: tegra: add nvidia,wdt-timer-id optional property
Thread-Topic: [PATCH v1] ARM: tegra: add nvidia,wdt-timer-id optional
 property
Thread-Index: Ac8hJqe3/pXoMI2uSN2eNKaPvNEOwAAADChg
Message-ID: <643E69AA4436674C8F39DCC2C05F7638631998539D@HQMAIL03.nvidia.com>
References: <1391204811-6293-1-git-send-email-achew@nvidia.com>
 <20140203171053.GA28338@e106331-lin.cambridge.arm.com>
 <643E69AA4436674C8F39DCC2C05F763863199852CA@HQMAIL03.nvidia.com>
 <52F005A0.4080807@wwwdotorg.org>
 <643E69AA4436674C8F39DCC2C05F7638631998538B@HQMAIL03.nvidia.com>
 <52F00994.7080701@wwwdotorg.org>
In-Reply-To: <52F00994.7080701@wwwdotorg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 02/03/2014 02:16 PM, Andrew Chew wrote:
> >> On 02/03/2014 11:59 AM, Andrew Chew wrote:
> >>>> On Fri, Jan 31, 2014 at 09:46:51PM +0000, Andrew Chew wrote:
> >>>>> This optional property can be used to specify which timers are to
> >>>>> be used for hardware watchdog timeouts (via a tegra wdt driver).
> >>>>
> >>>> Is there any reason that a particular timer should be used?
> >>>
> >>> I worry about colliding with other timer allocations, and wanted to
> >>> be flexible in this regard.
> >>
> >> Are the other timer allocations represented in DT, or simply made by
> >> or hard- coded in the driver? If the former, this property seems like
> >> a good equivalent of any existing allocations. If the latter, can't
> >> the driver just allocate or hard- code the allocation in the same way as any
> existing allocations?
> >
> > From what I've seen, timer allocations are just hard-coded into whatever
> driver.
> > I didn't think this was a particularly good idea, since when writing
> > other drivers that for some reason need a timer, the author has to be
> > aware of allocations made in other, barely related drivers.
> 
> I'm not sure that they would; why wouldn't the timer driver register the
> various timers with standard Linux APIs which the clients talk to, thus
> avoiding the clients having any knowledge at all of which channels are used
> for what.
> 
> If you're talking about the watchdog driver, then can't we just create a
> shared header file that the clocksource and watchdog drivers both include,
> which defines the timer ID allocations?

Sure, let's go with that.  In that case, this patch isn't needed, and should be
dropped.
