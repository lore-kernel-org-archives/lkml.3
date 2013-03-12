Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933829Ab3CLWjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:39:47 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49448 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933717Ab3CLWjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:39:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Travis <travis@sgi.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
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
References: <20130312193823.212544181@gulag1.americas.sgi.com>
	<20130312193824.025713118@gulag1.americas.sgi.com>
	<87obeo7530.fsf@xmission.com> <513FA625.2020300@sgi.com>
Date: Tue, 12 Mar 2013 15:39:31 -0700
In-Reply-To: <513FA625.2020300@sgi.com> (Mike Travis's message of "Tue, 12 Mar
	2013 15:03:17 -0700")
Message-ID: <87li9sp7j0.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/KHog1ZhxPUyQoDb6muIulp0rs9KQtTI8=
X-SA-Exim-Connect-IP: 208.54.5.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mike Travis <travis@sgi.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 05/14] KDB: add more exports for supporting KDB modules
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:

> Let me see if I can understand the concept better.  By denying
> an external hardware vendor the use of KDB to support a significant
> piece of proprietary hardware on Linux, I furthering the interests
> of Linux and the community how?

By ignoring interests of someone who does not coopearte with the
community we encourage people to cooperate with the community.

> Looking back at the KDB sources originally posted on oss.sgi.com I
> did not see any restrictions on the use of KDB.  How/why was that
> restriction granted and by whom?  Was SGI, the original copyright
> owner of KDB, asked or even informed of that decision?  I'm not
> trying to be a lawyer here, but someone decided (perhaps wrongly)
> that KDB should only be used by GPL modules.

The symbols quoted below are have absolutely nothing to do with KDB
ever.  They are pieces of code that you should only use in very
exceptional circumpstances, or you risk breaking the kernel in strange
and mysterious ways.

Beyond that there are modules with GPL compatible licenses.  That is the
only kind of module that the kernel license allows.

> I'm not married to this matter by any means and I will change them all
> if that's what's needed for acceptance.  But I do think that placing
> unnecessary roadblocks in the path of developing more capabilities
> for the Linux system, is causing a disservice to the the users of
> Linux and the overall Linux community.

A capability that no one else can use, and that generates support
requests that can not be supported is not developing more capabilities
for the Linux system.  It is denying those of us who ask for repayment
in code, our compensation.  It is theft.

Eric

>>> --- linux.orig/kernel/signal.c
>>> +++ linux/kernel/signal.c
>>> @@ -1419,7 +1419,7 @@ out_unlock:
>>>   	rcu_read_unlock();
>>>   	return ret;
>>>   }
>>> -EXPORT_SYMBOL_GPL(kill_pid_info_as_cred);
>>> +EXPORT_SYMBOL(kill_pid_info_as_cred);
>>>
>>>   /*
>>>    * kill_something_info() interprets pid in interesting ways just like kill(2).
>>> @@ -2491,7 +2491,7 @@ out:
>>>   }
>>>
>>>   EXPORT_SYMBOL(recalc_sigpending);
>>> -EXPORT_SYMBOL_GPL(dequeue_signal);
>>> +EXPORT_SYMBOL(dequeue_signal);
>>>   EXPORT_SYMBOL(flush_signals);
>>>   EXPORT_SYMBOL(force_sig);
>>>   EXPORT_SYMBOL(send_sig);
>>> @@ -3661,4 +3661,5 @@ kdb_send_sig_info(struct task_struct *t,
>>>   	else
>>>   		kdb_printf("Signal %d is sent to process %d.\n", sig, t->pid);
>>>   }
>>> +EXPORT_SYMBOL(kdb_send_sig_info);
>>>   #endif	/* CONFIG_KGDB_KDB */
