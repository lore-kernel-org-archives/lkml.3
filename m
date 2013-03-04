Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab3CDRu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:50:58 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:47192 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758623Ab3CDRu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:50:56 -0500
Date: Mon, 4 Mar 2013 09:47:06 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 2/3] power: power_supply: Add core support for
 supplied_nodes
Message-ID: <20130304174705.GA31100@lizard.fhda.edu>
References: <1361488272-21010-1-git-send-email-rklein@nvidia.com>
 <1361488272-21010-3-git-send-email-rklein@nvidia.com>
 <5127D083.6020308@wwwdotorg.org>
 <5127EA13.9010403@nvidia.com>
 <512FB473.8060309@nvidia.com>
 <20130302224832.GA16720@lizard.sbx05280.losalca.wayport.net>
 <5134DAB3.5000604@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5134DAB3.5000604@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 12:32:35PM -0500, Rhyland Klein wrote:
[...]
> >>Anton, David, would you be adverse to the changing of supplied_to
> >>from being a
> >>list of batteries stored in a charger to being a list of chargers
> >>stored in batteries?
> >>
> >I wonder if we can support both ways?..
>
> Well, the interesting factor becomes either we end up with 2 arrays
> (supplied_to, supplied_from) or we make 1 array (horray, save space!)
> but need to then either have a flag or use the power_supply type to
> know how to interpret the single array (as supplied_to or supplied_from).
> 
> Adding in the second array and adds a char ** and an int, which doesn't seem
> like as much overhead as trying to figure out how to interpret the
> single array
> so I am inclined to stick with 2 arrays.

Yup, two arrays seems very reasonable. Plus that way we don't need to
convert existing drivers, so we avoid churn.

Thanks!

Anton
