Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbaHAGTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 02:19:52 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60049 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbaHAGTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 02:19:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-api@vger.kernel.org,
        "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
	<1406860795.3036.3.camel@buesod1.americas.hpqcorp.net>
Date: Thu, 31 Jul 2014 23:16:00 -0700
In-Reply-To: <1406860795.3036.3.camel@buesod1.americas.hpqcorp.net> (Davidlohr
	Bueso's message of "Thu, 31 Jul 2014 19:39:55 -0700")
Message-ID: <87ha1wag67.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/k5Q/h1oplloVwPz1kc1mEXJ2hw4FhCi0=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4993]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Davidlohr Bueso <davidlohr@hp.com>
X-Spam-Relay-Country: 
Subject: Re: [REVIEW][PATCH 0/4] /proc/thread-self
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davidlohr Bueso <davidlohr@hp.com> writes:

> On Thu, 2014-07-31 at 17:30 -0700, Eric W. Biederman wrote:
>> This is small chance changing /proc/net and /proc/mounts will cause
>> userspace regressions (although nothing has shown up in my testing) if
>> that happens we can just point the change that moves them from
>> /proc/self/... to /proc/thread-self/...
>
> Isn't breaking userspace a no no, no matter what? At least some
> util-linux programs makes use of both /proc/mounts and /proc/net.

The only programs that will notice that /proc/mounts and /proc/net have
changed where they point are multi-threaded programs.

The vast majority of multi-thread programs have the same mount namespace
and network namespace across all threads.  Those programs will simply
see the case where /proc/mounts and /proc/net work now after the initial
thread has terminated.  (A Bug fix).

For the weird multi-threaded applications that access /proc/mounts or
/proc/net and have different namespaces in different threads this most
likely is a bug fix.  But this could potentially introduce a regression.

Which is a long way of saying that we don't have to remain bug
compatible with past versions of linux if no one cares about our bugs.

So while I am seriously concerned about the possibility of introducing a
regression the only way to find out if anyone cares is to release the
code and to release these patches, and see if anything breaks.  The
changes that might have to be reverted are trivial one liners, so it
will be easy to fix if something shows up.

So if you or anyone else knows of applications that are multi-threaded
have different namespaces on different threads and depend on
/proc/mounts or /proc/net always reflecting the namespace of the initial
thread in the program let me know.  Until then this series fixes at
least one long-standing annoying bug.

Eric

