Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609Ab3D3MrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 08:47:18 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15118 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760555Ab3D3MrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 08:47:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 30 Apr 2013 05:47:16 -0700
Message-ID: <517FBC38.3000108@nvidia.com>
Date: Tue, 30 Apr 2013 18:12:32 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: "djbw@fb.com" <djbw@fb.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dma: tegra: implement suspend/resume callbacks
References: <1366797267-29567-1-git-send-email-ldewangan@nvidia.com> <20130430103046.GD1960@intel.com>
In-Reply-To: <20130430103046.GD1960@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 April 2013 04:00 PM, Vinod Koul wrote:
> On Wed, Apr 24, 2013 at 03:24:27PM +0530, Laxman Dewangan wrote:
>> +
>> +	/* Enable clock before accessing register */
>> +	ret = tegra_dma_runtime_resume(dev);
>> +	if (ret < 0)
>> +		return ret;
> You dont seem to handle suspend when DMA is active? Otherwise looks fine.
> Stephen, you okay with this patch?

The client of dma need to gracefully stop the transfer and then do 
suspend himself.
Also driver suspend can happen even if there is no allocation of dma. In 
this case, clock is disabled so enabling explicitly here.

