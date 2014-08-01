Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbaHAUo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 16:44:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60273 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbaHAUo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 16:44:56 -0400
Message-ID: <53DBFC42.6030205@suse.de>
Date: Fri, 01 Aug 2014 22:44:50 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <t.figa@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 03/10] ARM: dts: Clean up exynos5250-snow
References: <1406868897-26874-1-git-send-email-afaerber@suse.de>	<1406868897-26874-4-git-send-email-afaerber@suse.de> <CAD=FV=W2XJzv4NpB=27AFjX94VkH8dYXxAPBL58ntXL2WvRCoQ@mail.gmail.com>
In-Reply-To: <CAD=FV=W2XJzv4NpB=27AFjX94VkH8dYXxAPBL58ntXL2WvRCoQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 01.08.2014 22:24, schrieb Doug Anderson:
> Andreas,
> 
> On Thu, Jul 31, 2014 at 9:54 PM, Andreas Färber <afaerber@suse.de> wrote:
>> Use the new style of referencing inherited nodes and use symbolic names.
>> Reorder one pinctrl node in GPIO order.
>>
>> Goal is the alignment of all exynos5250 based device trees for comparison.
>>
>> Suggested-by: Doug Anderson <dianders@chromium.org>
>> Signed-off-by: Andreas Färber <afaerber@suse.de>
>> ---
>>  v4 -> v5:
>>  * Introduced labels to consistently use new referencing style (Tomasz)
>>  * Use IRQ_TYPE_* constants
>>  * Use some more GPIO_ACTIVE_*
>>
>>  v3 -> v4: Unchanged
>>
>>  v3: New (Doug Anderson)
>>
>>  arch/arm/boot/dts/exynos5250-snow.dts | 291 +++++++++++++++++-----------------
>>  arch/arm/boot/dts/exynos5250.dtsi     |  20 +--
> 
> As much as possible it's nice to touch the main exynos dtsi file and
> specific board files in different patches.  Among other things it
> makes backporting the patch and resolving merge conflicts easier (if
> someone doesn't care about snow they could just pick up the main dtsi,
> for instance).
> 
> I'm not a total stickler and I'd love to see this land quickly to
> avoid conflicts, though...
> 
> 
>> +&sd3_clk {
>> +       samsung,pin-drv = <0>;
>> +};
>> +
>> +&sd3_cmd {
>> +       samsung,pin-pud = <3>;
>> +       samsung,pin-drv = <0>;
>> +};
>> +
>> +&sd3_bus4 {
> 
> Itty bitty bitty nit that "bus" sorts alphabetically above "clk".  ;)

True. I guess I just reused the original order from within pinctrl.

> Maybe Kukjin would be willing to sort these when he applies?
>
>
> Thank you for all your hard work on this one.  Things look MUCH MUCH
> nicer!  I did a pretty thorough review of your changes and it all
> looks good.
> 
> Reviewed-by: Doug Anderson <dianders@chromium.org>

I need to respin anyway for a .dtsi label, so I can factor this out
while at it.

Patches 1-2 could meanwhile already be applied by Kukjin.

Thanks,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
