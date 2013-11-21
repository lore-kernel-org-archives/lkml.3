Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab3KUNNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:13:21 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15606 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab3KUNNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:13:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 21 Nov 2013 05:07:16 -0800
Date: Thu, 21 Nov 2013 15:12:18 +0200
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Grant Likely <grant.likely@linaro.org>
CC: Stephen Warren <swarren@nvidia.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5 1/9] of: introduce
 of_property_for_earch_phandle_with_args()
Message-ID: <20131121151218.befbb483c0cf09cdcd4cd4dd@nvidia.com>
In-Reply-To: <20131121124328.46BC1C40A2C@trevor.secretlab.ca>
References: <1384853593-32202-1-git-send-email-hdoyu@nvidia.com>
	<1384853593-32202-2-git-send-email-hdoyu@nvidia.com>
	<20131121124328.46BC1C40A2C@trevor.secretlab.ca>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013 13:43:28 +0100
Grant Likely <grant.likely@linaro.org> wrote:

> On Tue, 19 Nov 2013 11:33:05 +0200, Hiroshi Doyu <hdoyu@nvidia.com> wrote:
> > The following pattern of code is tempting:
> > 
> >   for (i = 0; !of_parse_phandle_with_args(np, list, cells, i, args); i++)
> > 
> > Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> 
> That's a very minimal commit message. Can you elaborate please.

The above can be:

"
  The following pattern of code is tempting to add a new member for
  of_property_for_each_*() family as an idiom.
  
    for (i = 0;
        !of_parse_phandle_with_args(np, list, cells, i, args); i++)
                  <do something with "args">;
"

Actual usage is here:

        int i;
        struct of_phandle_args args;

        of_property_for_each_phandle_with_args(dev->of_node, "iommus",
                                               "#iommu-cells", i, &args) {
                pr_debug("%s(i=%d) %s\n", __func__, i, dev_name(dev));

                if (!of_find_iommu_by_node(args.np))
                        return -EPROBE_DEFER;

Is this acceptable?
