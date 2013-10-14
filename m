Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab3JNSkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:40:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51984 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab3JNSka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:40:30 -0400
Message-ID: <525C3A9A.5000207@wwwdotorg.org>
Date: Mon, 14 Oct 2013 12:40:26 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Rhyland Klein <rklein@nvidia.com>
CC: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Darbha Sriharsha <dsriharsha@nvidia.com>,
        Manish Badarkha <badarkhe.manish@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [Patch V5] drivers: power: Add support for bq24735 charger
References: <1381526143-20800-1-git-send-email-rklein@nvidia.com> <525C361C.1020703@wwwdotorg.org> <525C376A.3000009@nvidia.com>
In-Reply-To: <525C376A.3000009@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 12:26 PM, Rhyland Klein wrote:
> On 10/14/2013 2:21 PM, Stephen Warren wrote:
>> On 10/11/2013 03:15 PM, Rhyland Klein wrote:
>>> From: Darbha Sriharsha <dsriharsha@nvidia.com>
>>>
>>> Adds support for the bq24735 charger chipset. The bq24735 is a
>>> high-efficiency, synchronous battery charger.
>>>
>>> It allows control of the charging current, input current, and the charger
>>> voltage DAC's through SMBus.
>>
>> Please CC the DT bindings maintainers on patches that add DT bindings.
> 
> Oops, sorry, will do in the future.
> 
>>
>>> diff --git a/Documentation/devicetree/bindings/power_supply/ti,bq24735.txt b/Documentation/devicetree/bindings/power_supply/ti,bq24735.txt
>>
>>> +Optional properties :
>>
>>> + - ti,ac-detect-gpios : This GPIO is optionally used to read the AC adapter
>>> +   presence.
>>
>> Is that actually a property of the BQ24735 chip itself (i.e. is it an
>> output signal from the chip), or part of the board/system?
> 
> The gpio itself is actually what the IRQ line is tied to from the
> bq24735 -> tegra (in this case). In other words this is a Host GPIO that
> is configured as an input and connected to the bq24735.

Ok, so this is the ACOK output pin? In that case, it's fine. It might be
worth mentioning that explicitly though.
