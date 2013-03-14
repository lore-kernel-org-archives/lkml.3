Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab3CNJV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 05:21:56 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11201 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab3CNJVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 05:21:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 14 Mar 2013 02:21:35 -0700
Date: Thu, 14 Mar 2013 11:21:32 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Bill Huang <bilhuang@nvidia.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC 1/1] clk: Add notifier support in
 clk_prepare_enable/clk_disable_unprepare
Message-ID: <20130314092132.GE18519@tbergstrom-lnx.Nvidia.com>
References: <1363091861-21534-1-git-send-email-bilhuang@nvidia.com>
 <20130312134032.GU4977@n2100.arm.linux.org.uk>
 <1363139273.21694.11.camel@bilhuang-vm1>
 <514003B6.8020904@wwwdotorg.org>
 <1363151317.3311.9.camel@bilhuang-vm1>
 <51400D9D.9060305@wwwdotorg.org>
 <1363153204.3311.14.camel@bilhuang-vm1>
 <5140C12A.4060900@wwwdotorg.org>
 <1363227311.3311.30.camel@bilhuang-vm1>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1363227311.3311.30.camel@bilhuang-vm1>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 03:15:11AM +0100, Bill Huang wrote:

> I don't think deferring will work either, considering the usage of DVFS,
> device voltage is tightly coupled with frequency, when clock rate is
> about to increase, we have to boost voltage first and we can lower the
> voltage after the clock rate has decreased. All the above sequence have
> to be guaranteed or you might crash, so deferring not only make thing
> complicated in controlling the order but also hurt performance.

But we could use notifiers in clk_prepare/clk_unprepare to set the voltage no?
As clk_prepare/clk_unprepare have to be called before clk_enable or after
clk_disable, the voltage can be raised to a safe level, before the clock
becomes active.

Cheers,

Peter.
