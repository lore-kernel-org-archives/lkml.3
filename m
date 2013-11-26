Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab3KZKu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:50:57 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:60441 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab3KZKuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:50:54 -0500
Message-ID: <52947CCA.2010400@ti.com>
Date: Tue, 26 Nov 2013 12:49:46 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 06/12] mtd: nand: davinci: adjust DT properties to MTD
 generic
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>, <1384187188-5776-7-git-send-email-ivan.khoronzhuk@ti.com> <4F5844B3A985794BA902E12C070812375F8D20@DNCE04.ent.ti.com> <529447A7.1050605@ti.com> <52947832.3080309@ti.com>
In-Reply-To: <52947832.3080309@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 12:30 PM, Grygorii Strashko wrote:
> On 11/26/2013 09:03 AM, Sekhar Nori wrote:
>> On Monday 11 November 2013 10:31 PM, Khoronzhuk, Ivan wrote:
>>> The properties davinci-ecc-mode, davinci-nand-use-bbt, davinci-nand-buswidth
>>> are MTD generic. Correct names for them are: nand-ecc-mode, nand-on-flash-bbt,
>>> nand-bus-width accordingly. So rename them in dts and documentation.
>>>
>>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>>> ---
>>>    .../devicetree/bindings/mtd/davinci-nand.txt       |   25 ++++++++++++++++----
>>>    drivers/mtd/nand/davinci_nand.c                    |   11 ++++++---
>>>    2 files changed, 28 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/mtd/davinci-nand.txt b/Documentation/devicetree/bindings/mtd/davinci-nand.txt
>>> index d2a3fc0..befaa5b 100644
>>> --- a/Documentation/devicetree/bindings/mtd/davinci-nand.txt
>>> +++ b/Documentation/devicetree/bindings/mtd/davinci-nand.txt
>>> @@ -37,7 +37,7 @@ Recommended properties :
>>>    - ti,davinci-mask-chipsel:     mask for chipselect address. Needed to mask
>>>                                   addresses for given chipselect.
>>>
>>> -- ti,davinci-ecc-mode:         operation mode of the NAND ecc mode. ECC mode
>>> +- nand-ecc-mode:               operation mode of the NAND ecc mode. ECC mode
>>>                                   valid values for davinci driver:
>>>                                   - "none"
>>>                                   - "soft"
>>> @@ -45,10 +45,25 @@ Recommended properties :
>>>
>>>    - ti,davinci-ecc-bits:         used ECC bits, currently supported 1 or 4.
>>>
>>> -- ti,davinci-nand-buswidth:    buswidth 8 or 16.
>>
>> Shouldn't we keep the documentation for existing bindings while just
>> marking them as deprecated?
>
> I haven't found any requirements about this in doc.
> It's done in both way in other drivers - some keep properties in bindings
> documentation and some are not.
>
> Regards,
> -grygorii
>

For me this is not needed, but for example from mtd:
Documentation/devicetree/bindings/mtd/gpmc-nand.txt
,it contains deprecated properties, like a lot of others.

And this sad me I should remain deprecated properties.
Anyway if we have these properties in driver we should describe them.

-- 
Regards,
Ivan Khoronzhuk
