Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbaLKCaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 21:30:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:60494 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933251AbaLKCaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 21:30:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="497004294"
Message-ID: <548901A8.6020805@linux.intel.com>
Date: Wed, 10 Dec 2014 18:30:00 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org
Subject: Re: [GIT pull] x86 mpx support for 3.19
References: <alpine.DEB.2.11.1412091504490.16275@nanos> <877fxzexuz.fsf@x220.int.ebiederm.org>
In-Reply-To: <877fxzexuz.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 06:14 PM, Eric W. Biederman wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
>> please pull the latest x86-mpx-for-linus git tree from:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mpx-for-linus
>>
>> This enables support for x86 MPX:
>>
>>   MPX is a new debug feature for bound checking in user space. It
>>   requires kernel support to handle the bound tables and decode the
>>   bound violating instruction in the trap handler.
> 
> I some really dumb questions.
> 
> Given that mpx is both architecture and cpu specific why use prctl?
> I would think arch_prctl would be a much more appropriate place to
> expose this logic.

I actually never considered arch_prctl().  It doesn't seem a bad fit for
any reason, just that I never thought of it and no one suggested it up
to this point.

Is there any *real* advantage to arch_prctl()?  We have some gcc code
that's going to be using these prctls and if we need to change the
interface, we've got to get that code changed too... fast.

> Why don't you have a call to let an application query to see if mpx
> management is enabled?  I am trying to imagine how checkpoint/restart is
> going to be supported for mpx applications.  If I can't even query if
> mpx is enabled I don't have a clue how we could save this state and
> duplicate it in another process on another machine.

You probably need to actually save off the contents of mm->bd_addr
itself.  I guess you can do it along with all the other internals of the
mm that get saved off currently.
