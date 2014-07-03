Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbaGCDLB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 23:11:01 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9967 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaGCDK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 23:10:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 02 Jul 2014 20:04:23 -0700
Message-ID: <53B4C9C0.4000605@nvidia.com>
Date: Thu, 3 Jul 2014 12:10:56 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] ARM: tegra: roth: add display DT node
References: <1404303560-32209-1-git-send-email-acourbot@nvidia.com> <1404303560-32209-5-git-send-email-acourbot@nvidia.com> <53B42B60.1000600@wwwdotorg.org>
In-Reply-To: <53B42B60.1000600@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2014 12:55 AM, Stephen Warren wrote:
> On 07/02/2014 06:19 AM, Alexandre Courbot wrote:
>> DSI support has been fixed to support continuous clock behavior that the
>> panel used on SHIELD requires, so finally add its device tree node since
>> it is functional.
>
>> diff --git a/arch/arm/boot/dts/tegra114-roth.dts b/arch/arm/boot/dts/tegra114-roth.dts
>
>> +	host1x@50000000 {
>> +		dsi@54300000 {
>
> That node looks fine, but I wonder why we need to mark a bunch of
> regulators as always-on? shouldn't the references to vdd-supply and
> power-supply from this node be enough? If not, perhaps the tree
> structure of the regulators isn't correct, or the DSI or panel bindings
> don't allow enough regulators to be referenced?

regulator-always-on is indeed not needed for vdd_lcd. I actually had a 
patch in my tree removing this line that I forgot to squash. Will post a 
v2 for this patch that fixes this, thanks.

vdd-2v8-display needs to remain always-on however. Here we may hit a 
limitation of the simple-panel driver, where only one power supply can 
be provided.
