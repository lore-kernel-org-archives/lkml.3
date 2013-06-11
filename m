Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab3FKIAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 04:00:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57488 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab3FKIAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 04:00:18 -0400
X-IronPort-AV: E=Sophos;i="4.87,843,1363104000"; 
   d="scan'208";a="7519043"
Message-ID: <51B6D76D.9090207@cn.fujitsu.com>
Date: Tue, 11 Jun 2013 15:53:17 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        sbw@mit.edu
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
References: <20130609193657.GA13392@linux.vnet.ibm.com>	<1370911480.9844.160.camel@gandalf.local.home> <CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
In-Reply-To: <CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/11 15:48:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/11 15:48:55,
	Serialize complete at 2013/06/11 15:48:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 08:51 AM, Linus Torvalds wrote:
> On Mon, Jun 10, 2013 at 5:44 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>> OK, I haven't found a issue here yet, but youss are beiing trickssy! We
>> don't like trickssy, and we must find precccciouss!!!
> 
> .. and I personally have my usual reservations. I absolutely hate
> papering over scalability issues, and historically whenever people
> have ever thought that we want complex spinlocks, the problem has
> always been that the locking sucks.
> 
> So reinforced by previous events, I really feel that code that needs
> this kind of spinlock is broken and needs to be fixed, rather than
> actually introduce tricky spinlocks.
> 
> So in order to merge something like this, I want (a) numbers for real
> loads and (b) explanations for why the spinlock users cannot be fixed.
> 
> Because "we might hit loads" is just not good enough. I would counter
> with "hiding problems causes more of them".
> 

Hi, all

Off-topic, although I am in this community for several years,
I am not exactly clear with this problem.

1) In general case, which lock is the most competitive in the kernel? what it protects for?
2) In which special case, which lock is the most competitive in the kernel? what it protects for?
3) In general case, which list is the most hot list?
4) In which special case, which list is the most hot list?

thanks,
Lai
