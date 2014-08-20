Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaHTUYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:24:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33555 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaHTUYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:24:53 -0400
Message-ID: <53F5042A.7020603@wwwdotorg.org>
Date: Wed, 20 Aug 2014 14:25:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, thierry.reding@gmail.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, wni@nvidia.com
Subject: Re: [PATCH v2 5/5] ARM: tegra: Add thermal reset (thermtrip) support
 to PMC
References: <1407933685-12404-1-git-send-email-mperttunen@nvidia.com> <1407933685-12404-6-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1407933685-12404-6-git-send-email-mperttunen@nvidia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 06:41 AM, Mikko Perttunen wrote:
> This adds a device tree controlled option to enable PMC-based
> thermal reset in overheating situations. Thermtrip is supported on
> Tegra30, Tegra114 and Tegra124. The thermal reset only works when
> the thermal sensors are calibrated, so a soctherm driver is also
> required.

If calibration is required, presumably the soctherm must initialize 
before this thermtrip code can initialize, or this thermtrip logic might 
be triggered by uncalibrated sensors?

If so, then there needs to be some explicit mechanism to force the two 
drivers into probing in the right order.
