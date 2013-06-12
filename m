Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790Ab3FLByX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 21:54:23 -0400
Received: from out04.mta.xmission.com ([166.70.13.234]:56427 "EHLO
	out04.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab3FLByV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 21:54:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Raphael S. Carvalho" <raphael.scarv@gmail.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
References: <1370901398-8989-1-git-send-email-raphael.scarv@gmail.com>
	<20130611154518.fda9262961c21e96a57cbd5e@linux-foundation.org>
	<8761xkt9fh.fsf@xmission.com>
	<20130611182831.8d6d25be.akpm@linux-foundation.org>
Date: Tue, 11 Jun 2013 18:53:50 -0700
In-Reply-To: <20130611182831.8d6d25be.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 11 Jun 2013 18:28:31 -0700")
Message-ID: <87k3m0rt5d.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19KgOSfjIy1u5U8DUrOS2DV6UIYe+PU1Y4=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/1] kernel/pid.c: Masking the flag out to get the actual value.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Tue, 11 Jun 2013 18:16:50 -0700 ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> 
>> > Hopefully we can fix this one by adding the missing comment.
>> 
>> Perhaps we can fix this one by having people who care read the code and 
>> think about what it means?
>
> As is obvious from this thread, that approach isn't working.
>
>>  Seriously if we are adding pids/processes in
>> the pid namespace why would to clean up the pid namespace?
>
> A good way to communicate the design would be to describe the semantics
> of PIDNS_HASH_ADDING, at its definition site.
>
> [idly wonders what the heck pid_namespace.level and pid.level do,
> sigh]

Explaining the semantics a bit more seems reasonable.

Something like:

unsigned int level;  /* How deeply nested is this pid namespace */

#define PIDNS_HASH_ADDING (1U << 31)  /* Process are still entering the pid namespace */

Sorry I don't have the focus to make that into a proper patch.


Eric

