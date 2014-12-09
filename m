Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbaLIKTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:19:52 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:22186 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbaLIKTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:19:50 -0500
X-IronPort-AV: E=Sophos;i="5.07,543,1413270000"; 
   d="scan'208";a="52591682"
Message-ID: <5486CCBC.3@broadcom.com>
Date: Tue, 9 Dec 2014 11:19:40 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "Hante Meuleman" <meuleman@broadcom.com>,
        "hauke@hauke-m.de" <hauke@hauke-m.de>,
        David Miller <davem@davemloft.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: using DMA-API on ARM
References: <5481794E.4050406@broadcom.com> <F51492713EF10846800D8C0ED37A7DCE01901765@SJEXCHMB15.corp.ad.broadcom.com> <F51492713EF10846800D8C0ED37A7DCE01902076@SJEXCHMB15.corp.ad.broadcom.com> <2863746.4sUSEYqahB@wuerfel> <20141208160316.GM16185@e104818-lin.cambridge.arm.com> <5485D97D.1040404@broadcom.com>
In-Reply-To: <5485D97D.1040404@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/14 18:01, Arend van Spriel wrote:
> On 12/08/14 17:03, Catalin Marinas wrote:
>> On Mon, Dec 08, 2014 at 03:01:32PM +0000, Arnd Bergmann wrote:
>>> [ 0.000000] PL310 OF: cache setting yield illegal associativity
>>> [ 0.000000] PL310 OF: -1069781724 calculated, only 8 and 16 legal
>>> [ 0.000000] L2C-310 enabling early BRESP for Cortex-A9
>>> [ 0.000000] L2C-310 full line of zeros enabled for Cortex-A9
>>> [ 0.000000] L2C-310 dynamic clock gating enabled, standby mode enabled
>>> [ 0.000000] L2C-310 cache controller enabled, 16 ways, 256 kB
>>> [ 0.000000] L2C-310: CACHE_ID 0x410000c8, AUX_CTRL 0x4e130001
>>
>> If the above value is correct, they should make sure bit 22 is set in
>> AUX_CTRL.
>
> Hante applied the patch and it now says:
>
> [ 0.000000] PL310 OF: cache setting yield illegal associativity
> [ 0.000000] PL310 OF: -1069781724 calculated, only 8 and 16 legal
> [ 0.000000] L2C-310 enabling early BRESP for Cortex-A9
> [ 0.000000] L2C-310 full line of zeros enabled for Cortex-A9
> [ 0.000000] L2C-310 dynamic clock gating enabled, standby mode enabled
> [ 0.000000] L2C-310 cache controller enabled, 16 ways, 256 kB
> [ 0.000000] L2C-310: CACHE_ID 0x410000c8, AUX_CTRL 0x4e530001
>
> He started running a test overnight. So will see if it hits the failure
> with this L2 cache configuration.

The issue did not trigger overnight so it seems setting bit 22 <Shared 
Attribute _Override_ Enable> solves the issue over here. Now the 
question is how to move forward with this. As I understood from Catalin 
this patch was not included as it was not considered responsibility of 
the linux kernel.

Regards,
Arend
