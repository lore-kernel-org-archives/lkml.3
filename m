Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab3CBC62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 21:58:28 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12733 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3CBC61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 21:58:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 01 Mar 2013 18:58:21 -0800
Message-ID: <1362193098.2407.27.camel@bilhuang-vm1>
Subject: Re: [PATCH 2/5] clk: notifier handler for dynamic voltage scaling
From: Bill Huang <bilhuang@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mike Turquette <mturquette@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>
Date: Fri, 1 Mar 2013 18:58:18 -0800
In-Reply-To: <5131143D.2060904@wwwdotorg.org>
References: <1362026969-11457-1-git-send-email-mturquette@linaro.org>
	 <1362026969-11457-3-git-send-email-mturquette@linaro.org>
	 <1362130891.19498.12.camel@bilhuang-vm1> <5131143D.2060904@wwwdotorg.org>
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-9"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-02 at 04:49 +0800, Stephen Warren wrote:
> On 03/01/2013 02:41 AM, Bill Huang wrote:
> > On Thu, 2013-02-28 at 12:49 +0800, Mike Turquette wrote:
> >> There are three prerequisites to using this feature:
> >>
> >> 1) the affected clocks must be using the common clk framework
> >> 2) voltage must be scaled using the regulator framework
> >> 3) clock frequency and regulator voltage values must be paired via the
> >> OPP library
> > 
> > Just a note, Tegra Core won't meet prerequisite #3 since each regulator
> > voltage values is associated with clocks driving those many sub-HW
> > blocks in it.
> 
> Perhaps that "just" means extending the dvfs.c code here to iterate over
> each clock consumer (rather than each clock provider), and having each
> set a minimum voltage (rather than a specific voltage), and having the
> regulator core apply the maximum of those minimum constraints?
> 
> Or something like that anyway.

Thanks, I'll think about this or maybe study a bit, it sounds like we
can leverage existing api in regulator framework (which I don't know) to
do what you've proposed, please clarify if I misunderstand.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


