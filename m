Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659Ab3FUG4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:56:22 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:48278 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758638Ab3FUG4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:56:21 -0400
Message-ID: <51C3F7CB.70703@st.com>
Date: Fri, 21 Jun 2013 07:50:51 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        kernel@stlinux.com, linux-serial@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Stephen Gallimore <stephen.gallimore@st.com>
Subject: Re: [PATCH v3 06/10] ARM:stixxxx: Add DEBUG_LL console support
References: <1371736996-8770-1-git-send-email-srinivas.kandagatla@st.com> <1371737176-9473-1-git-send-email-srinivas.kandagatla@st.com> <201306202055.43189.arnd@arndb.de>
In-Reply-To: <201306202055.43189.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/13 19:55, Arnd Bergmann wrote:
> On Thursday 20 June 2013, Srinivas KANDAGATLA wrote:
>> --- a/arch/arm/mach-stixxxx/board-dt.c
>> +++ b/arch/arm/mach-stixxxx/board-dt.c
>> @@ -11,6 +11,7 @@
>>  #include <linux/clocksource.h>
>>  #include <linux/irq.h>
>>  #include <asm/hardware/cache-l2x0.h>
>> +#include <asm/mach/map.h>
>>  #include <asm/mach/arch.h>
>>  
>>  #include "smp.h"
>> @@ -42,6 +43,7 @@ static const char *stih41x_dt_match[] __initdata = {
>>  };
>>  
>>  DT_MACHINE_START(STM, "STiH415/416 SoC with Flattened Device Tree")
>> +       .map_io         = debug_ll_io_init,
>>         .init_time      = stih41x_timer_init,
>>         .smp            = smp_ops(stixxxx_smp_ops),
>>         .dt_compat      = stih41x_dt_match,
> 
> This part of the patch is no longer needed, we do the same when .map_io
> is not set.

I can see the commit bc37324e "ARM: mmu: Call debug_ll_io_init if no
map_io function is specified" in arm-soc.git:for-next branch.

That makes sense to take care of this before this patch gets merged. I
will remove this line in next spin hopefully very soon.

Thanks,
srini


> 
> 	Arnd
> 
> 

