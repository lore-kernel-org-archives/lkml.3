Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116AbaIEKXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:23:19 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:51222 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344AbaIEKXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:23:16 -0400
MIME-Version: 1.0
In-Reply-To: <53FC3A5D.8030708@nvidia.com>
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
 <53FB7511.9090205@wwwdotorg.org> <53FC3A5D.8030708@nvidia.com>
From: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Date: Fri, 5 Sep 2014 12:22:55 +0200
X-Google-Sender-Auth: xV5-aw5cvsy2gSW2jO6rZtKDhQ0
Message-ID: <CAAObsKABUa9xD+hntyv97ZQB7Bk05kN0h0-+H7Q9ks6RT0yV2Q@mail.gmail.com>
Subject: Re: [PATCH 0/8] Tegra124 EMC (external memory controller) support
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 August 2014 09:42, Mikko Perttunen <mperttunen@nvidia.com> wrote:
> On 25/08/14 20:40, Stephen Warren wrote:
>>
>> On 07/11/2014 08:18 AM, Mikko Perttunen wrote:
>>>
>>> Hi everyone,
>>>
>>> this series adds support for the EMC (external memory controller) clock
>>> in the Tegra124 system-on-chip. The series has been tested on Jetson TK1.
>>>
>>> The first two patches remove the old "emc_mux" and "emc" clocks from the
>>> clock tree and the device tree bindings. This is, of course, not
>>> backwards
>>> compatible, but as these clocks have never been useful for anything
>>> (apart from maybe reading the boot rate of the EMC clock). If this is
>>> still
>>> not acceptable, the second patch can be dropped.
>>
>> ...
>>
>> Mikko, this series had some comments, especially on the DT binding
>> (patch 5/8) and how the MC/EMC drivers interact. Is there an updated
>> version of the series? Or, is the series replaced by Tomeu Vizoso's work?
>
>
> Yes, I have a v2 with these comments addressed. One concern, though, is the
> part writing to CLK_SOURCE_EMC. If some other driver also wants to read this
> register (MC, likely), we might need to have an API for it in the CAR
> driver. On the other hand, maybe not, since it's only one register. Thierry?
>
> Another point is that v2 adds a new API to the MC driver, which also doesn't
> exist yet. The EMC driver can technically work without the MC driver (but
> with a header for MC added), but I'm not sure the result would be very
> useful.
>
> I believe the plan is that Tomeu's EMC code will be integrated into this EMC
> driver once both are ready.

That's mostly right. My clk constraints series just allow consumers to
influence the effective rate of a clock, such as the EMC. And the
pm_qos series will allow to track the total memory bandwidth needs in
the system. I'm not sure yet where in the code this tracking will be
done. It could be done in an EMC driver in drivers/memory, but it's
probably too unrelated to be placed in the EMC clock driver.

Regards,

Tomeu
