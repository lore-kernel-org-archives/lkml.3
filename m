Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaBSD2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 22:28:11 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:42296 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaBSD1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 22:27:42 -0500
Message-ID: <530423CB.5060105@linux.vnet.ibm.com>
Date: Wed, 19 Feb 2014 08:53:55 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Preeti Murthy <preeti.lkml@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT Pull] timer fixes for 3.14
References: <alpine.DEB.2.02.1402152005210.21991@ionos.tec.linutronix.de> <CAM4v1pNDbiC54Ot6J2Tpc9t4BgT3fY7jgZkb6Fem4OfedwvV-w@mail.gmail.com> <alpine.DEB.2.02.1402181938140.4468@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402181938140.4468@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021903-0928-0000-0000-00000692A5AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 12:10 AM, Thomas Gleixner wrote:
> On Tue, 18 Feb 2014, Preeti Murthy wrote:
> 
>> Hi Thomas,
>>
>> With regard to the patch: "tick: Clear broadcast pending bit when
>> switching to oneshot"
>> isn't BROADCAST_EXIT called atleast after initializing the high
>> resolution timers while
>> handling the broadcast IPI and before re-entering idle? This should
>> clear the cpu bit
>> in the pending mask right?
>>
>> idle()
>> |__BROADCAST_ENTER
>>     |__halt()
>>       |__broadcast_ipi
>>           |__init_highres()->clear oneshot mask
>>               |__return from interrupt->BROADCAST_EXIT (clear pending mask)
> 
> Unfortunately not:
> 
>      if (cpumask_test_and_clear_cpu(cpu, tick_broadcast_oneshot_mask)) {
>      	  clear pending mask;
>      }
> 
>>                    |__re-enter idle
> 
> Go figure :)

Ah right! Thanks :)

Regards
Preeti U Murthy
> 
> Thanks,
> 
> 	tglx
> 

