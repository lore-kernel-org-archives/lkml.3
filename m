Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab3H0V5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 17:57:15 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48648 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab3H0V5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 17:57:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <878uzmhkqg.fsf@xmission.com>
	<CALCETrWPDzuoaJp2ko5jAbwYUBqSdPjvO5uGo-gZVsS4Wm1PKQ@mail.gmail.com>
Date: Tue, 27 Aug 2013 14:57:05 -0700
In-Reply-To: <CALCETrWPDzuoaJp2ko5jAbwYUBqSdPjvO5uGo-gZVsS4Wm1PKQ@mail.gmail.com>
	(Andy Lutomirski's message of "Tue, 27 Aug 2013 14:47:07 -0700")
Message-ID: <87a9k2g5la.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18GNZngfEeHFrb16oEMDib+7NI7BgRUgH0=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0027]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: [REVIEW][PATCH 1/2] userns: Better restrictions on when proc and sysfs can be mounted
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Tue, Aug 27, 2013 at 2:44 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> Rely on the fact that another flavor of the filesystem is already
>> mounted and do not rely on state in the user namespace.
>
> Possibly dumb question: does this check whether the pre-existing mount
> has hidepid set?

Not currently. 

It may be worth doing something with respect to hidepid.  I forget what
hidepid tries to do, and I need to dash.  But feel free to cook up a
follow on patch.

My goal is simply to reduce the hack level and increase the readability
and maintainability of the code.

Eric
