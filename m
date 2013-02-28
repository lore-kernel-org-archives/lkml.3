Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab3B1TsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 14:48:08 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13695 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3B1TsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 14:48:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 28 Feb 2013 11:42:34 -0800
Message-ID: <512FB473.8060309@nvidia.com>
Date: Thu, 28 Feb 2013 14:48:03 -0500
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 2/3] power: power_supply: Add core support for supplied_nodes
References: <1361488272-21010-1-git-send-email-rklein@nvidia.com> <1361488272-21010-3-git-send-email-rklein@nvidia.com> <5127D083.6020308@wwwdotorg.org> <5127EA13.9010403@nvidia.com>
In-Reply-To: <5127EA13.9010403@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/2013 4:58 PM, Rhyland Klein wrote:
> On 2/22/2013 3:09 PM, Stephen Warren wrote:
>> On 02/21/2013 04:11 PM, Rhyland Klein wrote:
>>> With the growing support for dt, it make sense to try to make use of
>>> dt features to make the general code cleaner. This patch is an
>>> attempt to commonize how chargers and their supplies are linked.
>>>
>>> Following common dt convention, the "supplied-to" char** list is
>>> replaced with phandle lists defined in the supplies which contain
>>> phandles of their suppliers.
>>>
>>> This has the effect however of introducing an inversion in the internal
>>> mechanics of how this information is stored. In the case of non-dt,
>>> the char** list of supplies is stored in the charger. In the dt case,
>>> a device_node * list is stored in the supplies of their chargers,
>>> however this seems to be the only way to support this.
>> grep over the whole kernel tree for supplied_to doesn't yield /too/ many
>> hits, although I didn't look at the complexity of most of them. Would it
>> be possible to invert all the current in-kernel uses to represent a
>> supplied_from/by model instead? That would mean the proposed DT binding
>> would then represent the same relationship ordering as the kernel code,
>> which would be easier to handle.
> I think it is surely possible to change all the existing drivers to the
> inverse logic as
> you suggested. That might make a good follow patchset.
>
> -rhyland
>

Anton, David, would you be adverse to the changing of supplied_to from 
being a
list of batteries stored in a charger to being a list of chargers stored 
in batteries?

(I only use terms charger and batteries as it is much clearer for me to 
read in place
of terms like supplier and supply which are more accurate but much more 
confusing
when used together).

-rhyland

-- 
nvpublic

