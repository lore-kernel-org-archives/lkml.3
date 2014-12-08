Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbaLHRBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:01:55 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:24106 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbaLHRBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:01:53 -0500
X-IronPort-AV: E=Sophos;i="5.07,539,1413270000"; 
   d="scan'208";a="52373059"
Message-ID: <5485D97D.1040404@broadcom.com>
Date: Mon, 8 Dec 2014 18:01:49 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "Hante Meuleman" <meuleman@broadcom.com>,
        "hauke@hauke-m.de" <hauke@hauke-m.de>,
        David Miller <davem@davemloft.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: using DMA-API on ARM
References: <5481794E.4050406@broadcom.com> <F51492713EF10846800D8C0ED37A7DCE01901765@SJEXCHMB15.corp.ad.broadcom.com> <F51492713EF10846800D8C0ED37A7DCE01902076@SJEXCHMB15.corp.ad.broadcom.com> <2863746.4sUSEYqahB@wuerfel> <20141208160316.GM16185@e104818-lin.cambridge.arm.com>
In-Reply-To: <20141208160316.GM16185@e104818-lin.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/14 17:03, Catalin Marinas wrote:
> On Mon, Dec 08, 2014 at 03:01:32PM +0000, Arnd Bergmann wrote:
>> [    0.000000] PL310 OF: cache setting yield illegal associativity
>> [    0.000000] PL310 OF: -1069781724 calculated, only 8 and 16 legal
>> [    0.000000] L2C-310 enabling early BRESP for Cortex-A9
>> [    0.000000] L2C-310 full line of zeros enabled for Cortex-A9
>> [    0.000000] L2C-310 dynamic clock gating enabled, standby mode enabled
>> [    0.000000] L2C-310 cache controller enabled, 16 ways, 256 kB
>> [    0.000000] L2C-310: CACHE_ID 0x410000c8, AUX_CTRL 0x4e130001
>
> If the above value is correct, they should make sure bit 22 is set in
> AUX_CTRL.

Hante applied the patch and it now says:

[    0.000000] PL310 OF: cache setting yield illegal associativity
[    0.000000] PL310 OF: -1069781724 calculated, only 8 and 16 legal
[    0.000000] L2C-310 enabling early BRESP for Cortex-A9
[    0.000000] L2C-310 full line of zeros enabled for Cortex-A9
[    0.000000] L2C-310 dynamic clock gating enabled, standby mode enabled
[    0.000000] L2C-310 cache controller enabled, 16 ways, 256 kB
[    0.000000] L2C-310: CACHE_ID 0x410000c8, AUX_CTRL 0x4e530001

He started running a test overnight. So will see if it hits the failure 
with this L2 cache configuration.

Regards,
Arend
