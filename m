Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbaHAHtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 03:49:17 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:57875 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaHAHtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 03:49:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bert Wesarg <bert.wesarg@googlemail.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-api@vger.kernel.org,
        "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>,
        linux-fsdevel@vger.kernel.org,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
	<CAKPyHN1k80fc0hkg7agMkCMDsb623=Zf-TrpyMiMLvtYEjz3_Q@mail.gmail.com>
Date: Fri, 01 Aug 2014 00:45:23 -0700
In-Reply-To: <CAKPyHN1k80fc0hkg7agMkCMDsb623=Zf-TrpyMiMLvtYEjz3_Q@mail.gmail.com>
	(Bert Wesarg's message of "Fri, 1 Aug 2014 09:14:45 +0200")
Message-ID: <871tt08xgs.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18gzPNbVNPcofUkTX2FqOm3hBsLSZIhRGA=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4978]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Bert Wesarg <bert.wesarg@googlemail.com>
X-Spam-Relay-Country: 
Subject: Re: [REVIEW][PATCH 0/4] /proc/thread-self
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bert Wesarg <bert.wesarg@googlemail.com> writes:

> On Fri, Aug 1, 2014 at 2:30 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> This patchset implements /proc/thread-self a magic symlink that
>> solves a couple of problems.
>
> shouldn't we keep the 'task' in the name, as it points into the 'task'
> directory? And why not mimic the current 'self -> <id>' ideom under
> /proc/<tgid>/task too and put a new 'self' link there:
>
> $ ls -l /proc/self/task/self
>   lrwxrwxrwx 1 root root 0 Aug  1 00:00 /proc/self/task/self -> 484

No particularly good reason.  

Mostly I picked thread-self as I could pick that out as a concept in the
code distinct from self and distinct from thread and it the
implementation was stratighforward.

Your approach requires a bit more symlink recursion than mine so it is
not my first choice.

I almost pointed it at just the sometimes invisible thread directory
directly under /proc so it would be a single number.  But that has the
issue that it you still get the process rollups in the numbers reported
by some of the proc files, which is undesirable.

Frankly I think it was a mistake by the nptl kernel code to have changed
the implementation of self.  But changing /proc/self to return the tid
at this point is more likely than not to beak applications so that I
have avoided.

Eric

