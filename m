Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab3JJOfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 10:35:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42497 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214Ab3JJOft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 10:35:49 -0400
Message-ID: <5256BB27.6010107@ti.com>
Date: Thu, 10 Oct 2013 17:35:19 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Tony Lindgren <tony@atomide.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Prakash Manjunathappa <prakash.pm@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 4/6] pinctrl: single: Add support for wake-up interrupts
References: <20131003054104.8941.88857.stgit@localhost> <20131003054221.8941.87801.stgit@localhost> <5256AA7F.8030005@ti.com> <CACRpkdZx5+OCcQytkpjd7_nz4hw6VXoXOS0LByKgJ8_cQjbA4g@mail.gmail.com>
In-Reply-To: <CACRpkdZx5+OCcQytkpjd7_nz4hw6VXoXOS0LByKgJ8_cQjbA4g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 05:04 PM, Linus Walleij wrote:
> On Thu, Oct 10, 2013 at 3:24 PM, Roger Quadros <rogerq@ti.com> wrote:
> 
>> I think pcs_irq_set_wake() is where need to control system wakeup behaviour for the irq.
>> This is where we should be able to change WAKEUP_EN bit of the pad
>> to enable/disable system wakeup for that pad and also call _reconfigure_io_chain().
> 
> As an innocent bystander who has no clue what the _reconfigure_io_chain()
> is about can you tell me what this is all about?

The OMAP SoC has a mechanism to monitor and wakeup from a low power state by creating
an IO ring of all the pads. But there is one bit in one of the control registers that
needs to be toggled each time the pad configuration is changed to re-arm the IO ring.
This is exactly what _reconfigure_io_chain() does.
> 
> Is this another one of the OMAP forked paths where you must call back into
> the machine with a special callback from each and every driver?

_reconfigure_io_chain() is not available for public use and is not called by any driver yet.
However, it somehow needs to be called from this pinctrl-single driver each time the
wakeup configuration for any pad is changed.

cheers,
-roger
