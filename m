Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbaKCPso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:48:44 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38992 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaKCPsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:48:41 -0500
Message-ID: <5457A3D2.1090602@collabora.co.uk>
Date: Mon, 03 Nov 2014 16:48:34 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 03/14] regulator: of: Add regulator desc param to of_get_regulator_init_data()
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk> <1415025649-8119-4-git-send-email-javier.martinez@collabora.co.uk> <20141103153303.GQ3815@sirena.org.uk>
In-Reply-To: <20141103153303.GQ3815@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2014 04:33 PM, Mark Brown wrote:
> On Mon, Nov 03, 2014 at 03:40:38PM +0100, Javier Martinez Canillas wrote:
> 
>>  	for_each_child_of_node(nproot, np) {
>>  		if (!of_node_cmp(np->name, info->desc.name)) {
>>  			config->init_data =
>> -				of_get_regulator_init_data(&pdev->dev, np);
>> +				of_get_regulator_init_data(&pdev->dev, np,
>> +							   NULL);
> 
> This looks buggy, we're not passing in a descriptor.
> 

The descriptor is only used when extracting the init_data to map the
modes and since it was not a parameter before, some drivers needs to
be refactored to pass that information.

I thought that instead of adding intrusive changes in drivers that I
don't have hw to test, that parameter could be optional so the patch
that use that information check if the descriptor and the map_modes
function pointer are not NULL.

Best regards,
Javier
