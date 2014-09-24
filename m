Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaIXLTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:19:51 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:51950 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaIXLTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:19:49 -0400
Message-ID: <5422A8D1.1000507@gmail.com>
Date: Wed, 24 Sep 2014 13:19:45 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "lauraa@codeaurora.org" <lauraa@codeaurora.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "drake@endlessm.com" <drake@endlessm.com>,
        "loeliger@gmail.com" <loeliger@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v5 4/7] ARM: l2c: Add support for overriding prefetch
 settings
References: <1411556741-5810-1-git-send-email-m.szyprowski@samsung.com> <1411556741-5810-5-git-send-email-m.szyprowski@samsung.com> <20140924111446.GE5729@leverpostej>
In-Reply-To: <20140924111446.GE5729@leverpostej>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.09.2014 13:14, Mark Rutland wrote:
> On Wed, Sep 24, 2014 at 12:05:38PM +0100, Marek Szyprowski wrote:
>> From: Tomasz Figa <t.figa@samsung.com>
>>
>> Firmware on certain boards (e.g. ODROID-U3) can leave incorrect L2C prefetch
>> settings configured in registers leading to crashes if L2C is enabled
>> without overriding them. This patch introduces bindings to enable
>> prefetch settings to be specified from DT and necessary support in the
>> driver.
>>
>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>>  Documentation/devicetree/bindings/arm/l2cc.txt | 10 +++++++
>>  arch/arm/mm/cache-l2x0.c                       | 39 ++++++++++++++++++++++++++
>>  2 files changed, 49 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt b/Documentation/devicetree/bindings/arm/l2cc.txt
>> index af527ee111c2..3443d2d76788 100644
>> --- a/Documentation/devicetree/bindings/arm/l2cc.txt
>> +++ b/Documentation/devicetree/bindings/arm/l2cc.txt
>> @@ -47,6 +47,16 @@ Optional properties:
>>  - cache-id-part: cache id part number to be used if it is not present
>>    on hardware
>>  - wt-override: If present then L2 is forced to Write through mode
>> +- arm,double-linefill : Override double linefill enable setting. Enable if
>> +  non-zero, disable if zero.
>> +- arm,double-linefill-incr : Override double linefill on INCR read. Enable
>> +  if non-zero, disable if zero.
>> +- arm,double-linefill-wrap : Override double linefill on WRAP read. Enable
>> +  if non-zero, disable if zero.
>> +- arm,prefetch-drop : Override prefetch drop enable setting. Enable if non-zero,
>> +  disable if zero.
> 
> I'm not too keen on tristate properties. Is this level of flexibility
> really required?
> 
> What exact overrides do you need for boards you know of? Why do these
> cause crashes if not overridden?

Well, this is all thanks to broken firmware, which doesn't initialize
those values properly on certain systems and they must be overridden. On
the other side, there are systems with firmware that does it correctly
and for those the boot defaults should be preferred. I don't see any
other reasonable option of handling this.

As for why they cause crashes, I'm not an expert if it is about L2C
internals, so I can't really tell, but apparently the cache can work
correctly only on certain settings.

Best regards,
Tomasz
