Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659Ab3CLVoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 17:44:17 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49866 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933646Ab3CLVoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 17:44:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: mtk.manpages@gmail.com
Cc: Rob Landley <rob@landley.net>, linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Vasily Kulikov <segoon@openwall.com>, Li Zefan <lizefan@huawei.com>
References: <CAKgNAkgAT8vFr7hbEzOjJG5pCt8-kh_4Wh9yrzHHXrCJ3Fhh+w@mail.gmail.com>
Date: Tue, 12 Mar 2013 14:43:58 -0700
In-Reply-To: <CAKgNAkgAT8vFr7hbEzOjJG5pCt8-kh_4Wh9yrzHHXrCJ3Fhh+w@mail.gmail.com>
	(Michael Kerrisk's message of "Tue, 12 Mar 2013 08:07:30 +0100")
Message-ID: <871ubkz42p.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18jnOey1T2rBC7jkfUPeA+GWObxhm3xafQ=
X-SA-Exim-Connect-IP: 208.54.5.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;mtk.manpages@gmail.com
X-Spam-Relay-Country: 
Subject: Re: For review: pid_namespaces(7) man page (draft 2)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

> Eric et al.,
>
> [CCing Li because of reboot(2) changes]
>
> I have (I think) addressed all previous comments in the current draft
> of the pid_namespaces(7) page. This is a final sanity check before I
> call this page complete (modulo any future kernel changes).

Baring the 3.9 reference to reboot(2) which should be 3.4 I don't see
any problems.

I think you have reached the point where if there are any problems left
I will just have to send you patches after you publish because my eyes
are glassing over and I am not going to see any more problems right now.

One of those patches I am going to have to send you is I am fixing the
case below for 3.10
>            clone(..., CLONE_VM, ...);
>            setns(fd, CLONE_NEWPID);      /* Fails */
>
>            clone(..., CLONE_VM, ...);
>            unshare(CLONE_NEWPID);        /* Fails */
>
It turns out that the check in fork/clone is sufficient.

The verbage about all of the namespaces is correct however since
unshare(CLONE_NEWPID) doesn't actually change the pid_namespace it
doesn't matter.

Eric
