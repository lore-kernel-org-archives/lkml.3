Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbaAHSZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:25:34 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:52539 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751565AbaAHSZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:25:32 -0500
Message-ID: <1389205531.23721.40.camel@hornet>
Subject: Re: [RFC 10/18] regulator: vexpress: Use regmap instead of custom
 interface
From: Pawel Moll <pawel.moll@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, "arm@kernel.org" <arm@kernel.org>,
        Olof Johansson <olof@lixom.net>, Liam Girdwood <lgirdwood@gmail.com>
Date: Wed, 08 Jan 2014 18:25:31 +0000
In-Reply-To: <20131224122455.GY30815@sirena.org.uk>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
	 <1387815830-8794-11-git-send-email-pawel.moll@arm.com>
	 <20131224122455.GY30815@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-24 at 12:24 +0000, Mark Brown wrote:
> On Mon, Dec 23, 2013 at 04:23:42PM +0000, Pawel Moll wrote:
> 
> > This patch makes the Versatile Express regulator driver
> > use regmap interface, instead of custom vexpress config
> > one. It will request the regmap resource associated
> > with the device, which makes it pretty much hardware
> > agnostic.
> 
> If this change is making the operations hardware agnostic regmap based
> ones then they should be being either replaced with standard operations
> or standard operations being added.  It looks like you should be able to
> use the existing linear map operations.

Bad wording on my side. What I meant was: it doesn't matter what wacky
VE-specific interface is hidden behind the regmap, not it's a generic
regulator driver.

Having said that, I could create helpers for continuous (linear won't
cut - if you remember the continuous_voltage_range was introduced for
VE's sake) regulator, which would simply read/write value to a specified
register. Not sure how useful would that be, though. I doubt that such
"regulator" will appear anywhere outside VE world. And if so, this would
probably call for a "generic continuous regulator" driver and a relevant
DT binding, which I don't think anyone really wants. If your opinion
differs, I'm happy to botch something up.

Cheers!

Paweł


