Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbaCXUaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:30:35 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:53048 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbaCXUae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:30:34 -0400
Date: Mon, 24 Mar 2014 21:30:32 +0100
From: Andreas Mohr <andi@lisas.de>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Jack Carrozzo <jack@crepinc.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Thread Scheduler
Message-ID: <20140324203032.GA16964@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395572478.74811.YahooMailNeo@web141601.mail.bf1.yahoo.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> OK I read them and it seems that in order to change the scheduler, I have to write a C code and call the sched_set* functions. Please correct that if I am wrong.
> 
> So in order to use my custom scheduler, I have to do the following steps.
> 
> 1- Write my  code using the APIs and save that in kernel/sched_custom.c
> 2- Invoke sched_custom.c in kernel/sched.c
> 3- Recompile the kernel source
> 4- Reboot using the new kernel
> 5- write a C code and call sched_setschedule() to use my scheduler.
> 
> Is that all? Your reply is appreciated.

No, AFAIK these are *user-space* APIs, thus they're supposed to be used by
applications (correct me if I'm wrong).


So the question would be what exactly you're trying to achieve:
either you want to actively modify the kernel-side scheduler sources,
in which case these APIs probably are not what you want (to use there),
or you're trying to modify scheduling configuration of user-space applications,
in which case they possibly are.
Or you want both, in which case you probably
modify kernel scheduler implementation *and* use sched_*() in user-space
with the intent to ensure that that modified scheduler implementation
gets chosen.

HTH,

Andreas Mohr
