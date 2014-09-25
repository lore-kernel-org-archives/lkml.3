Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaIYH54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:57:56 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:53491 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaIYH5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:57:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140924195222.GB5182@n2100.arm.linux.org.uk>
References: <20140924175302.GB1231@amd>
	<Pine.LNX.4.44L0.1409241544070.1580-100000@iolanthe.rowland.org>
	<20140924195222.GB5182@n2100.arm.linux.org.uk>
Date: Thu, 25 Sep 2014 09:57:52 +0200
Message-ID: <CAPDyKFqcpTjxVB0VsWPNaAbJ-1HNzmKuCesmr8x=HY1_5mQXTg@mail.gmail.com>
Subject: Re: [PATCH v7 1/5] PM / Runtime: Add getter for quering the IRQ safe option
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 September 2014 21:52, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Sep 24, 2014 at 03:47:17PM -0400, Alan Stern wrote:
>> On Wed, 24 Sep 2014, Pavel Machek wrote:
>>
>> > On Wed 2014-09-24 15:50:08, Krzysztof Kozlowski wrote:
>> > > Add a simple getter pm_runtime_is_irq_safe() for quering whether runtime
>> > > PM IRQ safe was set or not.
>> > >
>> > > Various bus drivers implementing runtime PM may use choose to suspend
>> > > differently based on IRQ safeness status of child driver (e.g. do not
>> > > unprepare the clock if IRQ safe is not set).
>> > >
>> > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> > > Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
>> >
>> > Are you sure this is good interface?
>> >
>> > "Tell me if another function works this or that way".
>> >
>> > That's certainly not traditional interface, and it seems dangerous to
>> > me. Callbacks now have different semantic requirements based on value
>> > of some flag...
>> >
>> > Would it be possible to have two sets of callbacks, one irq safe and
>> > one not?
>>
>> Or maybe add a flag to the bus-specific device structures, indicating
>> specifically whether or not the clock should be unprepared during a
>> runtime suspend.  Then individual drivers could set this flag or not,
>> independent of the irq-safe setting.
>
> What you're proposing is _less_ safe, because with your proposal, you
> now have the possibility that drivers will tell runtime PM that it has
> IRQ safe callbacks, but the bus code tries to prepare/unprepare the
> clock, which causes a might-sleep-if warning.
>
> This is fragile.

I agree.

I would also like to feed another argument into this discussion on why
I like the new API. Currently the generic power domain accesses
"dev->power.irq_safe" directly.

Kind regards
Uffe
