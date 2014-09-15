Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbaIOHHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 03:07:50 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:49789 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaIOHHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 03:07:48 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f776d000003e54-37-54169041d797
Content-transfer-encoding: 8BIT
Message-id: <1410764863.4690.3.camel@AMDC1943>
Subject: Re: [RFC PATCH v2 1/2] amba: Allow AMBA drivers to use their own
 runtime PM
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Mon, 15 Sep 2014 09:07:43 +0200
In-reply-to: <20140912151352.GK12361@n2100.arm.linux.org.uk>
References: <1410533779-3310-1-git-send-email-k.kozlowski@samsung.com>
 <1410533779-3310-2-git-send-email-k.kozlowski@samsung.com>
 <20140912151352.GK12361@n2100.arm.linux.org.uk>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/xq7qOE8RCDI7c4bDYOGM9q8X0qRcY
	LVZP/ctqceDPDkaLs01v2C2WTJ7PanF51xw2i9uXeS3WHrnLbvHuZYTF8bXhFi/79rM48Hi0
	NPeweSze85LJ4861PWweS94cYvXo27KK0ePzJjmPvZ9/swSwR3HZpKTmZJalFunbJXBlbHzy
	jK1gEWdF+7cLTA2M+9i7GDk5JARMJO51HmGCsMUkLtxbz9bFyMUhJLCUUWJj+1mwIl4BQYkf
	k++xdDFycDALyEscuZQNEmYWUJeYNG8RM0T9Z0aJf23HWSHq9STmfFjKCGILC4RJ/J68CCzO
	JmAssXn5EjYQW0TAVOLao2dgzcwCe5klVi3oBEuwCKhKvOyZywxicwrYSPxqms0KsWEro8S8
	hj6wKyQElCUa+90mMArMQnLfLIT7ZiG5bwEj8ypG0dTS5ILipPRcI73ixNzi0rx0veT83E2M
	kCj5uoNx6TGrQ4wCHIxKPLwXvgiHCLEmlhVX5h5ilOBgVhLhDXQXCxHiTUmsrEotyo8vKs1J
	LT7EyMTBKdXAaPDmd1PVhze6Rd/fna60Z38gv/qj2+6uKyZ2fpx3jtXIaV/+lHVnypulFZsd
	lvJ08O4J6c281hV6Jf9S8OoWlU2zW+suPwh0zP9wSK3EJklgk/SvwkmnmrqYP7nNabh8OaBl
	SYOj9NMXSz7fDDr9Yp6Nn5mnopvpubnqd+b8vBDn5v2/uv76DCWW4oxEQy3mouJEANS10w9w	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-09-12 at 16:13 +0100, Russell King - ARM Linux wrote:
> On Fri, Sep 12, 2014 at 04:56:18PM +0200, Krzysztof Kozlowski wrote:
> > The AMBA bus driver defines runtime Power Management functions which
> > disable and unprepare AMBA bus clock. This is problematic for runtime PM
> > because unpreparing a clock might sleep so it is not interrupt safe.
> > 
> > However some drivers may want to implement runtime PM functions in
> > interrupt-safe way (see pm_runtime_irq_safe()). If such driver
> > implements its own runtime PM functions then assume it will handle the
> > runtime PM completely and it will replace our clock handling.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> Actually, I'd rather just revert 5303c0f46c8708fff4148ebcc491f78710356952
> which is clearly the wrong thing to do when we have non-IRQ safe runtime
> PM.
> 
> What we /could/ do instead is to check whether irq_safe is set after
> probe, record that, and then select whether to use the prepare/unprepare
> methods based on that.  (Drivers should never dynamically change this.)

I'll try this approach.

Thank you for feedback,
Krzysztof

