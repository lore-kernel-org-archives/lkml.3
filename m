Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab3CLWDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:03:23 -0400
Received: from relay1.sgi.com ([192.48.179.29]:58380 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190Ab3CLWDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:03:22 -0400
Message-ID: <513FA625.2020300@sgi.com>
Date: Tue, 12 Mar 2013 15:03:17 -0700
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
References: <20130312193823.212544181@gulag1.americas.sgi.com> <20130312193824.025713118@gulag1.americas.sgi.com> <87obeo7530.fsf@xmission.com>
In-Reply-To: <87obeo7530.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let me see if I can understand the concept better.  By denying
an external hardware vendor the use of KDB to support a significant
piece of proprietary hardware on Linux, I furthering the interests
of Linux and the community how?

Looking back at the KDB sources originally posted on oss.sgi.com I
did not see any restrictions on the use of KDB.  How/why was that
restriction granted and by whom?  Was SGI, the original copyright
owner of KDB, asked or even informed of that decision?  I'm not
trying to be a lawyer here, but someone decided (perhaps wrongly)
that KDB should only be used by GPL modules.

I'm not married to this matter by any means and I will change them all
if that's what's needed for acceptance.  But I do think that placing
unnecessary roadblocks in the path of developing more capabilities
for the Linux system, is causing a disservice to the the users of
Linux and the overall Linux community.

Thanks,
Mike

On 3/12/2013 1:09 PM, Eric W. Biederman wrote:
> Mike Travis <travis@sgi.com> writes:
>
>> This patch adds some important KDB functions to be externally
>> usable by loadable KDB modules.  Note that often drivers bring
>> in KDB modules for debugging, and in the past KDB has not been
>> limited to use by GPL only modules.  This patch restores KDB
>> usefullness to non-GPL modules.
>
> It is not ok to change EXPORT_SYMBOL_GPL to EXPORT_SYMBOL.
>
> The symbols you are changing to EXPORT_SYMBOL from EXPORT_SYMBOL_GPL you
> should not even be messing with if your source code is not in the main
> kernel tree.
>
> This patch is totally not ok.
>
> I don't know what past you are referring to but you are changing symbols
> that have never been exported as anything other than EXPORT_SYMBOL_GPL
> to EXPORT_SYMBOL.  The past I remember is the past where kdb was not in
> the kernel tree at all.
>
> Please go back to the drawing board and come back with a solution where
> you are working with the community instead of trying asking the rest of
> us to support something you won't share.
>
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
>> --- linux.orig/kernel/signal.c
>> +++ linux/kernel/signal.c
>> @@ -1419,7 +1419,7 @@ out_unlock:
>>   	rcu_read_unlock();
>>   	return ret;
>>   }
>> -EXPORT_SYMBOL_GPL(kill_pid_info_as_cred);
>> +EXPORT_SYMBOL(kill_pid_info_as_cred);
>>
>>   /*
>>    * kill_something_info() interprets pid in interesting ways just like kill(2).
>> @@ -2491,7 +2491,7 @@ out:
>>   }
>>
>>   EXPORT_SYMBOL(recalc_sigpending);
>> -EXPORT_SYMBOL_GPL(dequeue_signal);
>> +EXPORT_SYMBOL(dequeue_signal);
>>   EXPORT_SYMBOL(flush_signals);
>>   EXPORT_SYMBOL(force_sig);
>>   EXPORT_SYMBOL(send_sig);
>> @@ -3661,4 +3661,5 @@ kdb_send_sig_info(struct task_struct *t,
>>   	else
>>   		kdb_printf("Signal %d is sent to process %d.\n", sig, t->pid);
>>   }
>> +EXPORT_SYMBOL(kdb_send_sig_info);
>>   #endif	/* CONFIG_KGDB_KDB */
