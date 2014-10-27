Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaJ0LrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:47:11 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45686 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaJ0LrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:47:09 -0400
Message-ID: <544E30B6.7060902@arm.com>
Date: Mon, 27 Oct 2014 11:47:02 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Abhijeet Dharmapurikar <adharmap@codeaurora.org>, Phong Vo <pvo@apm.com>,
        Linus Walleij <linus.walleij@linaro.org>, Tin Huynh <tnhuynh@apm.com>,
        Y Vo <yvo@apm.com>, Toan Le <toanle@apm.com>,
        Bjorn Andersson <bjorn@kryo.se>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] genirq: Allow the irqchip state of an IRQ to be save/restored
References: <1414232097-4328-1-git-send-email-marc.zyngier@arm.com> <1414232097-4328-2-git-send-email-marc.zyngier@arm.com> <alpine.DEB.2.11.1410252131110.5308@nanos> <alpine.DEB.2.11.1410252136220.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410252136220.5308@nanos>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 27 Oct 2014 11:47:04.0099 (UTC) FILETIME=[BA31C730:01CFF1DB]
X-MC-Unique: 114102711470600201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/10/14 20:42, Thomas Gleixner wrote:
> On Sat, 25 Oct 2014, Thomas Gleixner wrote:
> 
> Bah, hit send way too fast :)
> 
>> On Sat, 25 Oct 2014, Marc Zyngier wrote:
>>> +int irq_get_irqchip_state(unsigned int irq, int state)
> 
> get_state(state) does not make sense. get_state(which) probably more
> so. And 'which' wants to be an enum btw.
> 
>>> +	chip_bus_lock(desc);
>>> +	val = chip->irq_get_irqchip_state(data, state);
>>
>> Hmm. What's the irq_get_irqchip_state() callback supposed to return?
> 
> Either an error code or a boolean value, right? Does not mix very well
> I think. 
> 
> int irq_get_irqchip_state(unsigned int irq, enum xxx which, bool *val)
> 
> Might be a more clear interface.

Agreed, this makes a lot of sense. Will respin it.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

