Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166AbaFEEMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:12:03 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:47374 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaFEEL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:11:59 -0400
Message-ID: <538FEDE9.4010603@linaro.org>
Date: Thu, 05 Jun 2014 12:11:21 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Zheng, Lv" <lv.zheng@intel.com>, Lee Jones <lee.jones@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>
Subject: Re: [PATCH 1/7] ACPICA: Only include ACPI asm files if ACPI is enabled
References: <1401883796-17841-1-git-send-email-lee.jones@linaro.org> <1401883796-17841-2-git-send-email-lee.jones@linaro.org> <3061297.feg5DGUjIt@vostro.rjw.lan> <20140604125137.GA18171@lee--X1> <1AE640813FDE7649BE1B193DEA596E880262042C@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E880262042C@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-6-5 9:14, Zheng, Lv wrote:
> Hi, Lee
> 
>> From: Lee Jones [mailto:lee.jones@linaro.org]
>> Sent: Wednesday, June 04, 2014 8:52 PM
>> To: Rafael J. Wysocki
>>
>> On Wed, 04 Jun 2014, Rafael J. Wysocki wrote:
>>
>>> On Wednesday, June 04, 2014 01:09:50 PM Lee Jones wrote:
>>>> Any drivers which support ACPI and Device Tree probing need to include
>>>> both respective header files.  Without this patch, if a driver is being
>>>> used on a platform which does not support ACPI and subsequently does not
>>>> have the config option enabled, but includes linux/acpi.h the build
>>>> breaks with:
>>>>
>>>>   In file included from ../include/acpi/platform/acenv.h:150:0,
>>>>                    from ../include/acpi/acpi.h:56,
>>>>                    from ../include/linux/match.h:2,
>>>>                    from ../drivers/i2c/i2c-core.c:43:
>>>>   ../include/acpi/platform/aclinux.h:73:23:
>>>>    fatal error: asm/acenv.h: No such file or directory
>>>>    #include <asm/acenv.h>
>>>>                        ^
> 
> Note that:
> In our tree:
> <asm/acenv.h> is only included by <acpi/acpi.h>.
> And <acpi/acpi.h> is only included by
> 1. <linux/acpi.h> when CONFIG_ACPI enabled
> 2. <linux/sfi_acpi.h> - this is x86 specific, we'll clean it up by implementing stubs for all ACPI external interfaces.
> So there is no case we need to exclude <asm/acenv.h> when CONFIG_ACPI is not enabled.
> 
> I cannot find linux/match.h here.
> If <linux/match.h> want to include ACPI features, it shouldn't include <acpi/acpi.h>, but should include <linux/acpi.h>.
> Please refer to:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=8b48463f
> And stop including <acpi/acpi.h> directly in any cases.

Ah, I agree, please ignore my previous email,
sorry for the noise.

Since it is very important to include <linux/acpi.h> but not <acpi/acpi.h>,
can we document it somewhere as the guidance? Then people will not
make such mistake :)

Thanks
Hanjun

