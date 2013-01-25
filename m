Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab3AYEzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 23:55:37 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:36605 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3AYEze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 23:55:34 -0500
Message-ID: <51021043.3070601@nvidia.com>
Date: Thu, 24 Jan 2013 20:55:31 -0800
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] regulator: max8907: Fix using wrong dev argument
 for calling of_regulator_match
References: <1359080429.4232.3.camel@phoenix>
In-Reply-To: <1359080429.4232.3.camel@phoenix>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 06:20 PM, Axel Lin wrote:
> The dev parameter is the device requesting the data.
> In this case it should be &pdev->dev rather than pdev->dev.parent.
> 
> The dev parameter is used to call devm_kzalloc in of_get_regulator_init_data(),
> which means this fixes a memory leak because the memory is allocated every time
> probe() is called, thus it should be freed when this driver is unloaded.

Reviewed-by: Stephen Warren <swarren@nvidia.com>
