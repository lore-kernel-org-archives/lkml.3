Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbaLVUm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 15:42:27 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:56703 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbaLVUmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 15:42:25 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "davej \@mail.xmission.com\>\> Dave Jones" <davej@redhat.com>
References: <54982C98.9070806@oracle.com>
	<CAPAsAGzHyx=9oy7ZFdL3dERrKR3or_PiDqm_chbDRvx+c3ZHPg@mail.gmail.com>
	<87oaqvd6ni.fsf@x220.int.ebiederm.org>
	<CAPAsAGwRL-fg10cPYREbXmsk09EU4qVz-3AX+OkR-QifmOW2kQ@mail.gmail.com>
	<54985F05.2040603@oracle.com>
Date: Mon, 22 Dec 2014 14:39:54 -0600
In-Reply-To: <54985F05.2040603@oracle.com> (Sasha Levin's message of "Mon, 22
	Dec 2014 13:12:21 -0500")
Message-ID: <87sig7beqt.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+PdJ8BTqZMfO2+E49Af5kw8QXyX9sgz5E=
X-SA-Exim-Connect-IP: 97.121.85.189
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4550]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_12 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sasha Levin <sasha.levin@oracle.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 259 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 3.1 (1.2%), b_tie_ro: 2.0 (0.8%), parse: 1.15 (0.4%),
	extract_message_metadata: 19 (7.2%), get_uri_detail_list: 1.78 (0.7%),
	tests_pri_-1000: 8 (3.0%), tests_pri_-950: 1.38 (0.5%), tests_pri_-900: 1.21
	(0.5%), tests_pri_-400: 22 (8.7%), check_bayes: 21 (8.1%), b_tokenize: 8
	(2.9%), b_tok_get_all: 6 (2.5%), b_comp_prob: 2.8 (1.1%), b_tok_touch_all:
	2.1 (0.8%), b_finish: 0.67 (0.3%), tests_pri_0: 193 (74.7%), tests_pri_500: 6
	(2.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: fs: proc: gpf in find_entry
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <sasha.levin@oracle.com> writes:

> On 12/22/2014 12:52 PM, Andrey Ryabinin wrote:
>> 2014-12-22 18:51 GMT+03:00 Eric W. Biederman <ebiederm@xmission.com>:
>>> These two instructions:
>>>>>   11:   4d 85 ff                test   %r15,%r15
>>>>>   14:   0f 84 de 01 00 00       je     0x1f8
>>>
>>> Should prevent a NULL %r15 value from ever reaching the trapping
>>> instruction.
>> 
>> If they were executed, then yes. But I think there was jump from somewhere
>> to the instructions below those two.
>
> There is indeed a jump direct to that point, which avoids the %r15
> check.

Where do you see that direct jump, that certainly has not been posted
in this thread?

There are certainly no such code paths I in the source code.  There is
only one NULL pointer check in find_entry and it is executed every time
the loop executes.

So at this point all I know is some set of tools has totally destroyed
the code and made what Sasha Levin's is testing so far from the source
code that this is a useless bug report.

I have no reason to even suspect this bug is actually in the upstream
kernel.

This appears to be a kind of testing that slows development and wastes
peoples time.  Can someone give me a patch that sets the TAINTED flag
when KASAN is loaded?

Eric

