Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbaDHKv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 06:51:56 -0400
Received: from smtprelay.synopsys.com ([198.182.44.111]:45153 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353AbaDHKvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 06:51:51 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARC: Remove ISS_SMP_EXTN entirely
Thread-Topic: [PATCH] ARC: Remove ISS_SMP_EXTN entirely
Thread-Index: AQHPUwhlTEyJveja0ESkki83qvmg4A==
Date: Tue, 8 Apr 2014 10:49:05 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230751AC680@IN01WEMBXA.internal.synopsys.com>
References: <1396947368.26620.2.camel@x220>
	 <C2D7FE5348E1B147BCA15975FBA230751AC602@IN01WEMBXA.internal.synopsys.com>
 <1396953743.26620.23.camel@x220>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.197.213]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 April 2014 04:12 PM, Paul Bolle wrote:
> Vineet,
>
> On Tue, 2014-04-08 at 09:18 +0000, Vineet Gupta wrote:
>> There's obvious bitrot here - however this code is not dead yet !
>> I have a unpushed fix which uses this Kconfig item.
>>
>> diff --git a/arch/arc/plat-arcfpga/Makefile b/arch/arc/plat-arcfpga/Makefile
>> index a44e22ebc1b7..4d1bddc34b5b 100644
>> --- a/arch/arc/plat-arcfpga/Makefile
>> +++ b/arch/arc/plat-arcfpga/Makefile
>> @@ -9,4 +9,4 @@
>>  KBUILD_CFLAGS  += -Iarch/arc/plat-arcfpga/include
>>  
>>  obj-y := platform.o irq.o
>> -obj-$(CONFIG_SMP)              += smp.o
>> +obj-$(CONFIG_ISS_SMP_EXTN)             += smp.o
> I just realized that this means you're only using ISS_SMP_EXTN as an
> alias for SMP, aren't you? Ie, smp.o will now be built if both
> ARC_PLAT_FPGA_LEGACY and SMP are set. That will not change by this
> patch.
>
> So unless you're planning to do something else too if ISS_SMP_EXTN is
> set there seems to be little value in using this symbol like that.

Indeed so - I just sent u one hunk to give an idea. There's other code too where
CONFIG_SMP will be replaced by CONFIG_ISS_SMP_EXTN as I'm decoupling SMP support
from this SMP extension.

I'll push a patch later today - which will hopefully hit mainline within this
merge window - if not in one of the rcs.

-Vineet
