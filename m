Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab3IRT7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 15:59:45 -0400
Received: from smtprelay0230.hostedemail.com ([216.40.44.230]:46207 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753545Ab3IRT7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 15:59:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2893:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:5007:7652:7903:8828:9010:10004:1
X-HE-Tag: tank10_370d2cfbf870a
X-Filterd-Recvd-Size: 2837
Message-ID: <1379534377.1787.59.camel@joe-AO722>
Subject: Re: [PATCHv3 02/16] drivers: thermal: introduce device tree parser
From: Joe Perches <joe@perches.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: swarren@wwwdotorg.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ian.campbell@citrix.com, rob.herring@calxeda.com, linux@roeck-us.net,
        rui.zhang@intel.com, wni@nvidia.com, grant.likely@linaro.org,
        durgadoss.r@intel.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Date: Wed, 18 Sep 2013 12:59:37 -0700
In-Reply-To: <523A0290.8050502@ti.com>
References: <5239F6D8.1020907@ti.com>
	 <1379530923-29268-1-git-send-email-eduardo.valentin@ti.com>
	 <1379531483.1787.55.camel@joe-AO722> <523A0290.8050502@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 15:44 -0400, Eduardo Valentin wrote:
> Hello Joe,

Hello Eduardo.

>  18-09-2013 15:11, Joe Perches wrote:
> > On Wed, 2013-09-18 at 15:02 -0400, Eduardo Valentin wrote:
> >> This patch introduces a device tree bindings for
> >> describing the hardware thermal behavior and limits.
> >> Also a parser to read and interpret the data and feed
> >> it in the thermal framework is presented.
> > 
> > trivial notes:
[]
> > If readings are within some non zero noise level,
> > perhaps stable should be returned.
> 
> Yes, there should be some sort of threshold for temperature trend. But I
> am not sure this is the right place to implement this. This type of
> feature is in my TODO list, but I am planing to get it done within the
> core code of the thermal framework.

No worries, one day...  Just wanted to bring it to attention.

> >> +static struct __thermal_zone *
> >> +thermal_of_build_thermal_zone(struct device_node *np)
> >> +{
[]
> >> +	tz = kzalloc(sizeof(*tz), GFP_KERNEL);
> >> +	if (!tz) {
> >> +		pr_err("not enough memory for thermal of zone\n");
> > 
> > Unnecessary OOM message.
> > All allocs without GFP_NOWARN get a dump_stack()

[]

> Hmmm.. I am pretty sure you have a good point. But to me seams to be
> still a common practice to have drivers outputing error messages when
> allocation fails. A simple git grep -A 4 kzalloc for instance, shows
> that there are still quite a considerable amount of occurrences of such
> practice.

True though a considerable number have been removed.
I think these should all be deleted eventually and
there's no good reason to add more.


