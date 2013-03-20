Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab3CTNez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:34:55 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15859 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab3CTNex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:34:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 20 Mar 2013 06:34:52 -0700
Message-ID: <5149BA6E.7070003@nvidia.com>
Date: Wed, 20 Mar 2013 19:02:30 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "lrg@ti.com" <lrg@ti.com>
Subject: Re: [PATCH 2/2] regulator: palmas: add input supply names
References: <1363598989-25112-1-git-send-email-ldewangan@nvidia.com> <20130320123128.GM28775@opensource.wolfsonmicro.com> <5149B19E.90400@nvidia.com> <20130320132531.GO28775@opensource.wolfsonmicro.com>
In-Reply-To: <20130320132531.GO28775@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 March 2013 06:55 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Wed, Mar 20, 2013 at 06:24:54PM +0530, Laxman Dewangan wrote:
>
>> The regulator core register the regulator even if there is NULL
>> init_data and in this case, it tries to findout the input-supply
>> (provided through desc->supply_name) and it fails to find out the
>> supply handle and so regulator register fails cause all regulator
>> registration to fail.
>> So providing the dec->supply_name only in case of valid init_data.
> This works fine if you have a device per regulator instead of a device
> for all the regulators on the chip...  I would be inclined to address
> this by providing a "floating" supply and connecting everythinng to
> that.
I am fine with adding floating supply similar to below and connect all 
non-connected supply pins to this.

                 floating: regulator@1 {
                         compatible = "regulator-fixed";
                         reg = <1>;
                         regulator-name = "floating";
                 };

If this is fine then I will respin the patch to remove condition.

