Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbaKFSJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:09:32 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:39975 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750881AbaKFSJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:09:30 -0500
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: Re: [PATCH] clocksource: =?UTF-8?Q?arch=5Ftimer=3A=20Mark=20ARMv?=  =?UTF-8?Q?=38=20system=20timer=20as=20=27always-on=27?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Nov 2014 18:09:25 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
Cc: <daniel.lezcano@linaro.org>, <lorenzo.pieralisi@arm.com>,
        <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Organization: ARM Ltd
In-Reply-To: <1415296639-40203-1-git-send-email-anatol.pomozov@gmail.com>
References: <1415296639-40203-1-git-send-email-anatol.pomozov@gmail.com>
Message-ID: <ad6085048a3c0a42c03d623a6770e300@www.loen.fr>
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: anatol.pomozov@gmail.com, daniel.lezcano@linaro.org, lorenzo.pieralisi@arm.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anatol,

On 2014-11-06 17:57, Anatol Pomozov wrote:
> Quoting ARMv8 Reference Manual section D6.1:
> "The system counter must be implemented in an always-on power 
> domain."

Yes. And the key words here are "system counter". That's the global 
counter, not the per-cpu view of that, and critically nor comparators.

The timers (per-cpu counter+comparator) will happily go down with the 
CPU, and won't be able to wake it up. Exactly like ARMv7, by the way.

> There is no need to keep 'always-on' configurable on ARMv8. We ignore
> this dts property value and unconditionally set it to true.
>
> The issue was discovered while working on ARMv8 board with only one 
> timer
> (arm arch timer). If 'always-on' is false then it disables 
> high-resolution
> timer functionality.

Yup, and that's by design (see above). The *only* case where it is 
really "always-on" is when a virtual machine is running (if the vcpu is 
running then the physical CPU is, and so is the timer).

If your system really never does any form of PM, then fine, just put 
the DT property in. Removing it is, I'm sorry to say, a bit short 
sighted.

Thanks,

         M.
-- 
Fast, cheap, reliable. Pick two.
