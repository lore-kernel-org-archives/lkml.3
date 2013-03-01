Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab3CAJay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 04:30:54 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8502 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab3CAJax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 04:30:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 01 Mar 2013 01:30:51 -0800
Message-ID: <1362130891.19498.12.camel@bilhuang-vm1>
Subject: Re: [PATCH 2/5] clk: notifier handler for dynamic voltage scaling
From: Bill Huang <bilhuang@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Date: Fri, 1 Mar 2013 01:41:31 -0800
In-Reply-To: <1362026969-11457-3-git-send-email-mturquette@linaro.org>
References: <1362026969-11457-1-git-send-email-mturquette@linaro.org>
	 <1362026969-11457-3-git-send-email-mturquette@linaro.org>
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-9"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-28 at 12:49 +0800, Mike Turquette wrote:
> Dynamic voltage and frequency scaling (dvfs) is a common power saving
> technique in many of today's modern processors.  This patch introduces a
> common clk rate-change notifier handler which scales voltage
> appropriately whenever clk_set_rate is called on an affected clock.

I really think clk_enable and clk_disable should also be triggering
notifier call and DVFS should act accordingly since there are cases
drivers won't set clock rate but instead disable its clock directly, do
you agree?
> 
> There are three prerequisites to using this feature:
> 
> 1) the affected clocks must be using the common clk framework
> 2) voltage must be scaled using the regulator framework
> 3) clock frequency and regulator voltage values must be paired via the
> OPP library

Just a note, Tegra Core won't meet prerequisite #3 since each regulator
voltage values is associated with clocks driving those many sub-HW
blocks in it.


