Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934060AbaHZIEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:04:09 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16309 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198AbaHZICu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:02:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 26 Aug 2014 00:48:38 -0700
Message-ID: <53FC3F26.6010704@nvidia.com>
Date: Tue, 26 Aug 2014 11:02:46 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, <pdeschrijver@nvidia.com>,
        <pgaikwad@nvidia.com>, <mturquette@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 0/8] Tegra124 EMC (external memory controller) support
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com> <53FB7511.9090205@wwwdotorg.org> <53FC3A5D.8030708@nvidia.com> <20140826074750.GA17263@ulmo>
In-Reply-To: <20140826074750.GA17263@ulmo>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/08/14 10:47, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Tue, Aug 26, 2014 at 10:42:21AM +0300, Mikko Perttunen wrote:
>> On 25/08/14 20:40, Stephen Warren wrote:
>>> On 07/11/2014 08:18 AM, Mikko Perttunen wrote:
>>>> Hi everyone,
>>>>
>>>> this series adds support for the EMC (external memory controller) clock
>>>> in the Tegra124 system-on-chip. The series has been tested on Jetson TK1.
>>>>
>>>> The first two patches remove the old "emc_mux" and "emc" clocks from the
>>>> clock tree and the device tree bindings. This is, of course, not
>>>> backwards
>>>> compatible, but as these clocks have never been useful for anything
>>>> (apart from maybe reading the boot rate of the EMC clock). If this is
>>>> still
>>>> not acceptable, the second patch can be dropped.
>>> ...
>>>
>>> Mikko, this series had some comments, especially on the DT binding
>>> (patch 5/8) and how the MC/EMC drivers interact. Is there an updated
>>> version of the series? Or, is the series replaced by Tomeu Vizoso's work?
>>
>> Yes, I have a v2 with these comments addressed. One concern, though, is the
>> part writing to CLK_SOURCE_EMC. If some other driver also wants to read this
>> register (MC, likely), we might need to have an API for it in the CAR
>> driver. On the other hand, maybe not, since it's only one register. Thierry?
>
> I don't think any of these drivers should directly access registers that
> aren't in the memory region that they've claimed. If they need to access
> functionality provided by some other driver then they should do so via a
> custom API.

I'll make a simple API and post patches.

>
> Thierry
>
> * Unknown Key
> * 0x7F3EB3A1
>

Mikko
