Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbaE1Toj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 15:44:39 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57585 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaE1Toh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 15:44:37 -0400
Message-ID: <53863CA3.7040000@codeaurora.org>
Date: Wed, 28 May 2014 12:44:35 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>, Nishanth Menon <nm@ti.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-arm-msm@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/4] devicetree: bindings: Properly document micrel
 ks8851 SPI chips
References: <1400875040-13269-1-git-send-email-sboyd@codeaurora.org> <1400875040-13269-2-git-send-email-sboyd@codeaurora.org> <20140524124858.GR22111@sirena.org.uk> <5385063F.30407@codeaurora.org> <20140528151646.GU20155@pengutronix.de> <20140528171219.GD5099@sirena.org.uk>
In-Reply-To: <20140528171219.GD5099@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/14 10:12, Mark Brown wrote:
> On Wed, May 28, 2014 at 05:16:46PM +0200, Uwe Kleine-König wrote:
>> On Tue, May 27, 2014 at 02:40:15PM -0700, Stephen Boyd wrote:
>>> On 05/24/14 05:48, Mark Brown wrote:
>>>> So, according to the datasheet I managed to find this device has a
>>>> supply VDD_IO (so normally written vdd-io-supply here), some other
>>>> supplies which are tied to VDD_IO (so can probably be omitted) and a
>>>> supply VDD_A3.3 none of which are optional.  There is an internal
>>>> regulator which can be used to drop a higher voltage VDD_IO down for
>>>> some of the supplies tied to it but that's essentially a noop from
>>>> software as far as I can tell.  None of these supplies are obviously
>>>> optional, though I've not read the datasheet in detail so I may have
>>>> missed something here.
>> There is a difference between the supply being optional for the hardware
>> to work and the need to specify it in the device tree, isn't it? My
>> expectation is that when it's not specified there is just nothing the
>> the software needs to care for. 
> If the supply must always be physically present the bindings should be
> specified as it being mandatory and the code written in that fashion; as
> an extension Linux will put a dummy in but this is attempting to handle
> incorrect DTs.  This means we have functional error handling in cases
> where there is something to worry about and simplifies the code using
> the regulator.

Ok, you're saying the opposite of Rob. Should it be required or optional
in the DT binding?

>
> regulator_get_optional() should *only* be used if the supply may be
> omitted from the physical design and should generally always be
> accompanied by code which does something substantially different such as
> using an internal regulator or changing the source for a reference
> voltage instead.
>
>

Ok. Dave M has already picked up all these patches so I'll send a patch
to replace regulator_get_optional() with regulator_get() and fix up the
error handling unless I hear otherwise.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

