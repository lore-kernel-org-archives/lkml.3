Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbaKGJHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:07:39 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15549 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaKGJHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:07:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 07 Nov 2014 01:06:35 -0800
Message-ID: <545C8BCC.3090908@nvidia.com>
Date: Fri, 7 Nov 2014 18:07:24 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>, <linux-kernel@vger.kernel.org>
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH 0/3] Add support for Tegra Activity Monitor
References: <1414594232-15684-1-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1414594232-15684-1-git-send-email-tomeu.vizoso@collabora.com>
X-NVConfidentiality: public
X-Originating-IP: [10.19.57.128]
X-ClientProxiedBy: HKMAIL102.nvidia.com (10.18.16.11) To
 HKMAIL102.nvidia.com (10.18.16.11)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 11:50 PM, Tomeu Vizoso wrote:
> Hello,
>
> these patches implement support for setting the rate of the EMC clock based on
> stats collected from the ACTMON, a piece of hw in the Tegra124 that counts
> memory accesses (among others).
>
> It depends on the following in-flight patches:
>
> * MC driver: http://thread.gmane.org/gmane.linux.ports.tegra/19623
> * EMC driver: http://thread.gmane.org/gmane.linux.ports.arm.kernel/365125
> * CPUFreq driver: http://thread.gmane.org/gmane.linux.kernel/1812962
>
> I have pushed a branch here for testing:

I am not too familiar with DVFS, but after going through this series it 
really seems to me that this could use devfreq. In its current form this 
driver mixes control and policy and lacks flexibility, preventing e.g. 
to switch to a performance or power-saving profile. Could you study the 
feasibility of using devfreq for this?

I also wonder if this driver could not be made more flexible generally 
speaking - right now it is hardcoded that you can only control EMC 
frequency with it. I can imagine that we could want to control several 
clocks using the same counter information, and that e.g. a notifier 
block might help with that. But let's keep that for later - whether to 
use devfreq or not seems to be the most important question for now.
