Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab3KOIhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 03:37:33 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:42162 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab3KOIhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 03:37:23 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <878uzmhkqg.fsf@xmission.com> <52749663.2000701@cn.fujitsu.com>
	<527C4D88.10907@cn.fujitsu.com> <87k3gigmgj.fsf@xmission.com>
	<5283299B.8080702@cn.fujitsu.com> <5284AF90.7060506@cn.fujitsu.com>
	<CALCETrXtWtF=JgiwENNzh7UZKnXijHauOQ5ZjHYxYJC-BAU5Aw@mail.gmail.com>
	<528575EC.2030309@cn.fujitsu.com> <87txfexo25.fsf@xmission.com>
	<5285BBE2.7010001@cn.fujitsu.com>
Date: Fri, 15 Nov 2013 00:37:13 -0800
In-Reply-To: <5285BBE2.7010001@cn.fujitsu.com> (Gao feng's message of "Fri, 15
	Nov 2013 14:14:58 +0800")
Message-ID: <87d2m2t612.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+NIZWS5vo8gRUOYban+f8/40fJeutEEuA=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0026]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Gao feng <gaofeng@cn.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [REVIEW][PATCH 1/2] userns: Better restrictions on when proc and sysfs can be mounted
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gao feng <gaofeng@cn.fujitsu.com> writes:

> Ok,I agree with you that we should make container security by default.
>
> What's your idea that introduces option MS_NOT_A_LOCK just like Andy's
> advisement?

It might be doable but it is unnecessary.

> In libvirt, host creates dev and devpts directories for container,then
> mount devpts, tmpfs on them and create device nodes inside these dirs
> for container. and then in container, these filesystems are moved to
> container's /dev/ /dev/pts directory. We really have no need to lock
> these mounts. they are just created for container.

If the global root creates the namespace and performs all of the mounts
it is unnecessary.

Now I believe you can create those directories for the most part as
non-root in libvirt and gain some interesting applications.

That said if you don't want locked mounts you just just be able to
create a temporary mount namespace as the global root, and do your prep
work.

Then create your unprivileged mount namespace and bind mount the
directories where you want them, and then pivot_root away the bits you
don't want.

There is already more mechanism than I like to deal with the mount
namespace I would really rather not invent/debug/support any more.

Eric
