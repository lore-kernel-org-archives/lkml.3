Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab3EWMto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:49:44 -0400
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:57976 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757821Ab3EWMtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:49:43 -0400
Message-ID: <519DE6A8.6040502@overkiz.com>
Date: Thu, 23 May 2013 11:51:36 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH 1/3] ARM: at91: move at91 aic driver to drivers/irqchip
References: <1369299909-10078-1-git-send-email-b.brezillon@overkiz.com> <1369299909-10078-2-git-send-email-b.brezillon@overkiz.com> <20130523090611.GG9937@game.jcrosoft.org>
In-Reply-To: <20130523090611.GG9937@game.jcrosoft.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 16668385171480017068
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeihedrtdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeihedrtdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/2013 11:06, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 11:05 Thu 23 May     , Boris BREZILLON wrote:
>> Move arch/arm/mach-at91/irq.c to drivers/irqchip/irq-at91.c.
>> Move arch/arm/mach-at91/at91_aic.h to
>> arch/arm/mach-at91/include/mach/at91_aic.h to avoid ugly reference
>> to header file :
>> #include "../../arch/arm/mach-at91/at91_aic.h"
> no we are going to drop arch/arm/mach-at91/include/mach for multi support
>
> arch/arm/mach-at91/include/mach is for removal
What should be done ?

include ../../arch/arm/mach-at91/at91_aic.h from irq-at91.c

or

move at91_aic.h into drivers/irqchips and patch every non dt board to
include ../../../drivers/irqchip/at91_aic.h

