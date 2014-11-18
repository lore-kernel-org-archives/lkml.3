Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaKRRD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:03:56 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:60483 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbaKRRDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:03:54 -0500
Date: Tue, 18 Nov 2014 17:03:50 +0000
From: Will Deacon <will.deacon@arm.com>
To: Sudeep Holla <Sudeep.Holla@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, "jcm@redhat.com" <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "Kangkang.Shen@huawei.com" <Kangkang.Shen@huawei.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v5 01/18] ARM64: Move the init of cpu_logical_map(0)
 before unflatten_device_tree()
Message-ID: <20141118170349.GU18842@arm.com>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>
 <1413553034-20956-2-git-send-email-hanjun.guo@linaro.org>
 <546B4D8D.2020605@linaro.org>
 <20141118164312.GL28279@e104818-lin.cambridge.arm.com>
 <20141118165713.GT18842@arm.com>
 <546B7B8D.1070201@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <546B7B8D.1070201@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 05:02:05PM +0000, Sudeep Holla wrote:
> On 18/11/14 16:57, Will Deacon wrote:
> > On Tue, Nov 18, 2014 at 04:43:13PM +0000, Catalin Marinas wrote:
> >> On Tue, Nov 18, 2014 at 01:45:49PM +0000, Hanjun Guo wrote:
> >>> On 2014年10月17日 21:36, Hanjun Guo wrote:
> >>>> It always make sense to initialize CPU0's logical map entry from the
> >>>> hardware values, so move the initialization of cpu_logical_map(0)
> >>>> before unflatten_device_tree() which is needed by ACPI code later.
> >>>>
> >>>> Acked-by: Olof Johansson <olof@lixom.net>
> >>>> Acked-by: Mark Rutland <mark.rutland@arm.com>
> >>>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> >>>
> >>> Could you merge this patch first in 3.19? It was acked by Olof and
> >>> Mark, and it will make sense without ACPI too.
> >>
> >> I think it can go in for 3.19 (it's Will's turn this time ;)).
> >
> > This patch doesn't apply on for-next/core, as it conflicts with some of
> > Rutland's rework ("arm64: log physical ID of boot CPU").
> >
> 
> It's actually not required anymore, as "arm64: log physical ID of boot
> CPU" move it quite early in the sequence from setup_arch to
> smp_setup_processor_id while this patch just moves it up in setup_arch.

Thanks Sudeep, I'd guessed as much :)

Will
