Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab3JQHwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 03:52:39 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9532 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab3JQHwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 03:52:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 17 Oct 2013 00:48:09 -0700
Date: Thu, 17 Oct 2013 10:52:34 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 00/19] Introduce common infra for tegra clocks
Message-ID: <20131017075233.GP5643@tbergstrom-lnx.Nvidia.com>
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
 <525D8009.5040907@wwwdotorg.org>
 <20131016090643.GI5643@tbergstrom-lnx.Nvidia.com>
 <525EC973.7060802@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <525EC973.7060802@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 07:14:27PM +0200, Stephen Warren wrote:
> On 10/16/2013 03:06 AM, Peter De Schrijver wrote:
> > On Tue, Oct 15, 2013 at 07:48:57PM +0200, Stephen Warren wrote:
> >> On 10/15/2013 08:52 AM, Peter De Schrijver wrote:
> >>> This patchset introduces common infrastructure for clocks which exist in                                                                                       
> >>> several Tegra SoCs. We also also move Tegra20, Tegra30 and Tegra114 to
> >>> this new infrastructure.
> ...
> >> Testing on Venice2 (Tegra124): I see the following WARN during boot,
> >> which I think is new relative to the internal branch you gave me yesterday:
> >>
> >>> [    0.300450] WARNING: CPU: 0 PID: 1 at drivers/clk/tegra/clk.c:187 tegra_init_from_table+0x78/0x158()
> ...
> >>> [    0.372440] [<c07b4c1c>] (tegra_init_from_table+0x78/0x158) from [<c07b4e10>] (tegra_clocks_apply_init_table+0x18/0x20)
> >>> [    0.384138] [<c07b4e10>] (tegra_clocks_apply_init_table+0x18/0x20) from [<c079f9cc>] (tegra_dt_init+0xc/0xd8)
> >>> [    0.394903] [<c079f9cc>] (tegra_dt_init+0xc/0xd8) from [<c079a580>] (customize_machine+0x1c/0x40)
> ...
> > Did you see  'tegra_init_from_table: Failed to set parent pll_c2 of epp ' before? Tegra124 doesn't have EPP...
> 
> Yes, I get exactly that message. Sorry, I forgot to paste in the most
> relevant line:-( I assume fixing this simply means removing an entry in
> the init table in clk-tegra124.c, so should be simple.

Yep. Part of the next version.

