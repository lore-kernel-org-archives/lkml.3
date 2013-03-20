Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab3CTM5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:57:18 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11747 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab3CTM5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:57:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 20 Mar 2013 05:57:15 -0700
Message-ID: <5149B19E.90400@nvidia.com>
Date: Wed, 20 Mar 2013 18:24:54 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "lrg@ti.com" <lrg@ti.com>
Subject: Re: [PATCH 2/2] regulator: palmas: add input supply names
References: <1363598989-25112-1-git-send-email-ldewangan@nvidia.com> <20130320123128.GM28775@opensource.wolfsonmicro.com>
In-Reply-To: <20130320123128.GM28775@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 March 2013 06:01 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Mon, Mar 18, 2013 at 02:59:48PM +0530, Laxman Dewangan wrote:
>
> There's something odd about several recent patch serieses you've posted,
> they end up with patch 2 before instead of after patch 1.  Anyway...

I generally send a patches on single git-send command
git send-emal --to=ldewangan@nvidia.com 0000.patch 0001.patch

So file names are in seq but not sure why it is not on seq. Something 
mail exchange  resuffle.
Probably I need to send one by one...


>
>> +		if (config.init_data)
>> +			pmic->desc[id].supply_name = palmas_regs_info[id].sname;
>> +
> This looks wrong...  why is it conditional on init_data?

Some of the rails are not used in board and hence their inputs are also 
left floating (unconnected). In this case, during DT population, I did 
not put entry
i.e. if ldo1 is not used then ldo1-in is not connected on board and hence
entry on DT

ldo1-in-supply=<&xyzreg>;

is not there.

The regulator core register the regulator even if there is NULL 
init_data and in this case, it tries to findout the input-supply 
(provided through desc->supply_name) and it fails to find out the supply 
handle and so regulator register fails cause all regulator registration 
to fail.

So providing the dec->supply_name only in case of valid init_data.