>
> Best Regards,
> J.
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> ---
>>   arch/arm/mach-at91/Makefile                        |    2 +-
>>   arch/arm/mach-at91/at91rm9200.c                    |    2 +-
>>   arch/arm/mach-at91/at91sam9260.c                   |    2 +-
>>   arch/arm/mach-at91/at91sam9261.c                   |    2 +-
>>   arch/arm/mach-at91/at91sam9263.c                   |    2 +-
>>   arch/arm/mach-at91/at91sam9g45.c                   |    2 +-
>>   arch/arm/mach-at91/at91sam9rl.c                    |    2 +-
>>   arch/arm/mach-at91/at91x40.c                       |    2 +-
>>   arch/arm/mach-at91/board-1arm.c                    |    2 +-
>>   arch/arm/mach-at91/board-afeb-9260v1.c             |    2 +-
>>   arch/arm/mach-at91/board-cam60.c                   |    2 +-
>>   arch/arm/mach-at91/board-carmeva.c                 |    2 +-
>>   arch/arm/mach-at91/board-cpu9krea.c                |    2 +-
>>   arch/arm/mach-at91/board-cpuat91.c                 |    2 +-
>>   arch/arm/mach-at91/board-csb337.c                  |    2 +-
>>   arch/arm/mach-at91/board-csb637.c                  |    2 +-
>>   arch/arm/mach-at91/board-dt-rm9200.c               |    3 ++-
>>   arch/arm/mach-at91/board-dt-sam9.c                 |    3 ++-
>>   arch/arm/mach-at91/board-dt-sama5.c                |    3 ++-
>>   arch/arm/mach-at91/board-eb01.c                    |    3 ++-
>>   arch/arm/mach-at91/board-eb9200.c                  |    3 ++-
>>   arch/arm/mach-at91/board-ecbat91.c                 |    2 +-
>>   arch/arm/mach-at91/board-eco920.c                  |    2 +-
>>   arch/arm/mach-at91/board-flexibity.c               |    2 +-
>>   arch/arm/mach-at91/board-foxg20.c                  |    2 +-
>>   arch/arm/mach-at91/board-gsia18s.c                 |    2 +-
>>   arch/arm/mach-at91/board-kafa.c                    |    2 +-
>>   arch/arm/mach-at91/board-kb9202.c                  |    2 +-
>>   arch/arm/mach-at91/board-pcontrol-g20.c            |    2 +-
>>   arch/arm/mach-at91/board-picotux200.c              |    2 +-
>>   arch/arm/mach-at91/board-qil-a9260.c               |    2 +-
>>   arch/arm/mach-at91/board-rm9200dk.c                |    2 +-
>>   arch/arm/mach-at91/board-rm9200ek.c                |    2 +-
>>   arch/arm/mach-at91/board-rsi-ews.c                 |    3 ++-
>>   arch/arm/mach-at91/board-sam9-l9260.c              |    2 +-
>>   arch/arm/mach-at91/board-sam9260ek.c               |    2 +-
>>   arch/arm/mach-at91/board-sam9261ek.c               |    2 +-
>>   arch/arm/mach-at91/board-sam9263ek.c               |    2 +-
>>   arch/arm/mach-at91/board-sam9g20ek.c               |    2 +-
>>   arch/arm/mach-at91/board-sam9m10g45ek.c            |    2 +-
>>   arch/arm/mach-at91/board-sam9rlek.c                |    2 +-
>>   arch/arm/mach-at91/board-snapper9260.c             |    2 +-
>>   arch/arm/mach-at91/board-stamp9g20.c               |    2 +-
>>   arch/arm/mach-at91/board-usb-a926x.c               |    2 +-
>>   arch/arm/mach-at91/board-yl-9200.c                 |    2 +-
>>   arch/arm/mach-at91/{ => include/mach}/at91_aic.h   |    0
>>   arch/arm/mach-at91/pm.c                            |    2 +-
>>   drivers/irqchip/Makefile                           |    1 +
>>   .../mach-at91/irq.c => drivers/irqchip/irq-at91.c  |    2 +-
>>   49 files changed, 54 insertions(+), 47 deletions(-)
>>
>> diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
>> index 788562d..5333701 100644
>> --- a/arch/arm/mach-at91/Makefile
>> +++ b/arch/arm/mach-at91/Makefile
>> @@ -2,7 +2,7 @@
>>   # Makefile for the linux kernel.
>>   #
>>   
>> -obj-y		:= irq.o gpio.o setup.o
>> +obj-y		:= gpio.o setup.o
>>   obj-m		:=
>>   obj-n		:=
>>   obj-		:=
>> diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
>> index d193a40..6c1204a 100644
>> --- a/arch/arm/mach-at91/at91rm9200.c
>> +++ b/arch/arm/mach-at91/at91rm9200.c
>> @@ -20,8 +20,8 @@
>>   #include <mach/at91_pmc.h>
>>   #include <mach/at91_st.h>
>>   #include <mach/cpu.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "soc.h"
>>   #include "generic.h"
>>   #include "clock.h"
>> diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
>> index a8ce245..55332fa 100644
>> --- a/arch/arm/mach-at91/at91sam9260.c
>> +++ b/arch/arm/mach-at91/at91sam9260.c
>> @@ -21,8 +21,8 @@
>>   #include <mach/at91_dbgu.h>
>>   #include <mach/at91sam9260.h>
>>   #include <mach/at91_pmc.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "at91_rstc.h"
>>   #include "soc.h"
>>   #include "generic.h"
>> diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
>> index 25efb5a..6db61e6 100644
>> --- a/arch/arm/mach-at91/at91sam9261.c
>> +++ b/arch/arm/mach-at91/at91sam9261.c
>> @@ -20,8 +20,8 @@
>>   #include <mach/cpu.h>
>>   #include <mach/at91sam9261.h>
>>   #include <mach/at91_pmc.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "at91_rstc.h"
>>   #include "soc.h"
>>   #include "generic.h"
>> diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
>> index f44ffd2..b9ec043 100644
>> --- a/arch/arm/mach-at91/at91sam9263.c
>> +++ b/arch/arm/mach-at91/at91sam9263.c
>> @@ -19,8 +19,8 @@
>>   #include <asm/system_misc.h>
>>   #include <mach/at91sam9263.h>
>>   #include <mach/at91_pmc.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "at91_rstc.h"
>>   #include "soc.h"
>>   #include "generic.h"
>> diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
>> index 8b7fce0..1270707 100644
>> --- a/arch/arm/mach-at91/at91sam9g45.c
>> +++ b/arch/arm/mach-at91/at91sam9g45.c
>> @@ -20,8 +20,8 @@
>>   #include <mach/at91sam9g45.h>
>>   #include <mach/at91_pmc.h>
>>   #include <mach/cpu.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "soc.h"
>>   #include "generic.h"
>>   #include "clock.h"
>> diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
>> index f77fae5..d5f77d6 100644
>> --- a/arch/arm/mach-at91/at91sam9rl.c
>> +++ b/arch/arm/mach-at91/at91sam9rl.c
>> @@ -20,8 +20,8 @@
>>   #include <mach/at91_dbgu.h>
>>   #include <mach/at91sam9rl.h>
>>   #include <mach/at91_pmc.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "at91_rstc.h"
>>   #include "soc.h"
>>   #include "generic.h"
>> diff --git a/arch/arm/mach-at91/at91x40.c b/arch/arm/mach-at91/at91x40.c
>> index 19ca793..e8b30fb 100644
>> --- a/arch/arm/mach-at91/at91x40.c
>> +++ b/arch/arm/mach-at91/at91x40.c
>> @@ -20,8 +20,8 @@
>>   #include <mach/at91x40.h>
>>   #include <mach/at91_st.h>
>>   #include <mach/timex.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "generic.h"
>>   
>>   /*
>> diff --git a/arch/arm/mach-at91/board-1arm.c b/arch/arm/mach-at91/board-1arm.c
>> index 35ab632..8037dfe 100644
>> --- a/arch/arm/mach-at91/board-1arm.c
>> +++ b/arch/arm/mach-at91/board-1arm.c
>> @@ -34,9 +34,9 @@
>>   #include <asm/mach/map.h>
>>   #include <asm/mach/irq.h>
>>   
>> +#include <mach/at91_aic.h>
>>   #include <mach/cpu.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "generic.h"
>>   
>> diff --git a/arch/arm/mach-at91/board-afeb-9260v1.c b/arch/arm/mach-at91/board-afeb-9260v1.c
>> index f95e31c..28bea23 100644
>> --- a/arch/arm/mach-at91/board-afeb-9260v1.c
>> +++ b/arch/arm/mach-at91/board-afeb-9260v1.c
>> @@ -42,8 +42,8 @@
>>   #include <asm/mach/arch.h>
>>   #include <asm/mach/map.h>
>>   #include <asm/mach/irq.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "generic.h"
>>   
>> diff --git a/arch/arm/mach-at91/board-cam60.c b/arch/arm/mach-at91/board-cam60.c
>> index ade948b..6ebdf32 100644
>> --- a/arch/arm/mach-at91/board-cam60.c
>> +++ b/arch/arm/mach-at91/board-cam60.c
>> @@ -39,8 +39,8 @@
>>   #include <asm/mach/irq.h>
>>   
>>   #include <mach/at91sam9_smc.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "sam9_smc.h"
>>   #include "generic.h"
>> diff --git a/arch/arm/mach-at91/board-carmeva.c b/arch/arm/mach-at91/board-carmeva.c
>> index 9298305..842db49 100644
>> --- a/arch/arm/mach-at91/board-carmeva.c
>> +++ b/arch/arm/mach-at91/board-carmeva.c
>> @@ -35,8 +35,8 @@
>>   #include <asm/mach/irq.h>
>>   
>>   #include <mach/hardware.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "generic.h"
>>   
>> diff --git a/arch/arm/mach-at91/board-cpu9krea.c b/arch/arm/mach-at91/board-cpu9krea.c
>> index 008527e..4714e9e 100644
>> --- a/arch/arm/mach-at91/board-cpu9krea.c
>> +++ b/arch/arm/mach-at91/board-cpu9krea.c
>> @@ -43,8 +43,8 @@
>>   #include <mach/at91sam9_smc.h>
>>   #include <mach/at91sam9260_matrix.h>
>>   #include <mach/at91_matrix.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "sam9_smc.h"
>>   #include "generic.h"
>> diff --git a/arch/arm/mach-at91/board-cpuat91.c b/arch/arm/mach-at91/board-cpuat91.c
>> index 42f1353..c1663ed 100644
>> --- a/arch/arm/mach-at91/board-cpuat91.c
>> +++ b/arch/arm/mach-at91/board-cpuat91.c
>> @@ -39,8 +39,8 @@
>>   #include <mach/at91rm9200_mc.h>
>>   #include <mach/at91_ramc.h>
>>   #include <mach/cpu.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "generic.h"
>>   
>> diff --git a/arch/arm/mach-at91/board-csb337.c b/arch/arm/mach-at91/board-csb337.c
>> index e5fde215..3231703 100644
>> --- a/arch/arm/mach-at91/board-csb337.c
>> +++ b/arch/arm/mach-at91/board-csb337.c
>> @@ -38,8 +38,8 @@
>>   #include <asm/mach/irq.h>
>>   
>>   #include <mach/hardware.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "generic.h"
>>   
>> diff --git a/arch/arm/mach-at91/board-csb637.c b/arch/arm/mach-at91/board-csb637.c
>> index fdf1106..d58c7e6 100644
>> --- a/arch/arm/mach-at91/board-csb637.c
>> +++ b/arch/arm/mach-at91/board-csb637.c
>> @@ -35,8 +35,8 @@
>>   #include <asm/mach/irq.h>
>>   
>>   #include <mach/hardware.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "generic.h"
>>   
>> diff --git a/arch/arm/mach-at91/board-dt-rm9200.c b/arch/arm/mach-at91/board-dt-rm9200.c
>> index 3fcb662..0c2a06d 100644
>> --- a/arch/arm/mach-at91/board-dt-rm9200.c
>> +++ b/arch/arm/mach-at91/board-dt-rm9200.c
>> @@ -22,7 +22,8 @@
>>   #include <asm/mach/map.h>
>>   #include <asm/mach/irq.h>
>>   
>> -#include "at91_aic.h"
>> +#include <mach/at91_aic.h>
>> +
>>   #include "generic.h"
>>   
>>   
>> diff --git a/arch/arm/mach-at91/board-dt-sam9.c b/arch/arm/mach-at91/board-dt-sam9.c
>> index 8db3013..ac899d8 100644
>> --- a/arch/arm/mach-at91/board-dt-sam9.c
>> +++ b/arch/arm/mach-at91/board-dt-sam9.c
>> @@ -21,7 +21,8 @@
>>   #include <asm/mach/map.h>
>>   #include <asm/mach/irq.h>
>>   
>> -#include "at91_aic.h"
>> +#include <mach/at91_aic.h>
>> +
>>   #include "board.h"
>>   #include "generic.h"
>>   
>> diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
>> index 705305e..43b8f7a 100644
>> --- a/arch/arm/mach-at91/board-dt-sama5.c
>> +++ b/arch/arm/mach-at91/board-dt-sama5.c
>> @@ -23,7 +23,8 @@
>>   #include <asm/mach/map.h>
>>   #include <asm/mach/irq.h>
>>   
>> -#include "at91_aic.h"
>> +#include <mach/at91_aic.h>
>> +
>>   #include "generic.h"
>>   
>>   
>> diff --git a/arch/arm/mach-at91/board-eb01.c b/arch/arm/mach-at91/board-eb01.c
>> index becf0a6..4097ede 100644
>> --- a/arch/arm/mach-at91/board-eb01.c
>> +++ b/arch/arm/mach-at91/board-eb01.c
>> @@ -28,7 +28,8 @@
>>   #include <asm/mach/arch.h>
>>   #include <asm/mach/map.h>
>>   
>> -#include "at91_aic.h"
>> +#include <mach/at91_aic.h>
>> +
>>   #include "board.h"
>>   #include "generic.h"
>>   
>> diff --git a/arch/arm/mach-at91/board-eb9200.c b/arch/arm/mach-at91/board-eb9200.c
>> index f9be816..afa5ebb 100644
>> --- a/arch/arm/mach-at91/board-eb9200.c
>> +++ b/arch/arm/mach-at91/board-eb9200.c
>> @@ -35,7 +35,8 @@
>>   #include <asm/mach/map.h>
>>   #include <asm/mach/irq.h>
>>   
>> -#include "at91_aic.h"
>> +#include <mach/at91_aic.h>
>> +
>>   #include "board.h"
>>   #include "generic.h"
>>   
>> diff --git a/arch/arm/mach-at91/board-ecbat91.c b/arch/arm/mach-at91/board-ecbat91.c
>> index b2fcd71..c794768 100644
>> --- a/arch/arm/mach-at91/board-ecbat91.c
>> +++ b/arch/arm/mach-at91/board-ecbat91.c
>> @@ -38,8 +38,8 @@
>>   #include <asm/mach/irq.h>
>>   
>>   #include <mach/cpu.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "generic.h"
>>   
>> diff --git a/arch/arm/mach-at91/board-eco920.c b/arch/arm/mach-at91/board-eco920.c
>> index 77de410..fc3e373 100644
>> --- a/arch/arm/mach-at91/board-eco920.c
>> +++ b/arch/arm/mach-at91/board-eco920.c
>> @@ -27,8 +27,8 @@
>>   #include <mach/at91rm9200_mc.h>
>>   #include <mach/at91_ramc.h>
>>   #include <mach/cpu.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "generic.h"
>>   
>> diff --git a/arch/arm/mach-at91/board-flexibity.c b/arch/arm/mach-at91/board-flexibity.c
>> index 737c085..59a1958 100644
>> --- a/arch/arm/mach-at91/board-flexibity.c
>> +++ b/arch/arm/mach-at91/board-flexibity.c
>> @@ -33,8 +33,8 @@
>>   #include <asm/mach/irq.h>
>>   
>>   #include <mach/hardware.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "generic.h"
>>   
>> diff --git a/arch/arm/mach-at91/board-foxg20.c b/arch/arm/mach-at91/board-foxg20.c
>> index c20a870..4b4df05 100644
>> --- a/arch/arm/mach-at91/board-foxg20.c
>> +++ b/arch/arm/mach-at91/board-foxg20.c
>> @@ -42,8 +42,8 @@
>>   #include <asm/mach/irq.h>
>>   
>>   #include <mach/at91sam9_smc.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "sam9_smc.h"
>>   #include "generic.h"
>> diff --git a/arch/arm/mach-at91/board-gsia18s.c b/arch/arm/mach-at91/board-gsia18s.c
>> index c1d61d2..1babcbd 100644
>> --- a/arch/arm/mach-at91/board-gsia18s.c
>> +++ b/arch/arm/mach-at91/board-gsia18s.c
>> @@ -31,8 +31,8 @@
>>   #include <asm/mach/arch.h>
>>   
>>   #include <mach/at91sam9_smc.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "sam9_smc.h"
>>   #include "generic.h"
>> diff --git a/arch/arm/mach-at91/board-kafa.c b/arch/arm/mach-at91/board-kafa.c
>> index 88e2f5d..aca52d3 100644
>> --- a/arch/arm/mach-at91/board-kafa.c
>> +++ b/arch/arm/mach-at91/board-kafa.c
>> @@ -35,8 +35,8 @@
>>   #include <asm/mach/irq.h>
>>   
>>   #include <mach/cpu.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "generic.h"
>>   
>> diff --git a/arch/arm/mach-at91/board-kb9202.c b/arch/arm/mach-at91/board-kb9202.c
>> index 0c519d9..7768df0 100644
>> --- a/arch/arm/mach-at91/board-kb9202.c
>> +++ b/arch/arm/mach-at91/board-kb9202.c
>> @@ -38,8 +38,8 @@
>>   #include <mach/cpu.h>
>>   #include <mach/at91rm9200_mc.h>
>>   #include <mach/at91_ramc.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "generic.h"
>>   
>> diff --git a/arch/arm/mach-at91/board-pcontrol-g20.c b/arch/arm/mach-at91/board-pcontrol-g20.c
>> index 65c0d6b..6df21db 100644
>> --- a/arch/arm/mach-at91/board-pcontrol-g20.c
>> +++ b/arch/arm/mach-at91/board-pcontrol-g20.c
>> @@ -30,8 +30,8 @@
>>   #include <asm/mach/arch.h>
>>   
>>   #include <mach/at91sam9_smc.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "sam9_smc.h"
>>   #include "generic.h"
>> diff --git a/arch/arm/mach-at91/board-picotux200.c b/arch/arm/mach-at91/board-picotux200.c
>> index ab2b2ec..566b30c 100644
>> --- a/arch/arm/mach-at91/board-picotux200.c
>> +++ b/arch/arm/mach-at91/board-picotux200.c
>> @@ -39,8 +39,8 @@
>>   
>>   #include <mach/at91rm9200_mc.h>
>>   #include <mach/at91_ramc.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "generic.h"
>>   
>> diff --git a/arch/arm/mach-at91/board-qil-a9260.c b/arch/arm/mach-at91/board-qil-a9260.c
>> index aa3bc9b..0ae5eb1 100644
>> --- a/arch/arm/mach-at91/board-qil-a9260.c
>> +++ b/arch/arm/mach-at91/board-qil-a9260.c
>> @@ -41,8 +41,8 @@
>>   
>>   #include <mach/hardware.h>
>>   #include <mach/at91sam9_smc.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "at91_shdwc.h"
>>   #include "board.h"
>>   #include "sam9_smc.h"
>> diff --git a/arch/arm/mach-at91/board-rm9200dk.c b/arch/arm/mach-at91/board-rm9200dk.c
>> index 690541b..82f0335e 100644
>> --- a/arch/arm/mach-at91/board-rm9200dk.c
>> +++ b/arch/arm/mach-at91/board-rm9200dk.c
>> @@ -41,8 +41,8 @@
>>   #include <mach/hardware.h>
>>   #include <mach/at91rm9200_mc.h>
>>   #include <mach/at91_ramc.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "generic.h"
>>   
>> diff --git a/arch/arm/mach-at91/board-rm9200ek.c b/arch/arm/mach-at91/board-rm9200ek.c
>> index 8b17dad..5e8a4f7 100644
>> --- a/arch/arm/mach-at91/board-rm9200ek.c
>> +++ b/arch/arm/mach-at91/board-rm9200ek.c
>> @@ -41,8 +41,8 @@
>>   #include <mach/hardware.h>
>>   #include <mach/at91rm9200_mc.h>
>>   #include <mach/at91_ramc.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "generic.h"
>>   
>> diff --git a/arch/arm/mach-at91/board-rsi-ews.c b/arch/arm/mach-at91/board-rsi-ews.c
>> index f6d7f19..e7d0a69 100644
>> --- a/arch/arm/mach-at91/board-rsi-ews.c
>> +++ b/arch/arm/mach-at91/board-rsi-ews.c
>> @@ -28,7 +28,8 @@
>>   
>>   #include <linux/gpio.h>
>>   
>> -#include "at91_aic.h"
>> +#include <mach/at91_aic.h>
>> +
>>   #include "board.h"
>>   #include "generic.h"
>>   
>> diff --git a/arch/arm/mach-at91/board-sam9-l9260.c b/arch/arm/mach-at91/board-sam9-l9260.c
>> index 43ee4dc..2e400cd 100644
>> --- a/arch/arm/mach-at91/board-sam9-l9260.c
>> +++ b/arch/arm/mach-at91/board-sam9-l9260.c
>> @@ -38,8 +38,8 @@
>>   #include <asm/mach/irq.h>
>>   
>>   #include <mach/at91sam9_smc.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "sam9_smc.h"
>>   #include "generic.h"
>> diff --git a/arch/arm/mach-at91/board-sam9260ek.c b/arch/arm/mach-at91/board-sam9260ek.c
>> index 0b153c8..66ee7ac 100644
>> --- a/arch/arm/mach-at91/board-sam9260ek.c
>> +++ b/arch/arm/mach-at91/board-sam9260ek.c
>> @@ -43,8 +43,8 @@
>>   #include <mach/hardware.h>
>>   #include <mach/at91sam9_smc.h>
>>   #include <mach/system_rev.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "at91_shdwc.h"
>>   #include "board.h"
>>   #include "sam9_smc.h"
>> diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
>> index b446645..515957e 100644
>> --- a/arch/arm/mach-at91/board-sam9261ek.c
>> +++ b/arch/arm/mach-at91/board-sam9261ek.c
>> @@ -47,8 +47,8 @@
>>   #include <mach/hardware.h>
>>   #include <mach/at91sam9_smc.h>
>>   #include <mach/system_rev.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "at91_shdwc.h"
>>   #include "board.h"
>>   #include "sam9_smc.h"
>> diff --git a/arch/arm/mach-at91/board-sam9263ek.c b/arch/arm/mach-at91/board-sam9263ek.c
>> index 3284df0..1099272 100644
>> --- a/arch/arm/mach-at91/board-sam9263ek.c
>> +++ b/arch/arm/mach-at91/board-sam9263ek.c
>> @@ -46,8 +46,8 @@
>>   #include <mach/hardware.h>
>>   #include <mach/at91sam9_smc.h>
>>   #include <mach/system_rev.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "at91_shdwc.h"
>>   #include "board.h"
>>   #include "sam9_smc.h"
>> diff --git a/arch/arm/mach-at91/board-sam9g20ek.c b/arch/arm/mach-at91/board-sam9g20ek.c
>> index f9cd1f2..9fe718b 100644
>> --- a/arch/arm/mach-at91/board-sam9g20ek.c
>> +++ b/arch/arm/mach-at91/board-sam9g20ek.c
>> @@ -45,8 +45,8 @@
>>   
>>   #include <mach/at91sam9_smc.h>
>>   #include <mach/system_rev.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "sam9_smc.h"
>>   #include "generic.h"
>> diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
>> index 2a94896..1846647 100644
>> --- a/arch/arm/mach-at91/board-sam9m10g45ek.c
>> +++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
>> @@ -44,8 +44,8 @@
>>   
>>   #include <mach/at91sam9_smc.h>
>>   #include <mach/system_rev.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "at91_shdwc.h"
>>   #include "board.h"
>>   #include "sam9_smc.h"
>> diff --git a/arch/arm/mach-at91/board-sam9rlek.c b/arch/arm/mach-at91/board-sam9rlek.c
>> index aa265dc..623f2d1 100644
>> --- a/arch/arm/mach-at91/board-sam9rlek.c
>> +++ b/arch/arm/mach-at91/board-sam9rlek.c
>> @@ -31,9 +31,9 @@
>>   
>>   #include <mach/hardware.h>
>>   #include <mach/at91sam9_smc.h>
>> +#include <mach/at91_aic.h>
>>   
>>   
>> -#include "at91_aic.h"
>>   #include "at91_shdwc.h"
>>   #include "board.h"
>>   #include "sam9_smc.h"
>> diff --git a/arch/arm/mach-at91/board-snapper9260.c b/arch/arm/mach-at91/board-snapper9260.c
>> index 3aaa978..8fef38a 100644
>> --- a/arch/arm/mach-at91/board-snapper9260.c
>> +++ b/arch/arm/mach-at91/board-snapper9260.c
>> @@ -33,8 +33,8 @@
>>   
>>   #include <mach/hardware.h>
>>   #include <mach/at91sam9_smc.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "sam9_smc.h"
>>   #include "generic.h"
>> diff --git a/arch/arm/mach-at91/board-stamp9g20.c b/arch/arm/mach-at91/board-stamp9g20.c
>> index 869cbec..6bda942 100644
>> --- a/arch/arm/mach-at91/board-stamp9g20.c
>> +++ b/arch/arm/mach-at91/board-stamp9g20.c
>> @@ -26,8 +26,8 @@
>>   #include <asm/mach/arch.h>
>>   
>>   #include <mach/at91sam9_smc.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "sam9_smc.h"
>>   #include "generic.h"
>> diff --git a/arch/arm/mach-at91/board-usb-a926x.c b/arch/arm/mach-at91/board-usb-a926x.c
>> index 2487d94..cedbc66 100644
>> --- a/arch/arm/mach-at91/board-usb-a926x.c
>> +++ b/arch/arm/mach-at91/board-usb-a926x.c
>> @@ -42,8 +42,8 @@
>>   
>>   #include <mach/hardware.h>
>>   #include <mach/at91sam9_smc.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "at91_shdwc.h"
>>   #include "board.h"
>>   #include "sam9_smc.h"
>> diff --git a/arch/arm/mach-at91/board-yl-9200.c b/arch/arm/mach-at91/board-yl-9200.c
>> index be08377..c61d8c9 100644
>> --- a/arch/arm/mach-at91/board-yl-9200.c
>> +++ b/arch/arm/mach-at91/board-yl-9200.c
>> @@ -46,8 +46,8 @@
>>   #include <mach/at91rm9200_mc.h>
>>   #include <mach/at91_ramc.h>
>>   #include <mach/cpu.h>
>> +#include <mach/at91_aic.h>
>>   
>> -#include "at91_aic.h"
>>   #include "board.h"
>>   #include "generic.h"
>>   
>> diff --git a/arch/arm/mach-at91/at91_aic.h b/arch/arm/mach-at91/include/mach/at91_aic.h
>> similarity index 100%
>> rename from arch/arm/mach-at91/at91_aic.h
>> rename to arch/arm/mach-at91/include/mach/at91_aic.h
>> diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
>> index 530db30..d2a24e8 100644
>> --- a/arch/arm/mach-at91/pm.c
>> +++ b/arch/arm/mach-at91/pm.c
>> @@ -26,9 +26,9 @@
>>   #include <asm/mach/irq.h>
>>   
>>   #include <mach/at91_pmc.h>
>> +#include <mach/at91_aic.h>
>>   #include <mach/cpu.h>
>>   
>> -#include "at91_aic.h"
>>   #include "generic.h"
>>   #include "pm.h"
>>   
>> diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
>> index cda4cb5..208b708 100644
>> --- a/drivers/irqchip/Makefile
>> +++ b/drivers/irqchip/Makefile
>> @@ -1,5 +1,6 @@
>>   obj-$(CONFIG_IRQCHIP)			+= irqchip.o
>>   
>> +obj-$(CONFIG_ARCH_AT91)			+= irq-at91.o
>>   obj-$(CONFIG_ARCH_BCM2835)		+= irq-bcm2835.o
>>   obj-$(CONFIG_ARCH_EXYNOS)		+= exynos-combiner.o
>>   obj-$(CONFIG_ARCH_MVEBU)		+= irq-armada-370-xp.o
>> diff --git a/arch/arm/mach-at91/irq.c b/drivers/irqchip/irq-at91.c
>> similarity index 99%
>> rename from arch/arm/mach-at91/irq.c
>> rename to drivers/irqchip/irq-at91.c
>> index e0ca591..daf2959 100644
>> --- a/arch/arm/mach-at91/irq.c
>> +++ b/drivers/irqchip/irq-at91.c
>> @@ -42,7 +42,7 @@
>>   #include <asm/mach/irq.h>
>>   #include <asm/mach/map.h>
>>   
>> -#include "at91_aic.h"
>> +#include <mach/at91_aic.h>
>>   
>>   void __iomem *at91_aic_base;
>>   static struct irq_domain *at91_aic_domain;
>> -- 
>> 1.7.9.5
>>

