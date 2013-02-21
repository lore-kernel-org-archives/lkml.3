Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab3BUFt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 00:49:27 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10291 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab3BUFt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 00:49:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 20 Feb 2013 21:44:44 -0800
Message-ID: <5125B534.1080606@nvidia.com>
Date: Thu, 21 Feb 2013 11:18:36 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] spi: tegra114: add spi driver
References: <1361281115-20436-1-git-send-email-ldewangan@nvidia.com> <5123C18A.9010604@wwwdotorg.org> <5124C18F.6070108@nvidia.com> <20130220131112.GE2726@opensource.wolfsonmicro.com> <5124CEF5.3060605@nvidia.com> <512506F9.2030508@wwwdotorg.org> <20130220173109.GU2726@opensource.wolfsonmicro.com> <512509A9.6020208@wwwdotorg.org> <20130220175721.GW2726@opensource.wolfsonmicro.com> <51250F22.8050401@wwwdotorg.org>
In-Reply-To: <51250F22.8050401@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2013 11:30 PM, Stephen Warren wrote:
> On 02/20/2013 10:57 AM, Mark Brown wrote:
>> On Wed, Feb 20, 2013 at 10:36:41AM -0700, Stephen Warren wrote:
>>> On 02/20/2013 10:31 AM, Mark Brown wrote:
>>>> Since we can extend the list of clocks it doesn't seem like
>>>> there's much issue here, especially if some of them are
>>>> optional?
>>> Yes, there's certainly a way to extend the binding in a
>>> backwards-compatible way.
>>> However, I have seen in Rob and/or Grant push back on not fully
>>> defining bindings in the past - i.e. actively planning to
>>> initially create a minimal binding and extend it in the future,
>>> rather than completely defining it up-front.
>> That sounds like the current stuff with a minimal definition is
>> OK?
> I'm personally OK with defining a minimal binding first and extending
> it later. But, I'm worried if when we actually try to extend the
> binding later, we'll get push-back.

Yes, for a given controller there is lots of input sources which can be 
mux but we can not use all option as some of source is changeable based 
on DVFS policy or other constraints. Like one of controller has the 
input clock source as PLLC which is again used by CPU and it varies for 
requested CPU frequency. In this context, we would like to not choose 
PLLC as clock source for given controller.

So we may need to provide the list of valid clock source/option from DT 
file and clock muxing should be done from that source list only in place 
of super set supported by SoCs.

