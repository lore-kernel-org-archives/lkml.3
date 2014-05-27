Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaE0LPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 07:15:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49715 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaE0LPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 07:15:09 -0400
Message-ID: <53847F39.2010503@ti.com>
Date: Tue, 27 May 2014 15:04:09 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: Alexandre Courbot <gnurou@gmail.com>,
        "Zhu, Lejun" <lejun.zhu@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <jacob.jun.pan@linux.intel.com>, <bin.yang@intel.com>
Subject: Re: [PATCH v4] gpio: Add support for Intel SoC PMIC (Crystal Cove)
References: <1400810423-14067-1-git-send-email-lejun.zhu@linux.intel.com> <CAAVeFu+F=nHDCpL6Vfmq26QNr74mfRD5p9at_osB3R97v7xBSA@mail.gmail.com> <538459E8.6010701@ti.com> <20140527084615.GC1801@lahna.fi.intel.com>
In-Reply-To: <20140527084615.GC1801@lahna.fi.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mika,

On 05/27/2014 11:46 AM, Mika Westerberg wrote:
> On Tue, May 27, 2014 at 12:24:56PM +0300, Grygorii Strashko wrote:
>>>> +
>>>> +       if (retval) {
>>>> +               dev_warn(&pdev->dev, "request irq failed: %d\n", retval);
>>>> +               goto out;
>>>> +       }
>>>> +
>>>> +       retval = gpiochip_add(&cg->chip);
>>>> +       if (retval) {
>>>> +               dev_warn(&pdev->dev, "add gpio chip error: %d\n", retval);
>>>> +               goto out_free_irq;
>>>> +       }
>>
>> As to my mind, It'll be better to setup IRQ as last probing step and
>> free it as the first step of driver removing.
> 
> When gpiochip_add() is called the chip is exported to outside world. At
> that point anyone can start requesting GPIOs and setup GPIO based
> interrupts. How does that work if you setup the IRQ after you call
> gpiochip_add()?
> 

It's difficult for me to imagine case when GPIO will be accessed
until GPIO driver's probe is finished.

Regarding remove()/suspend() routines, It's like an axiom for me:
- always disable irq
- always stop all works/threads created by driver
- do everything else
(It's proved by dozens hours of debugging).

Anyway, above is just my opinion :)
So, It's up to you, because it's your code :)

Also FYI, I did fast analysis of GPIO drivers - funny statistic below:
- 16 drivers setup IRQs BEFORE calling gpiochip_add();
- 22 drivers setup IRQs AFTER calling gpiochip_add();

Best regards,
-grygorii
