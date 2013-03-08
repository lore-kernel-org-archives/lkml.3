Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934617Ab3CHSPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:15:49 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19045 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934561Ab3CHSPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:15:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 08 Mar 2013 10:09:34 -0800
Message-ID: <513A2A6D.7080604@nvidia.com>
Date: Fri, 8 Mar 2013 23:44:05 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH 4/5] ARM: DT: tegra114: add KBC controller DT entry
References: <1362750782-15174-1-git-send-email-ldewangan@nvidia.com> <1362750782-15174-5-git-send-email-ldewangan@nvidia.com> <513A2810.1070903@wwwdotorg.org>
In-Reply-To: <513A2810.1070903@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 March 2013 11:34 PM, Stephen Warren wrote:
> On 03/08/2013 06:53 AM, Laxman Dewangan wrote:
>> NVIDIA's Tegra114 SoCs have the matrix keyboard controller which
>> supports 11x8 type of matrix. The number of rows and columns
>> are configurable.
> Earlier Tegra versions supported up to a 16x8 matrix. This feeds into
> the following defines in the driver:
>
> #define KBC_MAX_GPIO    24
> #define KBC_MAX_ROW     16
> #define KBC_MAX_COL     8
> #define KBC_MAX_KEY     (KBC_MAX_ROW * KBC_MAX_COL)
>
> Given Tegra114 supports /fewer/ pins and rows than earlier chips, I
> think that makes the HW technically incompatible, since GPIO IDs 19..23
> are invalid in this HW but valid earlier.
>
> Now in practice I suppose that with a correct DT keyboard map for a
> Tegra114 device, those extra invalid GPIOs would never be referenced, so
> this is a little nit-picky, but I still feel we should fix this.

Where do we fix this? In binding document?

>
> So, I'd like to see the KBC driver updated to derive the values for all
> the defines I listed above from the compatible value.

Ok, we can update the kbc driver to derive above param from compatible.

>
>
>
> Re-stated: The rules for compatible are: Always include the exact HW
> name, then optionally include any other HW names it's compatible with.

OK, will update this in next version of patch.
>

