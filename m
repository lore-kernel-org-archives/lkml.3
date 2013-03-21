Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab3CUBQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 21:16:00 -0400
Received: from smtp.infotech.no ([82.134.31.41]:59164 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab3CUBP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 21:15:59 -0400
Message-ID: <514A5F2B.8030707@interlog.com>
Date: Wed, 20 Mar 2013 21:15:23 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: rtc-at91rm9200: use a variable for storing IMR
References: <1363369032-12639-1-git-send-email-nicolas.ferre@atmel.com> <20130320145006.f1431c1528325ff93a298790@linux-foundation.org>
In-Reply-To: <20130320145006.f1431c1528325ff93a298790@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-03-20 05:50 PM, Andrew Morton wrote:
> On Fri, 15 Mar 2013 18:37:12 +0100 Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
>
>> On some revisions of AT91 SoCs, the RTC IMR register is not working.
>> Instead of elaborating a workaround for that specific SoC or IP version,
>> we simply use a software variable to store the Interrupt Mask Register and
>> modify it for each enabling/disabling of an interrupt. The overhead of this
>> is negligible anyway.
>
> This description doesn't really allow me or others to work out whether
> the fix should be included in 3.9 or backported into earlier kernels.
>
> So please, when fixing a bug do include a full description of the
> user-visible effects of that bug.  And your opinion regarding the
> -mainline and -stable decision is always useful.

The interrupt mask register (IMR) for the RTC is broken
on the AT91SAM9x5 sub-family of SoCs (good overview of the
members here: http://www.eewiki.net/display/linuxonarm/AT91SAM9x5 ).
The "user visible effect" is the RTC doesn't work.

That sub-family is less than two years old and only has devicetree
(DT) support and came online circa lk 3.7 . The dust is yet to
settle on the DT stuff at least for AT91 SoCs (translation:
lots of stuff is still broken, so much that it is hard to know
where to start).

The fix in the patch is pretty simple: just shadow the silicon
IMR register with a variable in the driver. Some older SoCs (pre-DT)
use the the rtc-at91rm9200 driver (e.g. obviously the AT91RM9200)
and they should not be impacted by the change. There shouldn't
be a large volume of interrupts associated with a RTC.


Compared to a relatively stable kernel subsystem like SCSI, what
is happening in the ARM architecture with DT is huge and ongoing.
So I think you either need new rules or suspend some of the stricter
rules applied to more stable subsystems. Just my two cents worth.


Doug Gilbert

who hasn't seen that frill-necked lizard for a while
