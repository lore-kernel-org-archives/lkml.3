Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaKZNQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:16:40 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:47989 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaKZNQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:16:38 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 07/14] of/reconfig: Always use the same structure
 =?iso-8859-1?Q?for=0D?= notifiers
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: devicetree@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Mark Brown <broonie@kernel.org>, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <547544FE.5020706@linux.vnet.ibm.com>
References: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
	<1416868422-22103-8-git-send-email-grant.likely@linaro.org>
	<1416956874.5089.13.camel@kernel.crashing.org>
	<547544FE.5020706@linux.vnet.ibm.com>
Date: Wed, 26 Nov 2014 13:16:34 +0000
Message-Id: <20141126131634.63DB7C4099B@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 21:11:58 -0600
, Nathan Fontenot <nfont@linux.vnet.ibm.com>
 wrote:
> On 11/25/2014 05:07 PM, Benjamin Herrenschmidt wrote:
> > On Mon, 2014-11-24 at 22:33 +0000, Grant Likely wrote:
> >> The OF_RECONFIG notifier callback uses a different structure depending
> >> on whether it is a node change or a property change. This is silly, and
> >> not very safe. Rework the code to use the same data structure regardless
> >> of the type of notifier.
> > 
> > I fell pretty good about this one except...
> > 
> >> diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
> >> index b9d1dfdbe5bb..9fe6002c1d5a 100644
> >> --- a/arch/powerpc/mm/numa.c
> >> +++ b/arch/powerpc/mm/numa.c
> >> @@ -1711,12 +1711,11 @@ static void stage_topology_update(int core_id)
> >>  static int dt_update_callback(struct notifier_block *nb,
> >>  				unsigned long action, void *data)
> >>  {
> >> -	struct of_prop_reconfig *update;
> >> +	struct of_reconfig_data *update = data;
> >>  	int rc = NOTIFY_DONE;
> >>  
> >>  	switch (action) {
> >>  	case OF_RECONFIG_UPDATE_PROPERTY:
> >> -		update = (struct of_prop_reconfig *)data;
> > 
> > Should we assert/bug on !update->dn / update->prop ?
> > 
> > (Same for the rest of the patch)
> > 
> > Or do you reckon it's pointless ?
> > 
> 
> I'm not sure it's worth it, if those are NULL pointers the drivers/of
> code would have tried to use them before invoking the notifier chain.
> We won't make it this far if they're NULL.

Agreed. I'm going to merge it as-is.

g.
