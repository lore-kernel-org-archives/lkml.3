Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab3JGE5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 00:57:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54700 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3JGE5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 00:57:39 -0400
Message-ID: <52523F19.9080104@ti.com>
Date: Sun, 6 Oct 2013 23:56:57 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jonathan Austin <jonathan.austin@arm.com>,
        =?ISO-8859-1?Q?Andr=E9_Hent?= =?ISO-8859-1?Q?schel?= 
	<nerv@dawncrow.de>
Subject: Re: [RFC] ARM: kernel: irq: Simplify allocation of stack frame
References: <1381098649-21417-1-git-send-email-joelf@ti.com> <20131006224150.GA25647@n2100.arm.linux.org.uk>
In-Reply-To: <20131006224150.GA25647@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2013 05:41 PM, Russell King - ARM Linux wrote:
> On Sun, Oct 06, 2013 at 05:30:47PM -0500, Joel Fernandes wrote:
>> On receiving IRQ exception in SVC mode, all the SVC mode registers are saved
>> onto the stack very early on.
>>
>> The stack frame allocation code for IRQ entry during SVC mode (svc_entry) is
>> hard to read as 4-less is allocated initially only to be allocated later
>> implicity using the mov r3, [sp, #-4]! instruction. We make code easier to read
>> by allocating the 4 bytes on the stack frame in the beginning itself and remove
>> all instances where 4 bytes is adjusted.
> 
> You omit to say that this results in saving one additional register

Ok, I will add this detail to the commit message.

> unnecessarily in the stmia.  We could use a stmib there instead which
> would avoid that issue while keeping the rest of the change.

But stmib is not available in THUMB mode, so this will break the THUMB builds.

usr_entry does something similar:
 ARM(   stmib   sp, {r1 - r12}  )
 THUMB( stmia   sp, {r0 - r12}  )

Let me know your suggestions about using ARM/THUMB macros or stmia for both
cases. Thanks.

Regards,

-Joel
