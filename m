Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab3GXQFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:05:46 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34200 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3GXQFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:05:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <877gghruwq.fsf@xmission.com>
	<CALCETrXXGhVbkG6AnRck+W1kMns5TJuNYAqe_tV44JvWgDoUzA@mail.gmail.com>
	<87li4wpi2b.fsf@xmission.com> <20130724124933.GA16517@mail.hallyn.com>
	<20130724153018.GA17960@mail.hallyn.com>
Date: Wed, 24 Jul 2013 09:05:36 -0700
In-Reply-To: <20130724153018.GA17960@mail.hallyn.com> (Serge E. Hallyn's
	message of "Wed, 24 Jul 2013 15:30:18 +0000")
Message-ID: <87ehaolz8v.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18uacL4OhHKyYRq/MffUKB/Ja/Hz27UiY4=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0335]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [REVIEW][PATCH] vfs: Lock in place mounts from more privileged users
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Serge E. Hallyn (serge@hallyn.com):
>> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> > 
>> > Serge does this patch break lxc?  I think all should be well but I want
>> > to make certain there is not some hidden case where this fundamentaly
>> > breaks some functionality.
>> 
>> I haven't yet tried.  I'll build and test a kernel today.  I'm pretty
>> sure all the child's mounts are done after clone, so I *think* the worst
>> case will be that the unmounting of put_old after pivot_root() will
>> be noisy.  Will let you know.
>> 
>> -serge
>
> Just tested it - works fine.  Warns about all of the failed umounts.

Just to confirm.  Can you do a lazy umount of put_old and get rid of
them?

> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
>
> ( Mind you I'm not approving of the idea of hiding mounts as a security
> mechanisms, but I know that neither are you :)

As a security mechanism, not really.  This is more about closing a
theoretical hole in case someone was sloppy, and doing it before user
namespaces are too widely deployed so we avoid massive user space
breakage.  It let's me sleep more soundly at night if I know you can't
more access more with user namespaces that you can without user
namespaces.

Eric

