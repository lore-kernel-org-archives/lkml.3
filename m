Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab3CNJXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 05:23:43 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19768 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab3CNJXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 05:23:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 14 Mar 2013 02:23:36 -0700
Message-ID: <1363253287.3311.32.camel@bilhuang-vm1>
Subject: Re: [RFC 1/1] clk: Add notifier support in
 clk_prepare_enable/clk_disable_unprepare
From: Bill Huang <bilhuang@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 14 Mar 2013 02:28:07 -0700
In-Reply-To: <20130314092132.GE18519@tbergstrom-lnx.Nvidia.com>
References: <1363091861-21534-1-git-send-email-bilhuang@nvidia.com>
	 <20130312134032.GU4977@n2100.arm.linux.org.uk>
	 <1363139273.21694.11.camel@bilhuang-vm1> <514003B6.8020904@wwwdotorg.org>
	 <1363151317.3311.9.camel@bilhuang-vm1> <51400D9D.9060305@wwwdotorg.org>
	 <1363153204.3311.14.camel@bilhuang-vm1> <5140C12A.4060900@wwwdotorg.org>
	 <1363227311.3311.30.camel@bilhuang-vm1>
	 <20130314092132.GE18519@tbergstrom-lnx.Nvidia.com>
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-9"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-14 at 17:21 +0800, Peter De Schrijver wrote:
> On Thu, Mar 14, 2013 at 03:15:11AM +0100, Bill Huang wrote:
> 
> > I don't think deferring will work either, considering the usage of DVFS,
> > device voltage is tightly coupled with frequency, when clock rate is
> > about to increase, we have to boost voltage first and we can lower the
> > voltage after the clock rate has decreased. All the above sequence have
> > to be guaranteed or you might crash, so deferring not only make thing
> > complicated in controlling the order but also hurt performance.
> 
> But we could use notifiers in clk_prepare/clk_unprepare to set the voltage no?
> As clk_prepare/clk_unprepare have to be called before clk_enable or after
> clk_disable, the voltage can be raised to a safe level, before the clock
> becomes active.

Thanks Peter, actually I'm just about to propose my v2 RFC which add
notifier in clk_prepare/clk_unprepare.
> 
> Cheers,
> 
> Peter.


