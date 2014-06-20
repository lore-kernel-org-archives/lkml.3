Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966801AbaFTKda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:33:30 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11726 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965650AbaFTKd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:33:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 20 Jun 2014 03:27:40 -0700
Message-ID: <53A40DF5.1060904@nvidia.com>
Date: Fri, 20 Jun 2014 19:33:25 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: TN7: relax some regulators
References: <1403164154-1362-1-git-send-email-acourbot@nvidia.com> <53A308C8.2070004@wwwdotorg.org> <20140619175643.GR5099@sirena.org.uk> <53A3C613.8030207@nvidia.com> <20140620101618.GU5099@sirena.org.uk>
In-Reply-To: <20140620101618.GU5099@sirena.org.uk>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 07:16 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Fri, Jun 20, 2014 at 02:26:43PM +0900, Alexandre Courbot wrote:
>
>> So I can see three questions here:
>
>> 1) Why does _regulator_enable() on vdd_1v8 return 0 while everything
>> suggests that it is enabled (this regulator powers lot of devices, like
>> eMMC, which are working fine). This may be an issue with the palmas driver.
>
> Returning 0 is reporting success and you say it is enabled so I'm not
> seeing any contradiction here...  or do you mean regulator_is_enabled()
> here?  An always on regulator should report that it is enabled.

I meant to write regulator_is_enabled() here, yes. Apologies for the 
confusion.

>
>> 2) When an always-on regulator that is not yet enabled is registered,
>> shouldn't it be switched on by the regulator framework?
>
> This happens during set_machine_constraints().
>
>> 3) When a boot-on regulator is registered and _regulator_is_enabled()
>> returns contradictory information, what should be done?
>
> Same thing here (same check even).

Indeed, everything is coherent here - I was confused by the fact the 
regulator was always reported as disabled, which led me to wrongly 
assume that the framework did not try to enable it. But of course we 
cannot ask the framework to account for drivers that return incorrect 
regulator state, as seems to be the case with Palmas here.

So it all seems to come down to a bug in the Palmas driver introduced by 
dbabd624d. Reverting that change brings me back to normal.

Thanks,
Alex.

