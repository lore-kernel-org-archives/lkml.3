Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964789Ab3CLXD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:03:28 -0400
Received: from relay3.sgi.com ([192.48.152.1]:60214 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933676Ab3CLXDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 19:03:24 -0400
Message-ID: <513FB434.4050908@sgi.com>
Date: Tue, 12 Mar 2013 16:03:16 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jason Wessel <jason.wessel@windriver.com>,
        Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cong Wang <amwang@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH 05/14] KDB: add more exports for supporting KDB modules
References: <20130312193823.212544181@gulag1.americas.sgi.com> <20130312193824.025713118@gulag1.americas.sgi.com> <87obeo7530.fsf@xmission.com> <513FA625.2020300@sgi.com> <87li9sp7j0.fsf@xmission.com>
In-Reply-To: <87li9sp7j0.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 3/12/2013 3:39 PM, Eric W. Biederman wrote:
> Mike Travis <travis@sgi.com> writes:
> 
>> Let me see if I can understand the concept better.  By denying
>> an external hardware vendor the use of KDB to support a significant
>> piece of proprietary hardware on Linux, I furthering the interests
>> of Linux and the community how?
> 
> By ignoring interests of someone who does not cooperate with the
> community we encourage people to cooperate with the community.

I can see this point.
> 
>> Looking back at the KDB sources originally posted on oss.sgi.com I
>> did not see any restrictions on the use of KDB.  How/why was that
>> restriction granted and by whom?  Was SGI, the original copyright
>> owner of KDB, asked or even informed of that decision?  I'm not
>> trying to be a lawyer here, but someone decided (perhaps wrongly)
>> that KDB should only be used by GPL modules.
> 
> The symbols quoted below are have absolutely nothing to do with KDB
> ever.  They are pieces of code that you should only use in very
> exceptional circumpstances, or you risk breaking the kernel in strange
> and mysterious ways.

Yes, those below were indeed a mistake on my part.  Thanks for catching that.
> 
> Beyond that there are modules with GPL compatible licenses.  That is the
> only kind of module that the kernel license allows.

Okay.
> 
>> I'm not married to this matter by any means and I will change them all
>> if that's what's needed for acceptance.  But I do think that placing
>> unnecessary roadblocks in the path of developing more capabilities
>> for the Linux system, is causing a disservice to the the users of
>> Linux and the overall Linux community.
> 
> A capability that no one else can use, and that generates support
> requests that can not be supported is not developing more capabilities
> for the Linux system.  It is denying those of us who ask for repayment
> in code, our compensation.  It is theft.

Not sure I've ever looked at it this way, but again I can see your point.
> 
> Eric

Thanks for the meaningful feedback Eric.

Mike

> 
>>>> --- linux.orig/kernel/signal.c
>>>> +++ linux/kernel/signal.c
>>>> @@ -1419,7 +1419,7 @@ out_unlock:
>>>>    	rcu_read_unlock();
>>>>    	return ret;
>>>>    }
>>>> -EXPORT_SYMBOL_GPL(kill_pid_info_as_cred);
>>>> +EXPORT_SYMBOL(kill_pid_info_as_cred);
>>>>
>>>>    /*
>>>>     * kill_something_info() interprets pid in interesting ways just like kill(2).
>>>> @@ -2491,7 +2491,7 @@ out:
>>>>    }
>>>>
>>>>    EXPORT_SYMBOL(recalc_sigpending);
>>>> -EXPORT_SYMBOL_GPL(dequeue_signal);
>>>> +EXPORT_SYMBOL(dequeue_signal);
>>>>    EXPORT_SYMBOL(flush_signals);
>>>>    EXPORT_SYMBOL(force_sig);
>>>>    EXPORT_SYMBOL(send_sig);
>>>> @@ -3661,4 +3661,5 @@ kdb_send_sig_info(struct task_struct *t,
>>>>    	else
>>>>    		kdb_printf("Signal %d is sent to process %d.\n", sig, t->pid);
>>>>    }
>>>> +EXPORT_SYMBOL(kdb_send_sig_info);
>>>>    #endif	/* CONFIG_KGDB_KDB */
