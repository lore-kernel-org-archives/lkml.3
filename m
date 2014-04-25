Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaDYQbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:31:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43353 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbaDYQbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:31:51 -0400
Message-ID: <535A8DF5.4090104@codeaurora.org>
Date: Fri, 25 Apr 2014 11:31:49 -0500
From: Timur Tabi <timur@codeaurora.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:28.0) Gecko/20100101 Firefox/28.0 SeaMonkey/2.25
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Westerberg, Mika" <mika.westerberg@intel.com>
CC: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
References: <534D0370.50108@linux.intel.com> <535005BA.1040405@codeaurora.org> <5357A80B.8030701@linux.intel.com> <5357ACF1.9070206@codeaurora.org> <20140423135915.GY30677@intel.com> <5357D8CC.3080501@codeaurora.org> <20140424063546.GA30677@intel.com> <5358F30E.9080402@codeaurora.org> <20140424115848.GG30677@intel.com> <53592D04.4040001@codeaurora.org> <20140425074156.GI30677@intel.com> <535A899E.5020801@codeaurora.org> <535A8B91.6030903@intel.com>
In-Reply-To: <535A8B91.6030903@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
>>
>
> I would be interested in understanding what exactly the flow is in that
> situation, so care to educate me?  What does the driver do to trigger
> this and what exactly does happen in response to that?

I only just learned some of this myself, so I'm no expert.  My 
understanding is that the all of the pinctrl-* properties and nodes are 
scanned by the pinctrl layer itself.  So you could have a SATA 
controller node that points to a pin control node (via phandles).  When 
the SATA driver is probed, the pinctrl layer notices the phandles and 
automatically calls the pinctrl layer to configure the pins and pin muxes.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by The Linux Foundation.
