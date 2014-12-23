Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbaLWMxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 07:53:22 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:47477 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbaLWMxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 07:53:20 -0500
MIME-Version: 1.0
In-Reply-To: <20141222190233.GA1014@katana>
References: <1419272149-28716-1-git-send-email-walter@vanguardiasur.com.ar>
	<20141222190233.GA1014@katana>
Date: Tue, 23 Dec 2014 09:53:20 -0300
Message-ID: <CABxpGwDMY7T1OuHmLU4EmuBAyE_SCS-GTa=EeSGjZ976N1K9-g@mail.gmail.com>
Subject: Re: [RFC] i2c: designware: Avoid initcall and initialize the driver
 like a regular one
From: Walter Lozano <walter@vanguardiasur.com.ar>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: mika.westerberg@linux.intel.com, Romain.Baeriswyl@abilis.com,
        atull@opensource.altera.com, raymond.tan@intel.com,
        carlpeng008@gmail.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 4:02 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Mon, Dec 22, 2014 at 03:15:49PM -0300, Walter Lozano wrote:
>> Currently, the driver is relying on a subsys_initcall() to register
>> the platform driver struct. This is typically done to allow early uses
>> of the I2C bus (for instance, I2C regulators used from early machine code).
>>
>> While this might work on some cases, it breaks on others. For instance,
>> I2C devices with GPIO-wired interrupts will fail to request the
>> interrupt because of this initcall usage.
>>
>> This commits attempts to fix the above issue, by converting the I2C
>> driver into a regular kernel platform driver. This guarantees it will
>> probe after GPIOs drivers.
>>
>> Platforms based on devicetree won't be affected by this change.
>
> Huh, why is that?
>
>> Legacy platforms, relying on the I2C being available early, might need
>> to implement proper defered mechanisms to overcome potential problems.
>
> NAK. We can't say "Let's cause a regression to force people to fix
> things that used to work" IMO. You exactly pointed out the problem that using
> subsys_initcall() creates.
>
> What about fixing the drivers you use to support deferred probing when
> acquitin the irq?

Yes, probably it is the best approach to avoid possible issues with
other drivers.
I'll check your suggestion.

Thanks for your comments.

Regards,

Walter

-- 
Walter Lozano, VanguardiaSur
www.vanguardiasur.com.ar
