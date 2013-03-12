Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491Ab3CLUJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:09:57 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:43292 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933452Ab3CLUJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:09:55 -0400
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
Date: Tue, 12 Mar 2013 13:09:39 -0700
In-Reply-To: <20130312193824.025713118@gulag1.americas.sgi.com> (Mike Travis's
	message of "Tue, 12 Mar 2013 14:38:28 -0500")
Message-ID: <87obeo7530.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+7+i6Lx2OHTJSmvsQ/f21RpPUB54cZJ/w=
X-SA-Exim-Connect-IP: 208.54.5.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
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

> This patch adds some important KDB functions to be externally
> usable by loadable KDB modules.  Note that often drivers bring
> in KDB modules for debugging, and in the past KDB has not been
> limited to use by GPL only modules.  This patch restores KDB
> usefullness to non-GPL modules.

It is not ok to change EXPORT_SYMBOL_GPL to EXPORT_SYMBOL.

The symbols you are changing to EXPORT_SYMBOL from EXPORT_SYMBOL_GPL you
should not even be messing with if your source code is not in the main
kernel tree.

This patch is totally not ok.

I don't know what past you are referring to but you are changing symbols
that have never been exported as anything other than EXPORT_SYMBOL_GPL
to EXPORT_SYMBOL.  The past I remember is the past where kdb was not in
the kernel tree at all.

Please go back to the drawing board and come back with a solution where
you are working with the community instead of trying asking the rest of
us to support something you won't share.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

> --- linux.orig/kernel/signal.c
> +++ linux/kernel/signal.c
> @@ -1419,7 +1419,7 @@ out_unlock:
>  	rcu_read_unlock();
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(kill_pid_info_as_cred);
> +EXPORT_SYMBOL(kill_pid_info_as_cred);
>  
>  /*
>   * kill_something_info() interprets pid in interesting ways just like kill(2).
> @@ -2491,7 +2491,7 @@ out:
>  }
>  
>  EXPORT_SYMBOL(recalc_sigpending);
> -EXPORT_SYMBOL_GPL(dequeue_signal);
> +EXPORT_SYMBOL(dequeue_signal);
>  EXPORT_SYMBOL(flush_signals);
>  EXPORT_SYMBOL(force_sig);
>  EXPORT_SYMBOL(send_sig);
> @@ -3661,4 +3661,5 @@ kdb_send_sig_info(struct task_struct *t,
>  	else
>  		kdb_printf("Signal %d is sent to process %d.\n", sig, t->pid);
>  }
> +EXPORT_SYMBOL(kdb_send_sig_info);
>  #endif	/* CONFIG_KGDB_KDB */
