Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411AbaGURwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:52:42 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:58896 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647AbaGURwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:52:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Richard Weinberger <richard@nod.at>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        LKML <linux-kernel@vger.kernel.org>
References: <OF6F10655B.C9BFC08D-ONC1257D18.003D22DF-C1257D18.003E2204@transmode.se>
	<87lhrpayl4.fsf@igel.home>
	<OF152BAB0C.4FB2E7A9-ONC1257D1B.0031887F-C1257D1B.0031B248@transmode.se>
	<87fvhwxps6.fsf@igel.home>
	<CAFLxGvyAzUwMqi5vAGzoUoP6J4m+6FGC-J4=zKG2ZGguTgO8cg@mail.gmail.com>
	<87bnskxn7g.fsf@igel.home> <53CBB143.1020206@nod.at>
Date: Mon, 21 Jul 2014 10:48:55 -0700
In-Reply-To: <53CBB143.1020206@nod.at> (Richard Weinberger's message of "Sun,
	20 Jul 2014 14:08:35 +0200")
Message-ID: <87k376siuw.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+j+anHHxnRry7BOU8R/dQQfX8QZ+1i+HQ=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4705]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Richard Weinberger <richard@nod.at>
X-Spam-Relay-Country: 
Subject: Re: ls -l /proc/1/exe -> Permission denied
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard@nod.at> writes:

> Am 20.07.2014 13:51, schrieb Andreas Schwab:
>> Richard Weinberger <richard.weinberger@gmail.com> writes:
>>> Do you have an example?
>> 
>> proc symlinks are special because they actually resolve to the inode.
>
> Ah. If an attacker manages the kernel to follow the symlink he could
> indirectly access that file.
> Thanks for pointing this out!

We only allow this access for processes that we are allowed to ptrace
because knowing intimate details of a process such as which files it has
open and in this case which file it is executing can make it more
attackable. (Say by looking to see if a processes is still running some
old vulnerable version and hasn't been restarted yet).

Normally this only applies to processes owned by different users.

However some configurations restrict ptrace on processes that you own.
You will have to look at the ``security'' modules you have enabled
and configured to see what that policy is, to see why you aren't allowed
to access your own processes.

Eric
