Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab3JARjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 13:39:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55166 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab3JARjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 13:39:13 -0400
Message-ID: <524B08BD.2020902@wwwdotorg.org>
Date: Tue, 01 Oct 2013 11:39:09 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 00/12] Introduce common infra for tegra clocks
References: <1379946381-20125-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1379946381-20125-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 08:24 AM, Peter De Schrijver wrote:
> This patchset introduces common infrastructure for clocks which exist in
> several Tegra SoCs. We also move Tegra114 to this new infrastructure.
> Tegra20 and Tegra30 will be moved later in separate patchsets.
> 
> Changes since v1:
> + move common clks allocation to patch 2
> + adapt also Tegra20 and Tegra30 to the changes in patch 2
> 
> Boottested on dalmore, beaverboard and seaboard.

What commit is this series based on? I applied the two pre-requisites:

ARM: tegra114: add missing clocks to binding.eml
clk: tegra: replace enum tegra114_clk by binding header.eml

... but still got a bunch of conflicts when applying this. I guess at
least commit 819c1de "clk: add CLK_SET_RATE_NO_REPARENT flag" isn't in
the history of this series. Consequently, I gave up and didn't test this.

Also, I had given a lot of feedback on v1. Admittedly I should have
reviewed v2 since it appeared just before I reviewed v1, but I expect
most of the feedback still applies given the limited list of changes
listed above. Certainly, this series still removes the "dsib" clock yet
I expect it shouldn't (patch 1, in the change to
tegra114_periph_clk_init()), and that's the very first piece of feedback
I gave on v1, and also causes the first "git am" conflict with
CLK_SET_RATE_NO_REPARENT.
