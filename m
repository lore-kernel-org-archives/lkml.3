Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762932Ab3DCSAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 14:00:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44209 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759491Ab3DCSAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 14:00:21 -0400
Message-ID: <515C6C6E.6060302@wwwdotorg.org>
Date: Wed, 03 Apr 2013 11:52:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>,
        Pritesh Raithatha <praithatha@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, Andrew Chew <achew@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 00/14] Tegra114 clockframework
References: <1365000110-8916-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1365000110-8916-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 08:40 AM, Peter De Schrijver wrote:
> This is the nineth version of the Tegra114 clockframework. It is based on the
> next-20130320-fixed branch of
> git://nv-tegra.nvidia.com/user/swarren/linux-2.6.git,

That's not a particularly useful base; these patches won't be applied to
linux-next, but rather to Tegra's for-3.10/clk branch, with the clock
for-next tree merged in to pick up "clk: add table lookup to mux".

> http://patchwork.ozlabs.org/patch/229972/ and

That is "clk: tegra: Don't enable PLLs during early boot". That was
rejected. I assume this isn't really needed given your changelog entry
"Fixed clock initialization for audio", but rather my "clk: tegra: defer
application of init table" should be applied instead?

> http://patchwork.ozlabs.org/patch/229978/ and

For reference, that is "clk: add table lookup to mux", which is in the
clock for-next tree.

> http://patchwork.ozlabs.org/patch/233415/

That is Joseph's "clocksource: tegra: enable arch_timer". Is this
actually a dependency, or an optimization, or ...?

Rob Herring objected to that patch since it isn't necessary if his
series "ARM arch, sp804 and integrator timer CLKSRC_OF support" is applied.

If I apply just your (Peter's) CCF series without Joseph's or Rob's
patches, will everything still work, or is this a hard dependency to
create a working system?
