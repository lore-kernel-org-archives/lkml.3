Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934485Ab3BTRgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:36:48 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39870 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933904Ab3BTRgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:36:46 -0500
Message-ID: <512509A9.6020208@wwwdotorg.org>
Date: Wed, 20 Feb 2013 10:36:41 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
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
References: <1361281115-20436-1-git-send-email-ldewangan@nvidia.com> <5123C18A.9010604@wwwdotorg.org> <5124C18F.6070108@nvidia.com> <20130220131112.GE2726@opensource.wolfsonmicro.com> <5124CEF5.3060605@nvidia.com> <512506F9.2030508@wwwdotorg.org> <20130220173109.GU2726@opensource.wolfsonmicro.com>
In-Reply-To: <20130220173109.GU2726@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 10:31 AM, Mark Brown wrote:
> On Wed, Feb 20, 2013 at 10:25:13AM -0700, Stephen Warren wrote:
> 
>> But, please do think this approach through fully. The DT binding
>> needs to define which clock-names the driver requires to be
>> present, and any optional clock names. DT bindings are supposed
>> to be immutable, or perhaps extendible in a completely
>> backwards-compatible fashion. This implies that you need to have
>> thought through the entire list of clocks that the driver might
>> want in the DT clock-names property when you first write the DT
>> binding documentation...
> 
> Since we can extend the list of clocks it doesn't seem like there's
> much issue here, especially if some of them are optional?

Yes, there's certainly a way to extend the binding in a
backwards-compatible way.

However, I have seen in Rob and/or Grant push back on not fully
defining bindings in the past - i.e. actively planning to initially
create a minimal binding and extend it in the future, rather than
completely defining it up-front.

I don't know how strong of a rule they intend that to be though. If we
get to the point of moving the DT bindings out of the kernel, it'd be
good to get a concrete definition of what can and can't be changed in
bindings.

> Though in general it seems like this sort of mux really should be
> in the clock stuff anyway.

How do you see that working: something automatic inside clk_set_rate()
seeing that some other parent could provide the rate, so the clock
could be reparented, or ...?
