Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab3GVM4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 08:56:23 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41725 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab3GVM4V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 08:56:21 -0400
Message-ID: <51ED2C02.3040202@arm.com>
Date: Mon, 22 Jul 2013 13:56:34 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: Sudeep.KarkadaNagesha@arm.com,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Landley <rob@landley.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Shawn Guo <shawn.guo@linaro.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        mturquette@linaro.org
Subject: Re: [PATCH 0/2] PM / OPP: updates to enable sharing OPPs info
References: <1367406679-21603-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <519B45C3.8050700@arm.com> <20130720050943.5EB853E169C@localhost>
In-Reply-To: <20130720050943.5EB853E169C@localhost>
X-OriginalArrivalTime: 22 Jul 2013 12:56:13.0689 (UTC) FILETIME=[D8B27690:01CE86DA]
X-MC-Unique: 113072213561900301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 20/07/13 06:09, Grant Likely wrote:
> On Tue, 21 May 2013 11:00:35 +0100, Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com> wrote:
>> Hi Rob, Grant,
>>
>> On 01/05/13 12:11, Sudeep KarkadaNagesha wrote:
>>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>>
>>> These are couple of updates to existing PM/OPP library to support
>>> sharing of OPPs between different device nodes.
>>>
>>> Currently all the cpu nodes are parsed until the OPPs are found. This
>>> is essential to support cpuhotplug without having to replicate OPP
>>> information in all the cpu nodes.
>>>
>>> However in systems with multiple cpu power domain, its better to have
>>> OPP entry for each cpu. To avoid replication, phandle can be specified
>>> to the node which contains the full OPP information.
>>>
>> Is proposed option of phandle for OPP acceptable to avoid replication ?
>> Any suggestions to proceed on this ? This is needed to support CPU
>> hotplug on big LITTLE system where current methods like parsing all the
>> nodes or just CPU0 node will not work.
> 
> Looks fine to me.
Hi Grant,

Thanks for the response.

However I had a thought after seeing recent patch series by Mike[1]
Since the OPPs are usually associated with clocks, and multiple devices
sharing clocks will point to same clock node in DT, clk node is more
logical place to specify the OPPs. IMO this will be good alignment for
the consolidation effort by Mike. One issue with this approach is
backward compatibility(using old DT)

Regards,
Sudeep

[1]
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/182231.html

