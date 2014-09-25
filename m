Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaIYH2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:28:17 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53276 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaIYH2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:28:14 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f156d0000063c7-0b-5423c40ba3ac
Content-transfer-encoding: 8BIT
Message-id: <1411630089.8568.7.camel@AMDC1943>
Subject: Re: [PATCH v7 1/5] PM / Runtime: Add getter for quering the IRQ safe
 option
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Thu, 25 Sep 2014 09:28:09 +0200
In-reply-to: <20140924175302.GB1231@amd>
References: <1411566612-32277-1-git-send-email-k.kozlowski@samsung.com>
 <1411566612-32277-2-git-send-email-k.kozlowski@samsung.com>
 <20140924175302.GB1231@amd>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t/xq7rcR5RDDJq3iFpsnLGe1WL61AuM
	Fqun/mW1OPBnB6PF2aY37BZLJs9ntZg1ZS+TxcK2JSwWl3fNYbP43HuE0eL2ZV6LtUfuslu8
	exlhcffUUTaLt3ems1icOX2J1WLC7wtsFsfXhlu87NvP4iDs0dLcw+axeYWWx+I9L5k87lzb
	w+ax5M0hVo8tV9tZPGbf/cHo0bdlFaPHitXf2T0+b5Lz2Pv5N0sAdxSXTUpqTmZZapG+XQJX
	xsHtPxgLNvBU3L24mamB8RtnFyMnh4SAicT9jqOMELaYxIV769m6GLk4hASWMkqcf9rCBpLg
	FRCU+DH5HksXIwcHs4C8xJFL2SBhZgF1iUnzFjGD2EICnxklbjdqQ5TrSbzfs44VxBYWCJM4
	0nQSbAybgLHE5uVLwGwRoDFb+1Ywg+xiFtjJKjFh6T8WkASLgKrE2c6brCC7OAU0JJq+REDc
	s5hR4nLXN7AbJASUJRr73SYwCsxCct0shOtmIbluASPzKkbR1NLkguKk9FxDveLE3OLSvHS9
	5PzcTYyQaPyyg3HxMatDjAIcjEo8vB7+yiFCrIllxZW5hxglOJiVRHi3bQUK8aYkVlalFuXH
	F5XmpBYfYmTi4JRqYFx4zIGPRf7P4x8KPbHyWZ/+3z/KxPDnDOfiHOnv92J273crf/jG9csL
	hdgzvCmbdn1fXx7tpi54mjVYc1ve15VBJy6Lux/U1Pliu8c343LpdAeTS+H/43/pspxdeVFq
	4+xf6ofq/NxWhKavPhMa9PKr2yK2YlV/kVWpfqknJvtt2X8gXLK444ISS3FGoqEWc1FxIgDO
	/LlRpAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-09-24 at 19:53 +0200, Pavel Machek wrote:
> On Wed 2014-09-24 15:50:08, Krzysztof Kozlowski wrote:
> > Add a simple getter pm_runtime_is_irq_safe() for quering whether runtime
> > PM IRQ safe was set or not.
> > 
> > Various bus drivers implementing runtime PM may use choose to suspend
> > differently based on IRQ safeness status of child driver (e.g. do not
> > unprepare the clock if IRQ safe is not set).
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
> 
> Are you sure this is good interface?
> 
> "Tell me if another function works this or that way".
> 
> That's certainly not traditional interface, and it seems dangerous to
> me. Callbacks now have different semantic requirements based on value
> of some flag...

Yes... but to me that semantic change looks similar to the PM runtime
code which behaves differently when the flag is set. Some PM runtime
functions might sleep or might not... depending on the flag.

> Would it be possible to have two sets of callbacks, one irq safe and
> one not?

That would require changing the callbacks during probe of each driver.
It is possible - I'm fine with that. However we still would need some
kind of interface for selecting the callbacks according to irq safe
status - something like pm_runtime_is_irq_safe():

static int amba_probe(struct device *dev)
{
...
	if (pm_runtime_is_irq_safe())
		dev->driver->pm = &amba_pm_irq_safe;
	else
		dev->driver->pm = &amba_pm;

Best regards,
Krzysztof


