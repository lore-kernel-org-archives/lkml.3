Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbaB0S0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 13:26:32 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:55098 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbaB0S0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 13:26:30 -0500
Date: Thu, 27 Feb 2014 19:26:09 +0100
From: Guillaume Morin <guillaume@morinfr.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        matt.helsley@gmail.com, davem@davemloft.net, guillaume@morinfr.org
Subject: Re: + exitc-call-proc_exit_connector-after-exit_state-is-set.patch
 added to -mm tree
Message-ID: <20140227182609.GA26307@bender.morinfr.org>
Mail-Followup-To: Oleg Nesterov <oleg@redhat.com>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	matt.helsley@gmail.com, davem@davemloft.net, guillaume@morinfr.org
References: <530bbf59.78aTdR6Ql6kCpXnE%akpm@linux-foundation.org>
 <20140225151043.GA24546@redhat.com>
 <20140227144826.GA13313@bender.morinfr.org>
 <20140227164750.GC909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227164750.GC909@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Feb 17:47, Oleg Nesterov wrote:
> Anyway, I only tried to say that "a small window between when the event
> is delivered and the child become wait()-able." is not closed by this
> patch. Sorry for not being clear enough.

Ok, thanks for it making it clear.

> Nevermind. Please consider this trivial example:
> 
> 	tfunc(void *)
> 	{
> 		for (;;)
> 			pause();
> 	}
> 
> 	int main(void)
> 	{
> 		pthread_create(tfunc);
> 		pthread_exit();
> 	}
> 
> The main thread can exit and call proc_exit_connector() before
> register_interest_for_pid(), but WNOHANG obviously can't succeed.
 
What matters is not the exit message of the main thread but the exit
message from the last threaded dying.  In your example, it's fine that
waitpid fails since the process is still around.  If you kill it, the
connector will get a connector message for the thread you created in
main().

> But let me repeat just in case: I am not arguing with this change.

That was my understanding from my message.  But I wanted to respond to
make sure I understood your points correctly.

Thanks for your help.  I appreciate it.

Guillaume.

-- 
Guillaume Morin <guillaume@morinfr.org>
