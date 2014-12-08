Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaLHBeX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 20:34:23 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:17726 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaLHBeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 20:34:20 -0500
X-IronPort-AV: E=Sophos;i="5.07,535,1413270000"; 
   d="scan'208";a="52484694"
Message-ID: <5485001A.7050909@broadcom.com>
Date: Sun, 7 Dec 2014 17:34:18 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-gpio@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/5] gpio: Cygnus: add GPIO driver
References: <Ray Jui <rjui@broadcom.com>	 <1417826408-1600-1-git-send-email-rjui@broadcom.com>	 <1417826408-1600-3-git-send-email-rjui@broadcom.com>	 <1417829282.31745.3.camel@perches.com> <5482668F.1040907@broadcom.com>	 <1417833291.31745.5.camel@perches.com> <54827B07.3000707@broadcom.com> <1417839865.31745.10.camel@perches.com>
In-Reply-To: <1417839865.31745.10.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/5/2014 8:24 PM, Joe Perches wrote:
> On Fri, 2014-12-05 at 19:41 -0800, Ray Jui wrote:
>> On 12/5/2014 6:34 PM, Joe Perches wrote:
>>> On Fri, 2014-12-05 at 18:14 -0800, Ray Jui wrote:
>>>> On 12/5/2014 5:28 PM, Joe Perches wrote:
>>>>> On Fri, 2014-12-05 at 16:40 -0800, Ray Jui wrote:
>>>>>> +			for_each_set_bit(bit, &val, 32) {
> []
>> Actually, by reviewing the code more deeply, I'm not sure why using
>> for_each_set_bit here is 'endian unsafe'.
>
> It's not.  The 32 confused me as it was long
> and sizeof(long) isn't necessarily 32.
>
> Maybe the 32 should be a #define
>
>
>
Okay, to improve readability, I will change 32 to NGPIOS_PER_BANK.
