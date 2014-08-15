Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaHOWpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 18:45:20 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:18796 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaHOWpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 18:45:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 15 Aug 2014 15:35:55 -0700
Date: Sat, 16 Aug 2014 01:45:13 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        Alex Courbot <acourbot@nvidia.com>,
        "Sebastian Hesselbarth" <sebastian.hesselbarth@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/6] clk: tegra: don't abort clk init on error
Message-ID: <20140815224513.GM1626@tbergstrom-lnx.Nvidia.com>
References: <1405437890-6468-1-git-send-email-pdeschrijver@nvidia.com>
 <1405437890-6468-2-git-send-email-pdeschrijver@nvidia.com>
 <53CE9C5F.1030005@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53CE9C5F.1030005@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 07:16:15PM +0200, Stephen Warren wrote:
> On 07/15/2014 09:24 AM, Peter De Schrijver wrote:
> > Just continue initializing clocks if there's an error on one of them. This
> > is useful if there's a mistake in the inittable, because the system could
> > hang if clk_disable_unused() disables some of the critical clocks in this
> > table.
> 
> If there's a problem in the init table, we should simply fix it instead
> of working around it.
> 

Yes, ofcourse. However today we silently stop processing the init_table if a
clock cannot be found. That doesn't sound right either to me and makes detecting
wrong entries in the table more complex than it should be.

> At the very least, we need to WARN on this rather than just ignoring
> problems.

Cheers,

Peter.
