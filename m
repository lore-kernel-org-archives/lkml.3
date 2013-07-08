Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648Ab3GHHuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 03:50:51 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:34348 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3GHHuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 03:50:50 -0400
Date: Mon, 8 Jul 2013 09:50:24 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wei Ni <wni@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Alex Courbot <acourbot@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [lm-sensors] [PATCH 1/2] ARM: dt: t30 cardhu: add dt entry for
  lm90
Message-ID: <20130708095024.041a6d57@endymion.delvare>
In-Reply-To: <51DA6BD4.1040300@nvidia.com>
References: <1372928979-26938-1-git-send-email-wni@nvidia.com>
	<1372928979-26938-2-git-send-email-wni@nvidia.com>
	<51D70483.70203@wwwdotorg.org>
	<51DA6BD4.1040300@nvidia.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jul 2013 15:35:48 +0800, Wei Ni wrote:
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
> 
> The lm90 doesn't support device tree very well.

I doubt it, but if this is the case, then please fix it, instead of
working the problem around in a different place.

> In the DT, we need to
> named as "lm90" so that the lm90 driver can be loaded,

Not that I am an expert with regards to DT, but this doesn't make any
sense to me. AFAIK DT is about devices, not which drivers handle them.

> and we also need
> to add "nct1008" to indicate this is the nct1008 device, so that the
> lm90 driver can be loaded with the right i2c_device_id->driver_data.
> 
> I set the " compatible = "lm90,nct1008" ", this is the simplest way, and
> we doesn't need to change the lm90.c.

There's no problem with changing the lm90 driver, if this is the right
thing to do.

-- 
Jean Delvare
