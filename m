Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947199Ab3BHWGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:06:07 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54861 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946953Ab3BHWGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:06:05 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Josh Boyer <jwboyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, williams@redhat.com
References: <20130207215742.GB31684@hansolo.jdub.homelinux.org>
	<20130207141502.04625ea0.akpm@linux-foundation.org>
	<20130208003501.GC31684@hansolo.jdub.homelinux.org>
	<20130208181949.GD31684@hansolo.jdub.homelinux.org>
	<87k3qiwomi.fsf@xmission.com>
	<20130208202314.GF31684@hansolo.jdub.homelinux.org>
	<87r4kqttz8.fsf@xmission.com>
	<20130208212726.GH31684@hansolo.jdub.homelinux.org>
Date: Fri, 08 Feb 2013 14:05:55 -0800
In-Reply-To: <20130208212726.GH31684@hansolo.jdub.homelinux.org> (Josh Boyer's
	message of "Fri, 8 Feb 2013 16:27:26 -0500")
Message-ID: <87sj56pikc.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18TKPUYjO8Gl95IV+NYs7L6HxcelTClj0g=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0005]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Josh Boyer <jwboyer@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: Odd ENOMEM being returned in 3.8-rcX
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer <jwboyer@redhat.com> writes:

>> So it looks mock is taking a buggy untested code path and things are not
>> working as it expected.
>
> Quite possibly, yes.  I instrumented the kernel a bit and it is indeed
> failing in the alloc_pid call.
>
> Clark, thoughts here?

I will just add the solution is probably for mock to fork immediate
after the unshare succeeds in creating a pid namespace.  With the
original process waiting for mock to exit and the child process
doing everything that mock does now.

That will allow mock to act as the init process in the pid namespace it
just created.

Eric

