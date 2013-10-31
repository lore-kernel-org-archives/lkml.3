Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab3JaPly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:41:54 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7899 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab3JaPlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:41:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 31 Oct 2013 08:41:13 -0700
Date: Thu, 31 Oct 2013 17:41:42 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Mark Zhang <markz@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: use pll_ref as the pll_e parent
Message-ID: <20131031154142.GX22111@tbergstrom-lnx.Nvidia.com>
References: <1383093707-10312-1-git-send-email-pdeschrijver@nvidia.com>
 <527128B5.2020101@wwwdotorg.org>
 <20131030221833.GQ22111@tbergstrom-lnx.Nvidia.com>
 <52718D1B.6030106@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52718D1B.6030106@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 11:50:03PM +0100, Stephen Warren wrote:
> On 10/30/2013 04:18 PM, Peter De Schrijver wrote:
> > On Wed, Oct 30, 2013 at 04:41:41PM +0100, Stephen Warren wrote:
> >> On 10/29/2013 06:41 PM, Peter De Schrijver wrote:
> >>> Use pll_ref instead of pll_re_vco as the pll_e parent on Tegra114 and
> >>> Tegra124. Also add a pll_ref table entry for pll_e for Tegra114.
> >>
> >> Why? What benefit does this give, or what bug does this fix?
> > 
> > Otherrwise Tegra114 will crash on boot.
> 
> Sigh. For what reason?

pll_re_vco having an unsupported rate of 300Mhz. My guess is that it depends
on the bootloader if you will see this. I'm fairly sure I verified this on
my dalmore in helsinki and it worked, but it failed on Paul's test setup.

Cheers,

Peter.
