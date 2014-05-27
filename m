Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbaE0GWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 02:22:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:35814 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbaE0GWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 02:22:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,917,1392192000"; 
   d="scan'208";a="518145012"
Message-ID: <53842F0A.604@linux.intel.com>
Date: Tue, 27 May 2014 14:22:02 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH v4] gpio: Add support for Intel SoC PMIC (Crystal Cove)
References: <1400810423-14067-1-git-send-email-lejun.zhu@linux.intel.com> <CAAVeFu+F=nHDCpL6Vfmq26QNr74mfRD5p9at_osB3R97v7xBSA@mail.gmail.com>
In-Reply-To: <CAAVeFu+F=nHDCpL6Vfmq26QNr74mfRD5p9at_osB3R97v7xBSA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/27/2014 1:38 PM, Alexandre Courbot wrote:
> On Fri, May 23, 2014 at 11:00 AM, Zhu, Lejun <lejun.zhu@linux.intel.com> wrote:
>> +static void crystalcove_update_irq_type(int gpio, int type)
>> +{
>> +       u8 ctli = GPIO_TO_CTL(gpio, I);
>> +
>> +       type &= IRQ_TYPE_EDGE_BOTH;
>> +       intel_soc_pmic_clearb(ctli, CTLI_INTCNT_BE);
>> +
>> +       if (type == IRQ_TYPE_EDGE_BOTH)
>> +               intel_soc_pmic_setb(ctli, CTLI_INTCNT_BE);
>> +       else if (type == IRQ_TYPE_EDGE_RISING)
>> +               intel_soc_pmic_setb(ctli, CTLI_INTCNT_PE);
>> +       else if (type & IRQ_TYPE_EDGE_FALLING)
>> +               intel_soc_pmic_setb(ctli, CTLI_INTCNT_NE);
> 
> Maybe a switch would be nicer here to choose the right value? And a
> single call to intel_soc_pmic_setb() after the value is picked.

Thank you. I will fix this in the next version.

Best Regards
Lejun

