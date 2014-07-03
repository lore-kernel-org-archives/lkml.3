Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbaGCOPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:15:47 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13014 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaGCOPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:15:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 03 Jul 2014 07:05:16 -0700
Message-ID: <53B56588.6090703@nvidia.com>
Date: Thu, 3 Jul 2014 17:15:36 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "edubezval@gmail.com" <edubezval@gmail.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/6] thermal: of: Add support for hardware-tracked trip
 points
References: <1403856699-2140-1-git-send-email-mperttunen@nvidia.com> <1403856699-2140-2-git-send-email-mperttunen@nvidia.com> <53B1D1C8.5010907@wwwdotorg.org> <53B262EA.9030806@nvidia.com> <53B2FADC.8060708@wwwdotorg.org>
In-Reply-To: <53B2FADC.8060708@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/14 21:15, Stephen Warren wrote:
>> The thermal core only supports a fixed number of trip points for each
>> driver and the core informs the driver of any changes to those, so
>> drivers using the core framework can already have hardware trip points,
>> but just a fixed number of them.
>>
>> The way of-thermal works, is it reads all the trip points from the
>> device tree, registers a new thermal_zone_device with that number of
>> trip points and then handles the trip points completely independently.
>> Of course, if we're just polling, this is fine, since the thermal core
>> also knows about those trip points and will trigger cooling when polling
>> the each zone. However, the driver doesn't, so it cannot setup any
>> interrupts to call thermal_zone_device_update.
>
> Is there any possibility of cleaning that up? It's obviously horribly
> inconsistent if core driver functionality works completely differently
> simply because the list of trip-points comes from DT rather than a
> static table in the driver. of_thermal should be limited to DT parsing
> and related device instantiation/lookup, not introducing a completely
> different functionality model.

I guess the smallest possible change would be to add a 
#hardware-trip-cells property to the thermal driver node (this would 
need to designate both the thermal zone and the trip point) and a 
hardware-trip-point phandle node to trip points. Then trip points could 
point to a hardware trip point that would get programmed. Since this is 
just adding properties, it would be backwards-compatible as well.
This is starting to sound like a good idea. Will have to give think 
about it some more.
