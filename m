Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaE0GPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 02:15:25 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:39006 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaE0GPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 02:15:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAAVeFu+F=nHDCpL6Vfmq26QNr74mfRD5p9at_osB3R97v7xBSA@mail.gmail.com>
References: <1400810423-14067-1-git-send-email-lejun.zhu@linux.intel.com> <CAAVeFu+F=nHDCpL6Vfmq26QNr74mfRD5p9at_osB3R97v7xBSA@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 27 May 2014 15:15:01 +0900
Message-ID: <CAAVeFu+mpRWLS8Nwn-sCw5YAUCup7-fzZ=x=tM86DVcTq-TcGQ@mail.gmail.com>
Subject: Re: [PATCH v4] gpio: Add support for Intel SoC PMIC (Crystal Cove)
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 2:38 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
>> +       gpiochip_irqchip_add(&cg->chip, &crystalcove_irqchip, 0,
>> +                            handle_simple_irq, IRQ_TYPE_NONE);
>> +
>> +       retval = request_threaded_irq(irq, NULL, crystalcove_gpio_irq_handler,
>> +                                     IRQF_ONESHOT, KBUILD_MODNAME, cg);
>
> Can't you use devm_request_threaded_irq() here?

Ah, I suppose doing so would keep the IRQ handler active longer than
we want - please ignore this comment.
