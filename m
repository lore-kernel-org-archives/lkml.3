Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaBCVQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:16:10 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15856 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaBCVQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:16:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 03 Feb 2014 13:14:18 -0800
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
Date: Mon, 3 Feb 2014 13:16:05 -0800
Subject: RE: [PATCH v1] ARM: tegra: add nvidia,wdt-timer-id optional property
Thread-Topic: [PATCH v1] ARM: tegra: add nvidia,wdt-timer-id optional
 property
Thread-Index: Ac8hJErkm3vwlaa2ROOksx9CKY3XgwAAC6JA
Message-ID: <643E69AA4436674C8F39DCC2C05F7638631998538B@HQMAIL03.nvidia.com>
References: <1391204811-6293-1-git-send-email-achew@nvidia.com>
 <20140203171053.GA28338@e106331-lin.cambridge.arm.com>
 <643E69AA4436674C8F39DCC2C05F763863199852CA@HQMAIL03.nvidia.com>
 <52F005A0.4080807@wwwdotorg.org>
In-Reply-To: <52F005A0.4080807@wwwdotorg.org>
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

> On 02/03/2014 11:59 AM, Andrew Chew wrote:
> >> On Fri, Jan 31, 2014 at 09:46:51PM +0000, Andrew Chew wrote:
> >>> This optional property can be used to specify which timers are to be
> >>> used for hardware watchdog timeouts (via a tegra wdt driver).
> >>
> >> Is there any reason that a particular timer should be used?
> >
> > I worry about colliding with other timer allocations, and wanted to be
> > flexible in this regard.
> 
> Are the other timer allocations represented in DT, or simply made by or hard-
> coded in the driver? If the former, this property seems like a good equivalent
> of any existing allocations. If the latter, can't the driver just allocate or hard-
> code the allocation in the same way as any existing allocations?

>From what I've seen, timer allocations are just hard-coded into whatever driver.
I didn't think this was a particularly good idea, since when writing other drivers
that for some reason need a timer, the author has to be aware of allocations
made in other, barely related drivers.  In addition, what seems like an arbitrary
allocation in one scenario, I anticipate may not be completely arbitrary in
a different scenario, so I thought it would be better to freeze the device driver
code, and allow for flexibility at the device tree level.

But I'll do whatever others think is right.  I can make my watchdog driver just take
an arbitrary (to me right now) timer and instantiate one watchdog for it.  If I'm to
do that, then this device node property isn't necessary, and we can drop this patch.
