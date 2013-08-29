Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3H2A1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 20:27:08 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44175 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab3H2A1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 20:27:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Solar Designer <solar@openwall.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "kernel-hardening\@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>
References: <1377534240-13227-1-git-send-email-tixxdz@opendz.org>
	<871u5gqtw3.fsf@xmission.com>
	<20130826172054.GE27005@ZenIV.linux.org.uk>
	<20130827172406.GA2664@dztty> <20130828201141.GA21455@dztty>
	<CAGXu5jJ2yop1JrJT1nzKWoT_Q83s9fGK_2BuBcCotHCR9YecDQ@mail.gmail.com>
	<20130828211116.GA22184@dztty>
Date: Wed, 28 Aug 2013 17:26:56 -0700
In-Reply-To: <20130828211116.GA22184@dztty> (Djalal Harouni's message of "Wed,
	28 Aug 2013 22:11:17 +0100")
Message-ID: <87sixt735b.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19TL4BZBQdAfUXTIbJk1L/xyNzegu5XtOM=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0614]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Djalal Harouni <tixxdz@opendz.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/2] procfs: restore 0400 permissions on /proc/*/{syscall,stack,personality}
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have take a moment and read this thread, and have been completely
unenlightend.  People are upset but it is totally unclear why.

There is no explanation why it is ok to ignore the suid-exec case, as
the posted patches do.  Which ultimately means the patches provide
little to no security benefit, and that the posted patches as written
are broken.

There is no clear explanation of what people are worried about.
References to other threads and other commits do not help.

Can someome please state what they are worried about in simple language
step by step?

I see absolutely nothing to overturn Al's analysis that these files
simply don't need protection.



The closest I saw in the thread was people were worried about ASLR being
defeated.  All I see are kernel addresses and we don't have much if any
runtime or even load time randomization of where code is located in the
kernel address map on x86_64.  So I don't understand the concern.

Certainly all of the clever applications and use of suid apps appear to
be jumping around crazy hoops and to achieve what I can achieve with a
simple cat of a file.

Eric
