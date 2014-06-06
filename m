Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaFFG1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 02:27:13 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13557 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaFFG1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 02:27:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 05 Jun 2014 23:22:00 -0700
Message-ID: <53915F3B.6050806@nvidia.com>
Date: Fri, 6 Jun 2014 09:27:07 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "tj@kernel.org" <tj@kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 0/9] Serial ATA support for NVIDIA Tegra124
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com> <5390A8F9.2090408@wwwdotorg.org>
In-Reply-To: <5390A8F9.2090408@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only compile-time dependencies here should be that:
- patch 8 of 9 which contains the actual driver depends on patch 6 of 9 
(though only when building as a module) and the efuse series
- patch 2 of 9 refers to the DT node called "padctl", so it requires the 
xusb series. (in the submitted xusb series, the node isn't actually 
named, though. I will fix this in v2)

- Mikko

On 05/06/14 20:29, Stephen Warren wrote:
> On 06/04/2014 05:32 AM, Mikko Perttunen wrote:
>> Hi,
>>
>> This series adds support for the onboard AHCI-compliant Serial ATA
>> controller found on Tegra124 systems-on-chip. The controller is
>> enabled on Jetson TK1. The series depends on Peter's efuse series
>> and Thierry's yet to be submitted XUSB pinctrl driver.
>
> This series includes patches to a lot of different subsystems. That will
> complicate applying it.
>
> Can you write a summary of the *compile time* dependencies, since that
> will influence how the patches get merged.
>
> You mentioned that this series depends on efuse and XUSB padctl. Can you
> point out which specific parts of this series depend on which of those
> two other series, and whether this is a compile-time or run-time dependency.
>
> I hope that the drivers/ata patches, drivers/clk patches, DT, and
> defconfig patches can each be applied to their normal tree and don't
> depend on each-other at compile-time at all.
>
> At run-time, obviously all the patches are needed to make the code work,
> but since this is a new feature, it's fine if this all only works once
> everything is merged together in linux-next or Linus's tree.
>
> Thanks.
>
