Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbaHAHFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 03:05:06 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42511 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbaHAHFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 03:05:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-api@vger.kernel.org,
        "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
	<53DB3790.7020600@infradead.org>
Date: Fri, 01 Aug 2014 00:01:13 -0700
In-Reply-To: <53DB3790.7020600@infradead.org> (Randy Dunlap's message of "Thu,
	31 Jul 2014 23:45:36 -0700")
Message-ID: <8738dgae2u.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+qSZayKZOFUDMihy++7wFTAGZHLkBbWhE=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2116]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Randy Dunlap <rdunlap@infradead.org>
X-Spam-Relay-Country: 
Subject: Re: [REVIEW][PATCH 0/4] /proc/thread-self
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> writes:

> On 07/31/14 17:30, Eric W. Biederman wrote:
>> 
>> This patchset implements /proc/thread-self a magic symlink that
>> solves a couple of problems.
>> 
>> - It makes it easy to get to a specific threads directory in /proc
>>   with gettid() not being exported in glibc this is currently a pain.
>> 
>> - It allows fixing the problem present in /proc/mounts and /proc/net
>>   that when the thread group leader exits but the entire thread group
>>   remains /proc/self/net and /proc/self/mounts and thus /proc/mounts and
>>   /proc/net become empty.
>> 
>> - As mount and network namespaces are per thread it allows /proc/net and
>>   /proc/mounts to reflect this.
>
> Hi Eric,
>
> Any changes/additions to Documentation/ ?

Not at this time.  I can imagine that there is proc manpage that might
need a line or two of Documentation.

I am not familiar with anything in Documentation that descripes any of
this and would benefit from an update.  From an overview perspective I
can see documenting this so people know thread-self exists.  From an
actual usage perspective:

  $ ls -l /proc/thread-self
  lrwxrwxrwx 1 root root 0 Aug  1 00:00 /proc/thread-self -> 484/task/484

seems like pretty comprehensive documentation to me.

Eric
