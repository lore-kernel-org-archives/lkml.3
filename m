Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab3AXErH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 23:47:07 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13886 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab3AXEq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 23:46:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 23 Jan 2013 20:45:21 -0800
Message-ID: <5100BC87.30301@nvidia.com>
Date: Thu, 24 Jan 2013 10:15:59 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        AnilKumar Ch <anilkumar@ti.com>
Subject: Re: [PATCH 2/2] regulator: tps65910: Fix using wrong dev argument
 for calling of_regulator_match
References: <1358994450.20257.1.camel@phoenix> <1358994705.20257.4.camel@phoenix>
In-Reply-To: <1358994705.20257.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 January 2013 08:01 AM, Axel Lin wrote:
> The dev parameter is the device requesting the data.
> In this case it should be &pdev->dev rather than pdev->dev.parent.
>
> The dev parameter is used to call devm_kzalloc in of_get_regulator_init_data(),
> which means this fixes a memory leak because the memory is allocated every time
> probe() is called, thus it should be freed when this driver is unloaded.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---

Agree with the change.
Acked-by: Laxman Dewangan<ldewangan@nvidia.com>

