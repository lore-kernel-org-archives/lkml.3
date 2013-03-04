Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573Ab3CDRcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:32:39 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14118 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758301Ab3CDRch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:32:37 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 04 Mar 2013 09:32:37 -0800
Message-ID: <5134DAB3.5000604@nvidia.com>
Date: Mon, 4 Mar 2013 12:32:35 -0500
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Anton Vorontsov <anton@enomsg.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 2/3] power: power_supply: Add core support for supplied_nodes
References: <1361488272-21010-1-git-send-email-rklein@nvidia.com> <1361488272-21010-3-git-send-email-rklein@nvidia.com> <5127D083.6020308@wwwdotorg.org> <5127EA13.9010403@nvidia.com> <512FB473.8060309@nvidia.com> <20130302224832.GA16720@lizard.sbx05280.losalca.wayport.net>
In-Reply-To: <20130302224832.GA16720@lizard.sbx05280.losalca.wayport.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/2/2013 5:48 PM, Anton Vorontsov wrote:
> On Thu, Feb 28, 2013 at 02:48:03PM -0500, Rhyland Klein wrote:
> [...]
>> Anton, David, would you be adverse to the changing of supplied_to
>> from being a
>> list of batteries stored in a charger to being a list of chargers
>> stored in batteries?
> I wonder if we can support both ways?..
>
> Thanks,
> Anton
Well, the interesting factor becomes either we end up with 2 arrays
(supplied_to, supplied_from) or we make 1 array (horray, save space!)
but need to then either have a flag or use the power_supply type to
know how to interpret the single array (as supplied_to or supplied_from).

Adding in the second array and adds a char ** and an int, which doesn't seem
like as much overhead as trying to figure out how to interpret the 
single array
so I am inclined to stick with 2 arrays.

-rhyland

-- 
nvpublic

