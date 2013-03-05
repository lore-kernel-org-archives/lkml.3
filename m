Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3CEWsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:48:11 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46619 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666Ab3CEWsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:48:09 -0500
Message-ID: <51367625.2090405@wwwdotorg.org>
Date: Tue, 05 Mar 2013 15:48:05 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [REPOST PATCH 0/2] Table lookup for mux clock type
References: <1361545358-22721-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1361545358-22721-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 08:02 AM, Peter De Schrijver wrote:
> This patchset adds a table lookup feature to the mux clock type. This will
> be used by the forthcoming Tegra114 clock implementation. Also instead of
> a fixed field width, a mask is used. This is because Tegra114 has some muxes
> where the parent selector is spread over several bitfields. The second patch
> adapts the tegra periph clock implementation which uses struct clk_mux
> directly.
> 
> --
> 
> Mike,
> 
> This patch is a dependency for the Tegra114 CCF implementation. Could you
> review it and merge on a topic branch so Stephen can pull it in to verify
> the integration?

Peter, does this repost you resolve the issue I pointed out at:
http://www.spinics.net/lists/arm-kernel/msg220873.html

To quote:

>>> Just a quick note on patch dependencies here:
>>>
>>> Patch 1/2 can presumably be taken through the clk tree whenever Mike is
>>> OK with it.
>>>
>>> Patch 2/2 depends on patches in the Tegra tree for 3.9. Since patch 2/2
>>> is useful mostly for the Tegra114 clock driver, and I don't imagine that
>>> will get posted/merged in time for 3.9, it's probably easiest to just
>>> take patch 2/2 for 3.10 along with the Tegra114 clock driver. Also, I
>>> imagine there won't be any more clk/Tegra tree dependencies in 3.10, so
>>> patch 2/2 and the Tegra114 clk driver patches can likely go through the
>>> clk tree itself for 3.10.
>> 
>> No. Because 1/2 changes struct clk_mux and the tegra peripheral clock type 
>> uses struct clk_mux directly, 2/2 needs to be applied together with 1/2, even
>> if the new functionality is not yet used.
> 
> Oh, then they can't be two separate patches then, or "git bisect" won't
> work. I guess it's best to wait for 3.10 for this:-(
