Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbaHZHm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:42:27 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19012 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198AbaHZHmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:42:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 26 Aug 2014 00:32:24 -0700
Message-ID: <53FC3A5D.8030708@nvidia.com>
Date: Tue, 26 Aug 2014 10:42:21 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, <pdeschrijver@nvidia.com>,
        <pgaikwad@nvidia.com>, <mturquette@linaro.org>,
        <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 0/8] Tegra124 EMC (external memory controller) support
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com> <53FB7511.9090205@wwwdotorg.org>
In-Reply-To: <53FB7511.9090205@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/08/14 20:40, Stephen Warren wrote:
> On 07/11/2014 08:18 AM, Mikko Perttunen wrote:
>> Hi everyone,
>>
>> this series adds support for the EMC (external memory controller) clock
>> in the Tegra124 system-on-chip. The series has been tested on Jetson TK1.
>>
>> The first two patches remove the old "emc_mux" and "emc" clocks from the
>> clock tree and the device tree bindings. This is, of course, not
>> backwards
>> compatible, but as these clocks have never been useful for anything
>> (apart from maybe reading the boot rate of the EMC clock). If this is
>> still
>> not acceptable, the second patch can be dropped.
> ...
>
> Mikko, this series had some comments, especially on the DT binding
> (patch 5/8) and how the MC/EMC drivers interact. Is there an updated
> version of the series? Or, is the series replaced by Tomeu Vizoso's work?

Yes, I have a v2 with these comments addressed. One concern, though, is 
the part writing to CLK_SOURCE_EMC. If some other driver also wants to 
read this register (MC, likely), we might need to have an API for it in 
the CAR driver. On the other hand, maybe not, since it's only one 
register. Thierry?

Another point is that v2 adds a new API to the MC driver, which also 
doesn't exist yet. The EMC driver can technically work without the MC 
driver (but with a header for MC added), but I'm not sure the result 
would be very useful.

I believe the plan is that Tomeu's EMC code will be integrated into this 
EMC driver once both are ready.

Mikko
