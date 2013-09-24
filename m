Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab3IXJcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:32:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61259 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708Ab3IXJc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:32:29 -0400
Date: Tue, 24 Sep 2013 10:32:22 +0100
From: Will Deacon <will.deacon@arm.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "nico@linaro.org" <nico@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "dave.martin@linaro.org" <dave.martin@linaro.org>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH -next] drivers: CCI: fix the error handle in
 cci_pmu_probe()
Message-ID: <20130924093222.GC15119@mudshark.cambridge.arm.com>
References: <CAPgLHd9jKOp71tN43=oOUN4X_niTonuQExO1yMSy=3odoRqTcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd9jKOp71tN43=oOUN4X_niTonuQExO1yMSy=3odoRqTcQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 06:04:23AM +0100, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> This patch fix the error handle of function cci_pmu_probe():
> - using IS_ERR() instead of NULL test for the return value of
>   devm_ioremap_resource() since it nerver return NULL.
> - remove kfree() for devm_kzalloc allocated memory
> - remove dev_warn() since devm_ioremap_resource() has error message
>   already.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Cheers Wei, I'll add this as a new patch on top of my perf branch.

Will
