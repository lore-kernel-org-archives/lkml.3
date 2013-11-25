Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab3KYKfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:35:45 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58005 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab3KYKfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:35:42 -0500
Message-ID: <529327A8.8080909@ti.com>
Date: Mon, 25 Nov 2013 16:04:16 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LDOC <linux-doc@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v6 1/6] gpio: davinci: use readl/writel instead of __raw_*
References: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com> <1385057731-4348-2-git-send-email-prabhakar.csengg@gmail.com> <CAArO44vmfkroE9w4KviOhjkPvg9bTX9pAtr3oxYjD9u_wVZXeg@mail.gmail.com> <CA+V-a8sjmo2K16m9_6Zf1qwcez+qKm-9JW1Cb=Aj4prtXd=-fA@mail.gmail.com>
In-Reply-To: <CA+V-a8sjmo2K16m9_6Zf1qwcez+qKm-9JW1Cb=Aj4prtXd=-fA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prabhakar,

On Monday 25 November 2013 09:42 AM, Prabhakar Lad wrote:
> Hi Taras,
> 
> On Fri, Nov 22, 2013 at 3:38 PM, Taras Kondratiuk
> <taras.kondratiuk@linaro.org> wrote:
>> On 21 November 2013 20:15, Prabhakar Lad <prabhakar.csengg@gmail.com> wrote:
>>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>>
>>> This patch replaces the __raw_readl/writel with
>>> readl and writel, Altough the code runs on ARMv5
>>> based SOCs, changing this will help copying the code
>>> for other uses.
>>
>> This replacement has a functional impact: it adds memory barriers.
>> Please note this in the description.
>> Also please add a bit of explanation on why do you need to add barriers.
>>
> Agreed this adds memory barriers, I'll add a note about it.

Well the barriers certainly make it easier to debug by having both
device and memory accesses happen in program order. That said, if there
is no pressing reason to add barriers, you can use
{readl|writel}_relaxed() instead. That will make the code protable
across endianess.

Thanks,
Sekhar
