Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbaD1Lyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 07:54:47 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:45323 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbaD1Lyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:54:44 -0400
MIME-Version: 1.0
X-Originating-IP: [60.245.65.194]
In-Reply-To: <alpine.DEB.2.02.1404281207510.6261@ionos.tec.linutronix.de>
References: <1398656117.19333.1.camel@phoenix>
	<alpine.DEB.2.02.1404281207510.6261@ionos.tec.linutronix.de>
Date: Mon, 28 Apr 2014 19:54:43 +0800
Message-ID: <CAFRkauASQa5xgm49p5tyBQ0oj29Zxt0x90E0qZoAjMVhsp6gDA@mail.gmail.com>
Subject: Re: [PATCH v2] irqchip: vt8500: Switch to a simple write clear for
 Interrupt Status Register
From: Axel Lin <axel.lin@ingics.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Prisk <linux@prisktech.co.nz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-28 18:08 GMT+08:00 Thomas Gleixner <tglx@linutronix.de>:
> On Mon, 28 Apr 2014, Axel Lin wrote:
>
>> According to the datasheet, the attribute of Interrupt Status Register is RW0S,
>> which means:
>>       Software can read the register.
>>       Software can also "write 1 to clear". "write 0" has no effect.
>>
>> So the read/modify/write cycle is no necessary, switch to a simple write clear
>> instead.
>
> Again, what's the point of this?
>
> There is still nothing which masks the interrupt at the controller
> level which is the purpose of the irq_mask() callback.
>
Ah, stupid me.
Let me try again to fix this.

Thanks,
Axel
