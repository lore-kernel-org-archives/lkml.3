Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab3GHNMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:12:51 -0400
Received: from mail-pa0-f67.google.com ([209.85.220.67]:64187 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3GHNMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:12:50 -0400
Date: Mon, 8 Jul 2013 06:12:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Wei Ni <wni@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Alex Courbot <acourbot@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [lm-sensors] [PATCH 1/2] ARM: dt: t30 cardhu: add dt entry for
 lm90
Message-ID: <20130708131247.GA21638@roeck-us.net>
References: <1372928979-26938-1-git-send-email-wni@nvidia.com>
 <1372928979-26938-2-git-send-email-wni@nvidia.com>
 <51D70483.70203@wwwdotorg.org>
 <51DA6BD4.1040300@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DA6BD4.1040300@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 03:35:48PM +0800, Wei Ni wrote:
> On 07/06/2013 01:38 AM, Stephen Warren wrote:
> > On 07/04/2013 03:09 AM, Wei Ni wrote:
> >> Enable thermal sensor lm90 for t30 cardhu.
> > 
> >> diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
> > 
> >> +		nct1008: nct1008 {
> >> +			compatible = "lm90,nct1008";
> > 
> > "lm90" isn't a valid vendor prefix. I believe the value you want is
> > "onnn,nct1008". Same comment for patch 2/2.
> > 
> The lm90 doesn't support device tree very well. In the DT, we need to
> named as "lm90" so that the lm90 driver can be loaded, and we also need
> to add "nct1008" to indicate this is the nct1008 device, so that the
> lm90 driver can be loaded with the right i2c_device_id->driver_data.
> 
> I set the " compatible = "lm90,nct1008" ", this is the simplest way, and
> we doesn't need to change the lm90.c.
> 
Did you really test "onn,nct1008" or, for that matter, "anything,nct1008" ?

I have been using 
	maxim,max1137
	maxim,max1139
	maxim,max6697
	dallas,ds1621
	linear,ltc3880
	linear,ltc2978
	intersil,zl2006
	ti,tmp421
	ti,tmp431

without problems, and without having to add code to the respective drivers.
I would be quite surprised if "onn,nct1008" would not work.

Guenter
