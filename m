Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaENHok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 03:44:40 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:51927 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaENHof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 03:44:35 -0400
Message-ID: <1400053426.8431.13.camel@iivanov-dev>
Subject: Re: [PATCH 2/4] of/platform: return error on
 of_platform_device_create_pdata failure
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: frowand.list@gmail.com
Cc: Olof Johansson <olof@lixom.net>, Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn@kryo.se>, Rob Herring <robh@kernel.org>
Date: Wed, 14 May 2014 10:43:46 +0300
In-Reply-To: <53728173.7050508@gmail.com>
References: <1399499298-8830-1-git-send-email-robherring2@gmail.com>
	 <1399499298-8830-3-git-send-email-robherring2@gmail.com>
	 <20140513175603.GA27173@quad.lixom.net> <53728173.7050508@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-13 at 13:32 -0700, Frank Rowand wrote:
> On 5/13/2014 10:56 AM, Olof Johansson wrote:
> > On Wed, May 07, 2014 at 04:48:16PM -0500, Rob Herring wrote:
> >> From: Rob Herring <robh@kernel.org>
> >>
> >> of_platform_populate does not return an error if creating the platform
> >> device fails. This means almost any error from driver core cannot be
> >> detected by the caller. Fix this.
> >>
> >> Signed-off-by: Rob Herring <robh@kernel.org>
> >> ---
> >>  drivers/of/platform.c | 4 +++-
> >>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> >> index 404d1da..622aeb3 100644
> >> --- a/drivers/of/platform.c
> >> +++ b/drivers/of/platform.c
> >> @@ -391,7 +391,9 @@ static int of_platform_bus_create(struct device_node *bus,
> >>  	}
> >>  
> >>  	dev = of_platform_device_create_pdata(bus, bus_id, platform_data, parent);
> >> -	if (!dev || !of_match_node(matches, bus))
> >> +	if (!dev)
> >> +		return -ENODEV;
> >> +	if (!of_match_node(matches, bus))
> >>  		return 0;
> >>  
> >>  	for_each_child_of_node(bus, child) {
> > 
> > This patch caused every single MMC driver to break on OF platforms, as far
> > as I can tell.  Reverting it on last night's -next seems to resolve it.
> > 
> > The problem seems to be that of_platform_populate() will bail on the
> > first device that fails this.
> > 
> > How did you test this code, Frank? On what platform? Practically all my
> > targets here failed to mount rootfs from eMMC or SD card...
> 
> I tested on a dragonboard, but without a working sdhci driver.  Thus I would not
> have hit the error.

Same here.

Regards,
Ivan

