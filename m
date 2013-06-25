Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab3FYXuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 19:50:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab3FYXue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 19:50:34 -0400
Message-ID: <51CA2CBF.70404@redhat.com>
Date: Tue, 25 Jun 2013 19:50:23 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, athorlton@sgi.com,
        CAI Qian <caiqian@redhat.com>
Subject: Re: BUG: tick device NULL pointer during system initialization and
 shutdown
References: <51C0AB09.2090605@redhat.com> <alpine.DEB.2.02.1306241551020.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306241551020.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/24/2013 09:57 AM, Thomas Gleixner wrote:
> On Tue, 18 Jun 2013, Prarit Bhargava wrote:
> 
>> Similar panics reported during bringup here:
>>
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-May/166205.html
>> http://lkml.org/lkml/2013/5/8/342
>>
>> I've seen this a few times on 3.10 based kernels.
>>
>> [  175.842027] Disabling non-boot CPUs ...
>> [  475.827017] BUG: unable to handle kernel NULL pointer dereference at
>> 0000000000000048
> 
> That looks like a stale bit in tick_broadcast_force_mask.
> 
> Does the patch below fix it?
>

Thomas,

Thanks for the patch.

The reproducibility appears to be quite low.  I'm seeing this roughly 1 time
every six hours of continuous system reboots.  I'm testing right now with your
patch.  I'll update the thread in a couple of days...

P.
