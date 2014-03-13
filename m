Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbaCMQUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:20:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbaCMQUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:20:43 -0400
Message-ID: <5321DACD.6010303@redhat.com>
Date: Thu, 13 Mar 2014 17:20:29 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Carlo Caione <carlo.caione@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] irq: Add a new IRQF_ACK_BEFORE_UNMASK irq flagq
References: <1394579583-29316-1-git-send-email-hdegoede@redhat.com> <alpine.DEB.2.02.1403120944270.18573@ionos.tec.linutronix.de> <20140313133707.GA24821@linutronix.de> <alpine.DEB.2.02.1403131442480.18573@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1403131442480.18573@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/13/2014 03:32 PM, Thomas Gleixner wrote:
> On Thu, 13 Mar 2014, Sebastian Andrzej Siewior wrote:
>> One side note: Since we need to specify IRQCHIP_EOI_THREADED and
>> handle_fasteoi_late_irq() as the handler, would it be easily doable to use
>> the handle_fasteoi_irq() handler and skip the EOI in the threaded mode?
>> But if it creates a mess then leave it as it is.
> 
> Yeah, I was looking into that already. Patch below.
> 
> To resemble the late version you need to add IRQCHIP_EOI_THREADED and
> IRQCHIP_EOI_IF_HANDLED to your irq chip.

Just gave this a review (in as far as I'm qualified to review core irq
code), looks good and I agree this is an improvement over the previous
version.

There is one behavioral change for irq-chips not setting the new
IRQCHIP_EOI_THREADED flag hiding in there.

Before if the conditional unmask conditions were true for the
ONESHOT case the code would do: "unmask; eoi", now it does
"eoi; unmask" I believe the new behavior is more correct, but, since
it is a behavior change I thought I should point this out.

I've also given this a test-run on sun4i and it works as advertised.

FWIW, this patch is:
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Hans de Goede <hdegoede@redhat.com>

I'll include this in v3 of my irq-sun4i patch-set as it is a dependency
there.

Regards,

Hans
