Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab3EIONa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:13:30 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:47250 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753562Ab3EION2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:13:28 -0400
Message-ID: <518BADBF.4070303@st.com>
Date: Thu, 09 May 2013 15:07:59 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Martin <dave.martin@linaro.org>, linux-doc@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, will.deacon@arm.com,
        Grant Likely <grant.likely@secretlab.ca>, Jiri Slaby <jslaby@suse.cz>,
        linux@arm.linux.org.uk, Samuel Ortiz <sameo@linux.intel.com>,
        Nicolas Pitre <nico@linaro.org>, linux-serial@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Olof Johansson <olof@lixom.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [RFC 2/8] ARM:global_timer: Add ARM global timer support.
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <1368022260-2197-1-git-send-email-srinivas.kandagatla@st.com> <201305081638.23100.arnd@arndb.de>
In-Reply-To: <201305081638.23100.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/13 15:38, Arnd Bergmann wrote:
> On Wednesday 08 May 2013, Srinivas KANDAGATLA wrote:
>> From: Stuart Menefy <stuart.menefy@st.com>
>>
>> This is a simple driver for the global timer module found in the Cortex
>> A9-MP cores from revision r1p0 onwards. This should be able to perform
>> the functions of the system timer and the local timer in an SMP system.
>>
>> The global timer has the following features:
>>     The global timer is a 64-bit incrementing counter with an
>> auto-incrementing feature. It continues incrementing after sending
>> interrupts. The global timer is memory mapped in the private memory
>> region.
>>     The global timer is accessible to all Cortex-A9 processors in the
>> cluster. Each Cortex-A9 processor has a private 64-bit comparator that
>> is used to assert a private interrupt when the global timer has reached
>> the comparator value. All the Cortex-A9 processors in a design use the
>> banked ID, ID27, for this interrupt. ID27 is sent to the Interrupt
>> Controller as a Private Peripheral Interrupt. The global timer is
>> clocked by PERIPHCLK.
>>
>> Signed-off-by: Stuart Menefy <stuart.menefy@st.com>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>>
> 
> Are you sure we don't already have a driver for this? It sounds unlikely
> that you are the first one to do this when the hardware is so common.

Yes, in mainline we do not have support to this.

> 
>>  Documentation/devicetree/bindings/arm/gt.txt |   21 ++
>>  arch/arm/Kconfig                             |    6 +
>>  arch/arm/include/asm/global_timer.h          |   12 +
>>  arch/arm/kernel/Makefile                     |    1 +
>>  arch/arm/kernel/global_timer.c               |  325 ++++++++++++++++++++++++++
>>  5 files changed, 365 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/arm/gt.txt
>>  create mode 100644 arch/arm/include/asm/global_timer.h
>>  create mode 100644 arch/arm/kernel/global_timer.c
> 
> Move it into drivers/clocksource?

Sure, I will move this in the next version.

>  
>> diff --git a/arch/arm/include/asm/global_timer.h b/arch/arm/include/asm/global_timer.h
>> new file mode 100644
>> index 0000000..46f9188
>> --- /dev/null
>> +++ b/arch/arm/include/asm/global_timer.h
>> @@ -0,0 +1,12 @@
>> +int __init global_timer_init(void __iomem *base, unsigned int timer_irq);
> 
> I don't see a need to call this from platform code for non-DT platforms, it
> can easily be used with CLOCKSOURCE_OF_DECLARE() all the time I think.

sorry Am confused here.
How would this work for non-DT?

Looking at the code in clocksource_of_init it just goes through the
of_device_id table, which is not used in case of non-DT.
> 
> 	Arnd
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
> 

