Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab3HFVqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:46:40 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60248 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731Ab3HFVqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:46:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Chen Gang <gang.chen@asianux.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, xi.wang@gmail.com,
        nicolas.dichtel@6wind.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <5200A5E6.9020803@asianux.com>
Date: Tue, 06 Aug 2013 14:46:03 -0700
In-Reply-To: <5200A5E6.9020803@asianux.com> (Chen Gang's message of "Tue, 06
	Aug 2013 15:29:42 +0800")
Message-ID: <8761vibihw.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/vKsYY1CXBUV/BHBkm5udcqaw4mKDdiLg=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Chen Gang <gang.chen@asianux.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] kernel/sysctl_binary.c: improve the usage of return value 'result'
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> writes:

Have you tested this code?  Do you have anything that actually the
uses sysctl binary interface?

If you do have code that actually uses this interface please fix it not
to use it.  This code is fundamentally a stop gap measure and will
bit-rot in time and then we will remove it.

> Improve the usage of return value 'result', so not only can make code
> clearer to readers, but also can improve the performance.
>
> Assign the return error code only when error occurs, so can save some
> instructions (some of them are inside looping).

That actually is a code pessimization, not an optimization.  As are most
of your proposed changes.  Only assigning the error code simply can not
generate better assembly code.

> Rewrite the sysctl_getname() to make code clearer to readers, and also
> can save some instructions (it is mainly related with the usage of the
> variable 'result').

Again you are introducing branches and pessimizing the code in the name
of optimization.

> Remove useless variable 'result' for sysctl() and compat sysctl(), when
> do_sysctl() fails, it is meaningless to assign 'oldlenp ' with original
> same value.

> Also modify the related code to pass "./scripts/checkpatch.pl" checking.

I really don't care about checpatch.pl at this point.

The right answer to the code is to config it out and then you don't have
to worry about it one way or another.

The sysctl binary path has never been properly maintained and I don't
intend to start.   But I will spend 5 minutes to say this patch seems to
make the code worse not better.

Eric
