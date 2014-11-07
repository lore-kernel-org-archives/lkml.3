Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaKGMf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:35:29 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:44164 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaKGMf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:35:27 -0500
Message-ID: <545CBC87.7050404@collabora.com>
Date: Fri, 07 Nov 2014 13:35:19 +0100
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>, linux-kernel@vger.kernel.org
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH 0/3] Add support for Tegra Activity Monitor
References: <1414594232-15684-1-git-send-email-tomeu.vizoso@collabora.com> <545C8BCC.3090908@nvidia.com>
In-Reply-To: <545C8BCC.3090908@nvidia.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 10:07 AM, Alexandre Courbot wrote:
> On 10/29/2014 11:50 PM, Tomeu Vizoso wrote:
>> Hello,
>>
>> these patches implement support for setting the rate of the EMC clock based on
>> stats collected from the ACTMON, a piece of hw in the Tegra124 that counts
>> memory accesses (among others).
>>
>> It depends on the following in-flight patches:
>>
>> * MC driver: http://thread.gmane.org/gmane.linux.ports.tegra/19623
>> * EMC driver: http://thread.gmane.org/gmane.linux.ports.arm.kernel/365125
>> * CPUFreq driver: http://thread.gmane.org/gmane.linux.kernel/1812962
>>
>> I have pushed a branch here for testing:
> 
> I am not too familiar with DVFS, but after going through this series it 
> really seems to me that this could use devfreq. In its current form this 
> driver mixes control and policy and lacks flexibility, preventing e.g. 
> to switch to a performance or power-saving profile. Could you study the 
> feasibility of using devfreq for this?

Yeah, I started writing a devfreq driver, but then I looked in more
detail to the downstream driver and realized that most of the
functionality that devfreq provides overlaps with the hw.

The ACTMON can be configured to fire an interrupt when a set of
thresholds are crossed, similar to the simple-ondemand governor but a
bit more sophisticated. The only functionality of the governors that
isn't covered by the ACTMON hw is determining the new frequency after a
threshold has been crossed, but if we want to retain the flexibility of
the downstream solution, we would need to write a new governor anyway.

I realize that it would be cool to reuse the code in devfreq, but being
able to let the hw sample the counters, calculating averages and
checking if a threshold has been crossed without the cpu having to
intervene gives this SoC quite an edge when compared to its competitors.

Regards,

Tomeu

