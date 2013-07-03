Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab3GCQdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 12:33:12 -0400
Received: from nm16-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.166]:46796
	"EHLO nm16-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932202Ab3GCQdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 12:33:10 -0400
X-Yahoo-Newman-Id: 38079.13549.bm@smtp108.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: KTe8uOQVM1kDfMIhSLyzomUH2guH8FbyUWzIBFVH3JKpt3I
 .iD3QoMoL9dDvoS2X5.g6LooqZ.P_em.fsm._ycGoW0DDe9AGHdi4lkNGARn
 OJELk0HwgAzXf2c8sSjmaHwupUssrgIk93S_802hDyGsJr4rlsd_VpCRBL_X
 ojGARHyWd_fWXU.AL6anb.hMm2axVxMxNRNVW6vK3kufTih0HsA4a3zjc_eV
 kWMo83WWqiwElaeDGiCoYkc0bCzgKXHOlZ6R5LcL12Kpvk9RJeXZOH5lHJIv
 Smsr0JpvywbATnW3qvFx5k.v5RZ.rW.CFJHGe6HcQ_mzhlvJtzNaRz0qlF0K
 TTB0zCw06urVclddX3n2VmRazTACMlkX..ff6V738Ss6abY1c29AKUGyFmld
 twjPZfpNkuVPGozEUs2ByeGdWv7iD44T4qdrcaCs9QEgk88KzTOEEY70hC8G
 yQucCOqqN4wMvDPIipia.6fRF46uf7cpEE5bytDSf1AdxCf.SsHtdcJDJIV4
 utzPUWZFn6MmONDHqUQPvuL9w_b_M5t8ZIPZ23RRxKsmrwGkj47wGd1.bWuz
 k
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp108.sbc.mail.ne1.yahoo.com with SMTP; 03 Jul 2013 09:33:09 -0700 PDT
Date: Wed, 3 Jul 2013 09:33:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] 3.10: NCT6776F sensor question with Supermicro
 X9SRL-F motherboard
Message-ID: <20130703163311.GB12506@roeck-us.net>
References: <002901ce77e9$dfac4f20$9f04ed60$@lucidpixels.com>
 <20130703144201.GA10323@roeck-us.net>
 <007101ce7807$88cfb160$9a6f1420$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <007101ce7807$88cfb160$9a6f1420$@lucidpixels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 12:08:17PM -0400, Justin Piszcz wrote:
> 
> 
> -----Original Message-----
> From: Guenter Roeck [mailto:linux@roeck-us.net] 
> Sent: Wednesday, July 03, 2013 10:42 AM
> To: Justin Piszcz
> Cc: linux-kernel@vger.kernel.org; lm-sensors@lm-sensors.org
> Subject: Re: [lm-sensors] 3.10: NCT6776F sensor question with Supermicro
> X9SRL-F motherboard
> 
> [ .. ]
> 
> This is surprising and might be where the alarm comes from. What output do
> you
> get if you load the coretemp driver ? 
> 
> coretemp-isa-0000
> Adapter: ISA adapter
> Physical id 0:  +38.0 C  (high = +81.0 C, crit = +91.0 C)
> Core 0:         +36.0 C  (high = +81.0 C, crit = +91.0 C)
> Core 1:         +35.0 C  (high = +81.0 C, crit = +91.0 C)
> Core 2:         +35.0 C  (high = +81.0 C, crit = +91.0 C)
> Core 3:         +34.0 C  (high = +81.0 C, crit = +91.0 C)
> Core 4:         +37.0 C  (high = +81.0 C, crit = +91.0 C)
> Core 5:         +38.0 C  (high = +81.0 C, crit = +91.0 C)
> 
Can you install superiotool and run "sudo superiotool -V -e" ?
I would like to see raw data from the superio chip.

> > PCH_CHIP_TEMP:   +0.0 C  
> > PCH_CPU_TEMP:    +0.0 C  
> > PCH_MCH_TEMP:    +0.0 C  
> > intrusion0:    ALARM
> > intrusion1:    ALARM
> 
> Are those not connected ?
> 
> The intrusion headers are not connected, also, I have not dug into it but
> when you try to ignore the PECI or those PCH* lm_sensors seems to ignore the
> rule.
> 
> sensors3.conf:
>     ignore PCH_CHIP_TEMP
>     ignore PCH_CPU_TEMP
>     ignore PCH_MCH_TEMP
> 
You have to specify the raw attribute names, not the symbolic ones.
You see the raw attribute names with "sensors -u".

> $ sensors  |tail -n 4
> PCH_CHIP_TEMP:   +0.0 C
> PCH_CPU_TEMP:    +0.0 C
> PCH_MCH_TEMP:    +0.0 C
> 
> Ignoring intrusion works though:
>     ignore intrusion0
>     ignore intrusion1
> 
Does the board have intrusion detection headers ? If so, you could close
(bridge) the header(s) which should get rid of the alarm.

Thanks,
Guenter
