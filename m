Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaBEJ2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:28:55 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55956 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbaBEJ2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:28:53 -0500
Message-ID: <1391592486.11239.4.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v2 0/6] ARM: STi reset controller support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: srinivas.kandagatla@st.com
Cc: linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, Arnd Bergmann <arnd@arndb.de>,
        stephen.gallimore@st.com, Olof Johansson <olof@lixom.net>
Date: Wed, 05 Feb 2014 10:28:06 +0100
In-Reply-To: <1391437665-11913-1-git-send-email-srinivas.kandagatla@st.com>
References: <1389696613-19683-1-git-send-email-srinivas.kandagatla@st.com>
	 <1391437665-11913-1-git-send-email-srinivas.kandagatla@st.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srinivas,

Am Montag, den 03.02.2014, 14:27 +0000 schrieb
srinivas.kandagatla@st.com:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> Hi All,
> 
> This patch series adds reset controller support for STi SOC series STiH415 and
> STiH416. It adds support for both power down reset and soft reset controllers.
> On STi series SOCs reset lines are wired up to system configuration registers.
> Most of the IPs on STi SOCs are left in reset state, so this driver is very
> important for other drivers to use the IPs.
> 
> Patch 01: Adds reset controller based on system configuration registers via
> regmap.
> 
> Patch 02, 03: adds STiH415 and STiH416 reset controller drivers.
> 
> Patch 04, 05: adds STiH415 and STiH416 soft reset controllers.
> 
> The final patch 06 selects reset controller in mach-sti Kconfig.
> 
> I would like get this driver in to 3.15, so that its possible to add dt
> support for other IPs with reset lines. Without this patchset its impossible
> to add DT support to IPs with reset lines as reset line definition is in
> common header file in include/dt-bindings/.
> 
> This reset controller will be used by gmac, i2c and st-ir drivers.
> 
> 
> Comments?

the patchset looks good to me for the soft resets. But for the powerdown
bits I am wondering whether the reset controller API is the right
abstraction. Depending on whether those bits really just put the IPs
into reset or there is some power gating / sequencing involved,
shouldn't this rather be handled as a set of pm domains?
I see that for example on STiH415 there are both soft resets and
powerdown bits for USB[012].

regards
Philipp

