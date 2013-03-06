Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab3CFCYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 21:24:09 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:33906 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3CFCYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 21:24:05 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rob Landley <rob@landley.net>
Cc: mtk.manpages@gmail.com, linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <1362535117.7276.6@driftwood>
Date: Tue, 05 Mar 2013 18:23:57 -0800
In-Reply-To: <1362535117.7276.6@driftwood> (Rob Landley's message of "Tue, 05
	Mar 2013 19:58:37 -0600")
Message-ID: <87k3pl2rlu.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX192/u+rRHpG2FgvuPttmrvPRk1QmUBnsVI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Rob Landley <rob@landley.net>
X-Spam-Relay-Country: 
Subject: Re: For review: pid_namespaces(7) man page
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley <rob@landley.net> writes:

> On 03/04/2013 11:52:19 AM, Eric W. Biederman wrote:
>> > How about this:
>> >
>> >        The  point  here is that unshare(2) and setns(2) change the  
>> PID
>> >        namespace for processes subsequently created by the caller,  
>> but
>> >        not  for the calling process, while clone(2) CLONE_VM  
>> specifies
>> >        the creation of a new thread in the same process.
>> 
>> Hmm.  How about this.
>> 
>>          The point here is that unshare(2) and setns(2) change the PID
>>          namespace that will be used by in all subsequent calls to  
>> clone
>>          and fork by the caller, but not for the calling process, and
>>          that all threads in a process must share the same PID
>>          namespace.  Which makes a subsequent clone(2) CLONE_VM
>>          specify the creation of a new thread in the a different PID
>>          namespace but in the same process which is impossible.
>
> CLONE_VM and CLONE_NEWPID are incompatible because all threads of the  
> same process must be in the same PID namespace. Since unshare(2) and  
> setns(2) change the PID namespace for subsequent calls to clone(2),  
> those subsequent calls cannot create new threads (unless you setns(2)  
> back to the original namespace first).
>
> That last bit's a guess. :)

Good wording thank you, and the last bit is right.  You can restore
the pid namespace  with setns(2), and that will allow thread and process
creation creation again.

Eric

